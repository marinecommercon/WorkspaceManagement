#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MWZMapDelegate.h"
#import "MWZMapOptions.h"
#import "MWZLatLonBounds.h"
#import "MWZPlace.h"
#import "MWZVenue.h"
#import "MWZPosition.h"
#import "MWZMeasurement.h"
#import "MWZPlaceStyle.h"

@interface MWZMapView : UIView  <WKNavigationDelegate, WKScriptMessageHandler, CLLocationManagerDelegate>

@property id<MWZMapDelegate> delegate;
@property CLLocationManager* locationManager;

- (void) loadMapWithOptions: (MWZMapOptions*) options;

- (void) fitBounds:(MWZLatLonBounds*) bounds;

- (void) centerOnCoordinates: (NSNumber*) lat longitude: (NSNumber*) lon floor: (NSNumber*) floor zoom: (NSNumber*) zoom;
- (void) setFloor: (NSNumber*) floor;
- (NSNumber*) getFloor;
- (NSArray*) getFloors;
- (void) setZoom: (NSNumber*) zoom;
- (NSNumber*) getZoom;
- (MWZLatLon*) getCenter;

- (void) centerOnVenue: (MWZVenue*) venue;
- (void) centerOnVenueById: (NSString*) venueId;
- (void) centerOnPlace: (MWZPlace*) place;
- (void) centerOnPlaceById: (NSString*) placeId;

- (BOOL) getFollowUserMode;
- (void) setFollowUserMode: (BOOL) follow;

- (void) centerOnUser: (NSNumber*) zoom;
- (MWZMeasurement*) getUserPosition;
- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor;
- (void) setUserPositionWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy;
- (void) newUserPositionMeasurement: (MWZMeasurement*) measurement;
- (void) setUserHeading: (NSNumber*) heading;
- (void) unlockUserPosition;

- (void) loadURL: (NSString*) url;

- (void) addMarkerWithLatitude: (NSNumber*) latitude longitude:(NSNumber*) longitude floor:(NSNumber*) floor;
- (void) addMarkerWithPlaceId: (NSString*) placeId;
- (void) removeMarkers;

- (void) showDirectionsFrom: (MWZPosition*) from to: (MWZPosition*) to;
- (void) stopDirections;

- (void) access: (NSString*) accessKey;

- (void) setStyle: (MWZPlaceStyle*) style forPlaceById: (NSString*) placeId;

- (void) setBottomMargin: (NSNumber*) margin;
- (void) setTopMargin: (NSNumber*) margin;

- (void) getPlaceWithId: (NSString*) placeId completionHandler:(void(^)(MWZPlace*)) handler;
- (void) getPlaceWithAlias: (NSString*) placeAlias inVenue: (NSString*) venueId completionHandler:(void(^)(MWZPlace*)) handler;
- (void) getPlaceWithName: (NSString*) placeName inVenue: (NSString*) venueId completionHandler:(void(^)(MWZPlace*)) handler;

- (void) getVenueWithId: (NSString*) venueId completionHandler:(void(^)(MWZVenue*)) handler;
- (void) getVenueWithName: (NSString*) venueName completionHandler:(void(^)(MWZVenue*)) handler;
- (void) getVenueWithAlias: (NSString*) venueAlias completionHandler:(void(^)(MWZVenue*)) handler;

- (void) refresh;

- (void) executeJS:(NSString*) js;

@end
