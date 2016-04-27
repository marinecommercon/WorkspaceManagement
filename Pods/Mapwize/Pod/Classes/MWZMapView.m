#import "MWZMapView.h"
#import <WebKit/WebKit.h>
#import "MWZMapDelegate.h"
#import "MWZMapOptions.h"

#define SERVER_URL @"https://www.mapwize.io"
#define SDK_VERSION @"1.4.x"
#define IOS_SDK_VERSION @"1.4.0"
#define IOS_SDK_NAME @"IOS SDK"

@implementation MWZMapView {
    WKWebView* _webview;
    NSNumber* _floor;
    NSArray* _floors;
    NSNumber* _zoom;
    BOOL _followUserModeON;
    BOOL _isWebviewLoaded;
    MWZMeasurement* _userPosition;
    NSMutableArray* _jsQueue;
    MWZLatLon* _center;
    MWZMapOptions* _options;
    NSMutableDictionary* callbackMemory;
}

- (void) loadMapWithOptions: (MWZMapOptions*) options {
    _isWebviewLoaded = NO;
    _jsQueue = [[NSMutableArray alloc] init];
    callbackMemory = [[NSMutableDictionary alloc] init];

    
    /*
     * Configures Location manager (authorizations need to be requested outside the SDK)
     */
    _locationManager = [[CLLocationManager alloc] init];    
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    /*
     * Loads the webview
     */
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"MWZMapEvent"];
    
    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    [configuration setUserContentController: userContentController];
    [self setBackgroundColor:[UIColor greenColor]];
    _webview = [[WKWebView alloc] initWithFrame:[self frame] configuration:configuration];
    _webview.navigationDelegate = self;
    [self addSubview:_webview];

    [_webview loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/sdk/mapwize-ios-sdk/%@/map.html", SERVER_URL, SDK_VERSION]]]];
    [_webview setTranslatesAutoresizingMaskIntoConstraints:NO];
    _webview.scrollView.bounces = NO;
    [self addWebViewConstraints];
    [self executeJS:[NSString stringWithFormat:@"Mapwize.config.SERVER = '%@'; Mapwize.config.SDK_NAME = '%@'; Mapwize.config.SDK_VERSION = '%@'; Mapwize.config.CLIENT_APP_NAME = '%@'; ",
                     SERVER_URL, IOS_SDK_NAME, IOS_SDK_NAME, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]]];
    
    /*
     * Handles the options
     */
    NSMutableDictionary* optionsDic = [[NSMutableDictionary alloc] init];
    if (options.apiKey != nil) {
        [optionsDic setObject:options.apiKey forKey:@"apiKey"];
    }
    if (options.maxBounds != nil) {
        [optionsDic setObject:[options.maxBounds toArray] forKey:@"maxBounds"];
    }
    if (options.center != nil) {
        [optionsDic setObject:[options.center toArray] forKey:@"center"];
    }
    if (options.zoom != nil) {
        [optionsDic setObject:options.zoom forKey:@"zoom"];
    }
    if (options.floor != nil) {
        [optionsDic setObject:options.floor forKey:@"floor"];
    }
    [optionsDic setObject:@0 forKey:@"useBrowserLocation"];
    [optionsDic setObject:@0 forKey:@"zoomControl"];
    
    NSData *optionsJson = [NSJSONSerialization dataWithJSONObject:optionsDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* optionsString = [[NSString alloc] initWithData:optionsJson encoding:NSUTF8StringEncoding];
    
    /*
     * Set up the map with the options
     */
    [self executeJS:[NSString stringWithFormat:@"var map = Mapwize.map('map',%@);",optionsString]];

    /*
     * Register the event handlers
     */
    [self executeJS:@"map.on('zoomend', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, zoom:map.getZoom()});});"];
    [self executeJS:@"map.on('click', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, latlng:e.latlng});});"];
    [self executeJS:@"map.on('contextmenu', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, latlng:e.latlng});});"];
    [self executeJS:@"map.on('floorsChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, floors:this._floors});});"];
    [self executeJS:@"map.on('floorChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, floor:this._floor});});"];
    [self executeJS:@"map.on('placeClick', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, place:e.place});});"];
    [self executeJS:@"map.on('venueClick', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, venue:e.venue});});"];
    [self executeJS:@"map.on('markerClick', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, lat:e.latlng.lat, lon:e.latlng.lng, floor:e.floor});});"];
    [self executeJS:@"map.on('moveend', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, center:map.getCenter()});});"];
    [self executeJS:@"map.on('userPositionChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, userPosition:e.userPosition});});"];
    [self executeJS:@"map.on('followUserModeChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, followUserMode:e.active});});"];
    [self executeJS:@"map.on('directionsStart', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, info:'Directions have been loaded'});});"];
    [self executeJS:@"map.on('directionsStop', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, info:'Directions have stopped'});});"];
    [self executeJS:@"map.on('monitoredUuidsChange', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, uuids:e.uuids});});"];
    [self executeJS:@"map.on('apiResponse', function(e){window.webkit.messageHandlers.MWZMapEvent.postMessage({type:e.type, returnedType: e.returnedType, hash:e.hash, response:e.response});});"];

}

- (void) executeJS:(NSString*) js {
    
    if (_isWebviewLoaded) {
        [_webview evaluateJavaScript:js completionHandler:^(id result, NSError *error) {
            if (error != nil) {
                if (error.code != 5 && self.delegate != nil) {
                    NSError* err = [[NSError alloc] initWithDomain:@"MWZErrorDomain" code:1936 userInfo:nil];
                    [self.delegate map:self didFailWithError:err];
                }
            }
        }];
    } else {
        [_jsQueue addObject:js];
    }
    
}

/*
 * Handle the full load of the webview. Any command that was queued so far is executed.
 */
- (void)webView:(WKWebView *)_webView didFinishNavigation:(WKNavigation *)navigation {
    
    while ([_jsQueue count] > 0) {
        NSString* js = [_jsQueue objectAtIndex:0];
        [_jsQueue removeObjectAtIndex:0];
        [_webview evaluateJavaScript:js completionHandler:^(id result, NSError *error) {
            if (error != nil) {
                if (error.code != 5 && self.delegate != nil) {
                    NSError* err = [[NSError alloc] initWithDomain:@"MWZErrorDomain" code:1936 userInfo:nil];
                    [self.delegate map:self didFailWithError:err];
                }
            }
        }];
        
    }
    
    _isWebviewLoaded = YES;
    
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if (self.delegate != nil) {
        [self.delegate map:self didFailWithError:error];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.delegate != nil) {
        [self.delegate map:self didFailWithError:error];
    }
}


/*
 * Handle the events sent by the js sdk
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    NSDictionary* body = message.body;
    if ([body[@"type"] isEqualToString:@"zoomend"]) {
        _zoom = body[@"zoom"];
        if (self.delegate != nil) {
            [self.delegate map:self didChangeZoom:_zoom];
        }
    }
    else if ([body[@"type"] isEqualToString:@"click"]) {
        if (self.delegate != nil) {
            NSDictionary* latlng = body[@"latlng"];
            NSNumber* lat = latlng[@"lat"];
            NSNumber* lng = latlng[@"lng"];
            [self.delegate map:self didClick:[[MWZLatLon alloc] initWithLatitude:lat longitude:lng]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"contextmenu"]) {
        if (self.delegate != nil) {
            NSDictionary* latlng = body[@"latlng"];
            NSNumber* lat = latlng[@"lat"];
            NSNumber* lng = latlng[@"lng"];
            [self.delegate map:self didClickLong:[[MWZLatLon alloc] initWithLatitude:lat longitude:lng]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"floorsChange"]) {
        _floors = body[@"floors"];
        if (self.delegate != nil) {
            [self.delegate map:self didChangeFloors:_floors];
        }
    }
    else if ([body[@"type"] isEqualToString:@"floorChange"]) {
        _floor = body[@"floor"];
        if (self.delegate != nil) {
            [self.delegate map:self didChangeFloor:_floor];
        }
    }
    else if ([body[@"type"] isEqualToString:@"placeClick"]) {
        if (self.delegate != nil) {
            [self.delegate map:self didClickOnPlace:[[MWZPlace alloc] initFromDictionnary:body[@"place"]]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"venueClick"]) {
        if (self.delegate != nil) {
            [self.delegate map:self didClickOnVenue:[[MWZVenue alloc] initFromDictionnary:body[@"venue"]]];
        }
    }
    else if ([body[@"type"] isEqualToString:@"markerClick"]) {
        MWZPosition* position = [[MWZPosition alloc] initWithLatitude:body[@"lat"] longitude:body[@"lon"] floor:body[@"floor"]];
        if (self.delegate != nil) {
            [self.delegate map:self didClickOnMarker:position];
        }
    }
    else if ([body[@"type"] isEqualToString:@"moveend"]) {
        NSDictionary* latlng = body[@"center"];
        NSNumber* lat = latlng[@"lat"];
        NSNumber* lng = latlng[@"lng"];
        _center = [[MWZLatLon alloc] initWithLatitude:lat longitude:lng];
        [self.delegate map:self didMove:_center];
    }
    else if ([body[@"type"] isEqualToString:@"userPositionChange"]) {
        MWZMeasurement* userPosition = [[MWZMeasurement alloc] initFromDictionnary:body[@"userPosition"]];
        _userPosition = userPosition;
        if (self.delegate != nil) {
            [self.delegate map:self didChangeUserPosition:userPosition];
        }
    }
    else if ([body[@"type"] isEqualToString:@"followUserModeChange"]) {
        _followUserModeON = [body[@"followUserMode"] boolValue];;
        if (self.delegate != nil) {
            [self.delegate map:self didChangeFollowUserMode:_followUserModeON];
        }
    }
    else if ([body[@"type"] isEqualToString:@"directionsStart"]) {
        if (self.delegate != nil) {
            NSString* info = body[@"info"];
            [self.delegate map:self didStartDirections:info];
        }
    }
    else if ([body[@"type"] isEqualToString:@"directionsStop"]) {
        if (self.delegate != nil) {
            NSString* info = body[@"info"];
            [self.delegate map:self didStopDirections:info];
        }
    }
    else if ([body[@"type"] isEqualToString:@"monitoredUuidsChange"]) {
        NSArray* uuids = body[@"uuids"];
        [ self updateMonitoring: uuids ];
    }
    else if ([body[@"type"] isEqualToString:@"apiResponse"]) {
        NSString* hash = body[@"hash"];
        NSString* returnedType = body[@"returnedType"];
        NSDictionary* response = body[@"response"];
        
        if ([returnedType isEqualToString:@"place"]) {
            void(^_handler)(MWZPlace*);
            _handler = callbackMemory[hash];
            if (response[@"_id"] != nil){
                MWZPlace* place = [[MWZPlace alloc] initFromDictionnary:body[@"response"]];
                _handler(place);
            }
            else {
                _handler(nil);
            }
        }
        else if ([returnedType isEqualToString:@"venue"]) {
            void(^_handler)(MWZVenue*);
            _handler = callbackMemory[hash];
            if (response[@"_id"] != nil){
                MWZVenue* venue = [[MWZVenue alloc] initFromDictionnary:body[@"response"]];
                _handler(venue);
            }
            else {
                _handler(nil);
            }
        }
        [callbackMemory removeObjectForKey:hash];
        [callbackMemory allKeys];
    }
    
}

- (void) fitBounds:(MWZLatLonBounds*) bounds {
    [self executeJS:[NSString stringWithFormat:@"map.fitBounds(new L.LatLngBounds(new L.LatLng(%@, %@), new L.LatLng(%@, %@)));", bounds.southWest.latitude, bounds.southWest.longitude, bounds.northEast.latitude, bounds.northEast.longitude]];
}

- (void) centerOnCoordinates: (NSNumber*) lat longitude: (NSNumber*) lon floor: (NSNumber*) floor zoom: (NSNumber*) zoom {
    if (floor == nil && zoom == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%@,%@)", lat, lon]];
    }
    else if (floor == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%@,%@, null, %@)", lat, lon, zoom]];
    }
    else if (zoom == nil) {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%@,%@,%@,null)", lat, lon, floor]];
    }
    else {
        [self executeJS:[NSString stringWithFormat:@"map.centerOnCoordinates(%@,%@,%@,%@)", lat, lon, floor, zoom ]];
    }
}


- (NSNumber*) getFloor {
    return _floor;
}

- (NSArray*) getFloors {
    return _floors;
}

- (void) setFloor: (NSNumber*) floor {
    [self executeJS:[NSString stringWithFormat:@"map.setFloor(%@)", floor ]];
}

- (void) setZoom:(NSNumber *)zoom {
    [self executeJS:[NSString stringWithFormat:@"map.setZoom(%@)", zoom ]];
}

- (NSNumber*) getZoom {
    return _zoom;
}

- (MWZLatLon*) getCenter {
    return _center;
};

- (void) centerOnVenueById: (NSString*) venueId {
    [self executeJS:[NSString stringWithFormat:@"map.centerOnVenue('%@')", venueId ]];
}
- (void) centerOnVenue: (MWZVenue*) venue {
    [self executeJS:[NSString stringWithFormat:@"map.centerOnVenue('%@')", venue.identifier ]];
}

- (void) centerOnPlaceById: (NSString*) placeId {
    [self executeJS:[NSString stringWithFormat:@"map.centerOnPlace('%@')", placeId ]];
}
- (void) centerOnPlace: (MWZPlace*) place {
    [self executeJS:[NSString stringWithFormat:@"map.centerOnPlace('%@')", place.identifier ]];
}

- (BOOL) getFollowUserMode {
    return _followUserModeON;
}

- (void) setFollowUserMode: (BOOL) follow {
    [self executeJS:[NSString stringWithFormat:@"map.setFollowUserMode(%@)", (follow?@"true":@"false") ]];
}

- (void) centerOnUser: (NSNumber*) zoom {
    [self executeJS:[NSString stringWithFormat:@"map.centerOnUser(%@)", zoom ]];
}



/* User Position */
- (MWZMeasurement*) getUserPosition {
    return _userPosition;
}

- (void) newUserPositionMeasurement: (MWZMeasurement*) measurement {
    [self executeJS:[NSString stringWithFormat:@"map.newUserPositionMeasurement(%@)", [measurement toStringJSON] ]];
}

- (void) setUserHeading: (NSNumber*) heading {
    [self executeJS:[NSString stringWithFormat:@"map.setUserHeading(%@)", heading!=nil?heading:@"null" ]];
}

- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor {
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    if (latitude != nil) {
        [positionDic setObject:latitude forKey:@"latitude"];
    }
    if (longitude != nil) {
        [positionDic setObject:longitude forKey:@"longitude"];
    }
    if (floor != nil) {
        [positionDic setObject:floor forKey:@"floor"];
    }
    [positionDic setObject:@0 forKey:@"accuracy"];
    NSData *userPositionJSON = [NSJSONSerialization dataWithJSONObject:positionDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* userPositionString = [[NSString alloc] initWithData:userPositionJSON encoding:NSUTF8StringEncoding];
    [self executeJS:[NSString stringWithFormat:@"map.setUserPosition(%@)", userPositionString ]];
}

- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy {
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    if (latitude != nil) {
        [positionDic setObject:latitude forKey:@"latitude"];
    }
    if (longitude != nil) {
        [positionDic setObject:longitude forKey:@"longitude"];
    }
    if (floor != nil) {
        [positionDic setObject:floor forKey:@"floor"];
    }
    if (accuracy != nil) {
        [positionDic setObject:accuracy forKey:@"accuracy"];
    }
    NSData *userPositionJSON = [NSJSONSerialization dataWithJSONObject:positionDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* userPositionString = [[NSString alloc] initWithData:userPositionJSON encoding:NSUTF8StringEncoding];
    [self executeJS:[NSString stringWithFormat:@"map.setUserPosition(%@)", userPositionString ]];

}

- (void) unlockUserPosition {
    [self executeJS:[NSString stringWithFormat:@"map.unlockUserPosition()"]];

}

/* URL */
- (void) loadURL: (NSString*) url {
    [self executeJS:[NSString stringWithFormat:@"map.loadUrl('%@')", url ]];
}

/* Markers */
- (void) addMarkerWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor {
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    if (latitude != nil) {
        [positionDic setObject:latitude forKey:@"lat"];
    }
    if (longitude != nil) {
        [positionDic setObject:longitude forKey:@"lon"];
    }
    if (floor != nil) {
        [positionDic setObject:floor forKey:@"floor"];
    }
    NSData *positionJSON = [NSJSONSerialization dataWithJSONObject:positionDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* positionString = [[NSString alloc] initWithData:positionJSON encoding:NSUTF8StringEncoding];
    [self executeJS:[NSString stringWithFormat:@"map.addMarker(%@)", positionString ]];
}

- (void) addMarkerWithPlaceId: (NSString*) placeId {
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    if (placeId != nil) {
        [positionDic setObject:placeId forKey:@"placeId"];
    }
    NSData *positionJSON = [NSJSONSerialization dataWithJSONObject:positionDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* positionString = [[NSString alloc] initWithData:positionJSON encoding:NSUTF8StringEncoding];
    [self executeJS:[NSString stringWithFormat:@"map.addMarker(%@)", positionString ]];
}

- (void) removeMarkers {
    [self executeJS:[NSString stringWithFormat:@"map.removeMarkers()"]];
}

/* Directions */

- (void) showDirectionsFrom: (MWZPosition*) from to: (MWZPosition*) to {
    [self executeJS:[NSString stringWithFormat:@"map.showDirections(%@,%@,null,function(){})", [from toStringJSON], [to toStringJSON]]];
}

- (void) stopDirections {
    [self executeJS:[NSString stringWithFormat:@"map.stopDirections()"]];
}


/* Access */
- (void) access: (NSString*) accessKey {
    [self executeJS:[NSString stringWithFormat:@"map.access('%@', function(){});", accessKey ]];
}

- (void) setBottomMargin: (NSNumber*) margin {
    [self executeJS:[NSString stringWithFormat:@"map.setBottomMargin(%@);", margin ]];
}

- (void) setTopMargin: (NSNumber*) margin {
    [self executeJS:[NSString stringWithFormat:@"map.setTopMargin(%@);", margin ]];
}

- (void) setStyle: (MWZPlaceStyle*) style forPlaceById: (NSString*) placeId {
    NSLog(@"%@", [NSString stringWithFormat:@"map.setPlaceStyle('%@', %@);", placeId, [style toStringJSON]]);
    [self executeJS:[NSString stringWithFormat:@"map.setPlaceStyle('%@', %@);", placeId, [style toStringJSON]]];
}

/* API Request */
-(NSString*) generateHash {
    return [[NSUUID UUID] UUIDString];
}

- (void) getPlaceWithId: (NSString*) placeId completionHandler:(void(^)(MWZPlace*)) handler {
    
    NSString* hash = [self generateHash];
    void(^_handler)(MWZPlace*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.api.getPlace('%@', function(err, place){map.fire('apiResponse', {returnedType:'place', hash:'%@', response:err||place});});", placeId, hash ]];
    
}

- (void) getPlaceWithAlias: (NSString*) placeAlias inVenue: (NSString*) venueId completionHandler:(void(^)(MWZPlace*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZPlace*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.api.getPlace({alias:'%@', venueId:'%@'}, function(err, place){map.fire('apiResponse', {returnedType:'place', hash:'%@', response:err||place});});", placeAlias, venueId, hash ]];
}

- (void) getPlaceWithName: (NSString*) placeName inVenue: (NSString*) venueId completionHandler:(void(^)(MWZPlace*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZPlace*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.api.getPlace({name:'%@', venueId:'%@'}, function(err, place){map.fire('apiResponse', {returnedType:'place', hash:'%@', response:err||place});});", placeName, venueId, hash ]];
}

- (void) getVenueWithId: (NSString*) venueId completionHandler:(void(^)(MWZVenue*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZVenue*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];

    [self executeJS:[NSString stringWithFormat:@"Mapwize.api.getVenue('%@', function(err, venue){map.fire('apiResponse', {returnedType:'venue', hash:'%@', response:err||venue});});", venueId, hash ]];
}

- (void) getVenueWithName: (NSString*) venueName completionHandler:(void(^)(MWZVenue*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZVenue*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.api.getVenue({venueName:'%@'}, function(err, venue){map.fire('apiResponse', {returnedType:'venue', hash:'%@', response:err||venue});});", venueName, hash ]];
}

- (void) getVenueWithAlias: (NSString*) venueAlias completionHandler:(void(^)(MWZVenue*)) handler {
    NSString* hash = [self generateHash];
    void(^_handler)(MWZVenue*);
    _handler = [handler copy];
    [callbackMemory setValue:_handler forKey:hash];
    
    [self executeJS:[NSString stringWithFormat:@"Mapwize.api.getVenue({venueAlias:'%@'}, function(err, venue){map.fire('apiResponse', {returnedType:'venue', hash:'%@', response:err||venue});});", venueAlias, hash ]];
}

- (void) refresh {
    [self executeJS:[NSString stringWithFormat:@"map.refresh()"]];
}


/* location manager methods */
- (void) updateMonitoring: (NSArray*) uuids {
    
    NSArray* rangedRegion = [[_locationManager rangedRegions] copy];
    for (CLBeaconRegion* region in rangedRegion) {
        [_locationManager stopRangingBeaconsInRegion:region];
    }
    
    for (NSString* uuidString in uuids) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
        CLBeaconRegion* region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuidString];
        [_locationManager startRangingBeaconsInRegion:region];
    }
    
}

#pragma mark Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation* location = [locations objectAtIndex:0];
    MWZMeasurement* m = [[MWZMeasurement alloc] initWithLatitude:@(location.coordinate.latitude) longitude:@(location.coordinate.longitude) floor:nil accuracy:@(location.horizontalAccuracy) valitidy:nil source:@"gps"];
    [self newUserPositionMeasurement:m];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    NSMutableArray* beaconsToJS = [[NSMutableArray alloc] init];
    for (CLBeacon* beacon in beacons) {
        NSMutableDictionary* beaconDic = [[NSMutableDictionary alloc] init];
        [beaconDic setObject:[beacon.proximityUUID UUIDString] forKey:@"uuid"];
        [beaconDic setObject:beacon.major forKey:@"major"];
        [beaconDic setObject:beacon.minor forKey:@"minor"];
        [beaconDic setObject:@(beacon.rssi) forKey:@"rssi"];
        [beaconDic setObject:@(beacon.accuracy) forKey:@"accuracy"];
        [beaconsToJS addObject:beaconDic];
    }
    NSData *beaconsJSON = [NSJSONSerialization dataWithJSONObject:beaconsToJS options:(NSJSONWritingOptions) 0 error:nil];
    NSString* beaconsString = [[NSString alloc] initWithData:beaconsJSON encoding:NSUTF8StringEncoding];
    [self executeJS:[NSString stringWithFormat:@"map.addRangedIBeacons(%@)", beaconsString]];
}

/*
    View constraints
*/
- (void)addWebViewConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_webview
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_webview
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_webview
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_webview
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
}


@end
