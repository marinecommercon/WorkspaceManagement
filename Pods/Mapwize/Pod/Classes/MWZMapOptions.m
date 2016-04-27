#import "MWZMapOptions.h"

@implementation MWZMapOptions

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZMapOptions: ApiKey=%@ MaxBounds=%@ Center=%@ Zoom=%@ Floor=%@", _apiKey, _maxBounds, _center, _zoom, _floor];
}

@end
