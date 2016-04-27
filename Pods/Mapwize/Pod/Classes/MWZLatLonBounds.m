#import "MWZLatLonBounds.h"
#import "MWZLatLon.h"

@implementation MWZLatLonBounds

- (instancetype)initWithNorthEast:(MWZLatLon*)northEast southWest:(MWZLatLon*)southWest {
    self = [super init];
    _northEast = northEast;
    _southWest = southWest;
    return self;
}

- (NSArray*) toArray {
    NSMutableArray* NEArray = [[NSMutableArray alloc] initWithObjects: _northEast.latitude, _northEast.longitude, nil];
    NSMutableArray* SWArray = [[NSMutableArray alloc] initWithObjects: _southWest.latitude, _southWest.longitude, nil];
    NSMutableArray* array = [[NSMutableArray alloc] initWithObjects: NEArray, SWArray, nil];
    return array;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZLatLonBounds: NorthEast=%@ SouthWest=%@", _northEast, _southWest];
}

@end
