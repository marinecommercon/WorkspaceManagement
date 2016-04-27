#import "MWZPosition.h"

@implementation MWZPosition

- (instancetype) initWithPlaceId: (NSString*) placeId {
    self = [super init];
    _placeId = placeId;
    return self;
}
- (instancetype) initWithVenueId: (NSString*) venueId {
    self = [super init];
    _venueId = venueId;
    return self;
}


- (instancetype) initWithLatitude: (NSNumber*) latitude longitude: (NSNumber*) longitude floor:(NSNumber*) floor {
    self = [super init];
    _latitude = latitude;
    _longitude = longitude;
    _floor = floor;
    return self;
}

- (instancetype)initFromDictionnary:(NSDictionary*)dic {
    self = [super init];
    _latitude = [dic objectForKey:@"latitude"];
    _longitude = [dic objectForKey:@"longitude"];
    _floor = [dic objectForKey:@"floor"];
    _placeId = [dic objectForKey:@"placeId"];
    _venueId = [dic objectForKey:@"venueId"];
    return self;
}

- (NSString*) toStringJSON {
    NSMutableDictionary* positionDic = [[NSMutableDictionary alloc] init];
    if (_placeId != nil) {
        [positionDic setObject:[self placeId] forKey:@"placeId"];
    }
    if (_venueId != nil) {
        [positionDic setObject:[self venueId] forKey:@"venueId"];
    }
    if (_floor != nil) {
        [positionDic setObject:[self floor] forKey:@"floor"];
    }
    if (_latitude != nil) {
        [positionDic setObject:_latitude forKey:@"lat"];
    }
    if (_longitude != nil) {
        [positionDic setObject:_longitude forKey:@"lon"];
    }
    NSData *userPositionJSON = [NSJSONSerialization dataWithJSONObject:positionDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* userPositionString = [[NSString alloc] initWithData:userPositionJSON encoding:NSUTF8StringEncoding];
    
    return userPositionString;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZPosition: Latitude=%@ Longitude=%@ Floor=%@ PlaceId=%@ VenueId=%@", _latitude, _longitude, _floor, _placeId, _venueId];
}

@end
