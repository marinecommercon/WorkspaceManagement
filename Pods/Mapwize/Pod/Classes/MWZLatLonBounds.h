#import <Foundation/Foundation.h>
@class MWZLatLon;

@interface MWZLatLonBounds : NSObject

@property MWZLatLon* northEast;
@property MWZLatLon* southWest;

- (instancetype)initWithNorthEast:(MWZLatLon*)northEast southWest:(MWZLatLon*)southWest;;

- (NSArray*) toArray;

@end
