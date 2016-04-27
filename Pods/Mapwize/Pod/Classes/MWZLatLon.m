#import "MWZLatLon.h"

@implementation MWZLatLon

- (instancetype)initWithLatitude:(NSNumber*)latitude longitude:(NSNumber*)longitude{
    self = [super init];
    _latitude = latitude;
    _longitude = longitude;
    return self;
}

- (instancetype)initFromDictionnary:(NSDictionary*)dic {
    self = [super init];
    _latitude = [dic objectForKey:@"lat"];
    _longitude = [dic objectForKey:@"lng"];
    return self;
}

- (instancetype)initFromArray:(NSArray*)array {
    self = [super init];
    _latitude = [array objectAtIndex:0];
    _longitude = [array objectAtIndex:1];
    return self;
}

- (instancetype)initFromLeaflet:(NSString*)json {
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSObject *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingOptions) 0 error:nil];

    if ([jsonObject isKindOfClass:[NSArray class]]) {
        return [self initFromArray:(NSArray *) jsonObject];
    } else {
        return [self initFromDictionnary:(NSDictionary *) jsonObject];
    }
}

- (NSArray*) toArray {
    NSMutableArray* array = [[NSMutableArray alloc] initWithObjects: _latitude, _longitude, nil];
    return array;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZLatLon: Latitude=%@ Longitude=%@", _latitude, _longitude];
}


@end
