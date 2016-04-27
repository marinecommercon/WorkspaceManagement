# Mapwize

[![Version](https://img.shields.io/cocoapods/v/Mapwize.svg?style=flat)](http://cocoapods.org/pods/Mapwize)
[![License](https://img.shields.io/cocoapods/l/Mapwize.svg?style=flat)](http://cocoapods.org/pods/Mapwize)
[![Platform](https://img.shields.io/cocoapods/p/Mapwize.svg?style=flat)](http://cocoapods.org/pods/Mapwize)

This is the Mapwize iOS SDK, version 1.x.

It allows you to display and interact with Mapwize venue maps.

## Requirements

iOS 8 or higher

## Installation

Mapwize is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

	pod 'Mapwize'

## Example application

An example application is provided in this repository. To run it, clone the repo, and run `pod install` from the Example directory first. Then simply open Mapwize.xcworkspace.

The menu lists all the possible actions that you can do with the map.

## Documentation

### Display the map
To display the Mapwize app, create an instance of MWZMapView then, in your view controller, call the method 

	[map loadMapWithOptions: options];
	
This will load the map in the view with the provided options.

### Map options
Options are defined using the class MWZMapOptions. The following options are available:

- apiKey : [NSString] must be provided for the map to load. It can be obtained from the Mapwize administration interface. If you don't have any, contact us.
- maxBounds : [MWZLatLonBounds] region users are allowed to navigate in.
- center: [MWZLatLon] coordiantes of the center of the map at start-up.
- zoom : [NSNumber] integer between 0 and 21.
- floor : [NSNumber] integer represneting the desired floor of the building.

### Moving the map
Once the map loaded, you can use the following functions on the map instance:

	- (void) fitBounds:(MWZLatLonBounds*) bounds; - moves the map so the specified bound is completely visible.
	- (void) centerOnCoordinates: (NSNumber\*) lat longitude: (NSNumber\*) lon floor: (NSNumber\*) floor zoom: (NSNumber*) zoom;
	- (void) setFloor: (NSNumber*) floor;
	- (void) setZoom: (NSNumber*) zoom;
	- (void) centerOnVenue: (MWZVenue*) venue;
	- (void) centerOnVenueById: (NSString*) venueId;
	- (void) centerOnPlace: (MWZPlace*) place;
	- (void) centerOnPlaceById: (NSString*) placeId;
	- (void) centerOnUser: (NSNumber*) zoom;

### Getting map state

	- (NSNumber*) getFloor - returns the floor currently displayed.
	- (NSArray*) getFloors - returns the list of floors available at the current viewing position.
	- (NSNumber*) getZoom - returns the current zoom level.

### User position

The followUserMode defines if the map should move when the user is moving.

	- (BOOL) getFollowUserMode;
	- (void) setFollowUserMode: (BOOL) follow;

You can get/set the user position using the following methods. For a complete guide on the user position measurement principle, please refer to the [Mapwize.js documentation](https://github.com/Mapwize/mapwize.js-dist/blob/master/doc/doc.md).

	- (MWZMeasurement*) getUserPosition;
	- (void) setUserPositionWithLatitude: (NSNumber\*) latitude longitude:(NSNumber\*) longitude floor:(NSNumber*) floor;
	- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy;
	- (void) newUserPositionMeasurement: (MWZMeasurement*) measurement;
	- (void) unlockUserPosition;


If you are not setting the user position manually, you need to request the Location Authorization. This can be done with the code:

	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    if (status == kCLAuthorizationStatusAuthorizedAlways || status ==kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Location Authorization granted");
    } else {
        NSLog(@"Requesting Location Authorization");
        [locationManager requestWhenInUseAuthorization];
    }

Don't forget to add kCLAuthorizationStatusAuthorizedWhenInUse or kCLAuthorizationStatusAuthorizedAlways string in the info.plist.

### User heading

When a compass is available, it can be interesting to display the direction the user is looking. To do so, the method setUserHeading can be used, giving it an angle in degree. Example if the user is looking south:

	- (void) setUserHeading: (NSNumber*) heading;
	
To remove the display of the compass, simply set the angle to null.

In the example app, you will find an example of code to listen to compass changes and display them on the map.

### Using Mapwize URLs

You can load Mapwize URLs using the following command. For a complete documentation please refer to the [Mapwize URL Scheme](https://github.com/Mapwize/mapwize-url-scheme).

	- (void) loadURL: (NSString*) url;

### Adding markers

You can add markers on top of the map.

	- (void) addMarkerWithLatitude: (NSNumber\*) latitude longitude:(NSNumber\*) longitude floor:(NSNumber*) floor;
	- (void) addMarkerWithPlaceId: (NSString*) placeId;
	- (void) removeMarkers;

### Showing directions

To show directions, you can use 

	- (void) showDirectionsFrom: (MWZPosition\*) from to: (MWZPosition\*) to;

The direction will be automatically computed and displayed. The event didStartDirections will be fired once the direction is loaded.

To remove the directions from the map, use

	- (void) stopDirections;

### Accessing private venues

To access a private venue, enter the related accessKey using:

	- (void) access: (NSString*) accessKey;

Access keys are managed in the Mapwize administration interface and are provided by venue managers.

### Listening to events

You can listen for events emitted by the map using the MWZMapDelegate. To do so, set the delegate class using

    map.delegate = self;

then implement the following methods

	- (void) map:(MWZMapView\*) map didClick:(MWZLatLon*) latlon;
	- (void) map:(MWZMapView\*) map didClickOnPlace:(MWZPlace*) place;
	- (void) map:(MWZMapView\*) map didClickOnVenue:(MWZVenue*) venue;
	- (void) map:(MWZMapView\*) map didClickLong: (MWZLatLon*) latlon;
	- (void) map:(MWZMapView\*) map didChangeFloor:(NSNumber*) floor;
	- (void) map:(MWZMapView\*) map didChangeFloors:(NSArray*) floors;
	- (void) map:(MWZMapView\*) map didChangeZoom:(NSNumber*) floor;
	- (void) map:(MWZMapView\*) map didChangeUserPosition:(MWZMeasurement*) userPosition;
	- (void) map:(MWZMapView\*) map didChangeFollowUserMode:(BOOL) followUserMode;
	- (void) map:(MWZMapView\*) map didStartDirections: (NSString*) infos;
	- (void) map:(MWZMapView\*) map didStopDirections: (NSString*) infos;
	- (void) map:(MWZMapView\*) map didFailWithError: (NSError *)error;

didFailWithError will be triggered in case of unavilable internet connection or in case one of the interaction with the map failed. 

### Editing place style

The display style of places can be changed dynamically within the SDK. To do so, you can use

	- (void) setStyle: (MWZPlaceStyle\*) style forPlaceById: (NSString*) placeId;

### Setting top and bottom margins

It often happens that part of the map is hidden by banners or controls on the top or on the bottom. For example, if you display a banner to show the details of the place you just clicked on, it's better to display the banner on top of the map than having to resize the map.

However, you want to make sure that the Mapwize controls are always visible, like the followUserMode button and the floor selector. Also, that if you make a fitBounds, the area will be completely in the visible part of the map.

For this purpose, you can set a top and a bottom margin on the map. We garantee that nothing important will be displayed in those margin areas.

To set the margins in pixel:

	- (void) setBottomMargin: (NSNumber*) margin;
	- (void) setTopMargin: (NSNumber*) margin;

### Getting venues and places

Venues and places have properties name and alias that allow to identify them in a more human-readable manner than the ID.
Venue names and alias are unique throughout the Mapwize platform. Place names and alias are unique inside a venue.

To get a venue or place object from an id, a name or an alias, you can use the following methods. At each request, we will first try to get the object from the map cache. If the object is not available, a request to the server will be done.

The methods are asynchronous and uses a completionHandler block.

	- (void) getVenueWithId: (NSString\*) venueId completionHandler:(void(^)(MWZVenue*)) handler;
	- (void) getVenueWithName: (NSString\*) venueName completionHandler:(void(^)(MWZVenue*)) handler;
	- (void) getVenueWithAlias: (NSString\*) venueAlias completionHandler:(void(^)(MWZVenue*)) handler;

	- (void) getPlaceWithId: (NSString\*) placeId completionHandler:(void(^)(MWZPlace*)) handler;
	- (void) getPlaceWithAlias: (NSString\*) placeAlias inVenue: (NSString\*) venueId completionHandler:(void(^)(MWZPlace*)) handler;
	- (void) getPlaceWithName: (NSString\*) placeName inVenue: (NSString\*) venueId completionHandler:(void(^)(MWZPlace*)) handler;

### Refreshing the cache

To prevent too many network requests while browsing the map, the SDK keeps a cache of some data it already downloaded.

The Time To Live of the cache is 5 minutes.

If you want to force the map to refresh the cache and update itself, you can call the refresh method anytime.

	- (void) refresh;

## Contact

If you need any help, please contact us at contact@mapwize.io

## License

Mapwize is available under the MIT license. See the LICENSE file for more info.
