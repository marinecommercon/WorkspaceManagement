#ifndef MWZMapDelegate_h
#define MWZMapDelegate_h

@class MWZMapView;
@class MWZLatLon;
@class MWZPosition;
@class MWZMeasurement;
@class MWZPlace;
@class MWZVenue;

@protocol MWZMapDelegate

@optional

- (void) map:(MWZMapView*) map didClick:(MWZLatLon*) latlon;
- (void) map:(MWZMapView*) map didClickOnPlace:(MWZPlace*) place;
- (void) map:(MWZMapView*) map didClickOnVenue:(MWZVenue*) venue;
- (void) map:(MWZMapView*) map didClickLong: (MWZLatLon*) latlon;
- (void) map:(MWZMapView*) map didClickOnMarker: (MWZPosition*) marker;
- (void) map:(MWZMapView*) map didChangeFloor:(NSNumber*) floor;
- (void) map:(MWZMapView*) map didChangeFloors:(NSArray*) floors;
- (void) map:(MWZMapView*) map didChangeZoom:(NSNumber*) floor;
- (void) map:(MWZMapView*) map didMove:(MWZLatLon*) center;
- (void) map:(MWZMapView*) map didChangeUserPosition:(MWZMeasurement*) userPosition;
- (void) map:(MWZMapView*) map didChangeFollowUserMode:(BOOL) followUserMode;
- (void) map:(MWZMapView*) map didStartDirections: (NSString*) infos;
- (void) map:(MWZMapView*) map didStopDirections: (NSString*) infos;
- (void) map:(MWZMapView*) map didFailWithError: (NSError *)error;


@end

#endif /* MWZMapDelegate_h */
