#import "MWZMeasurement.h"

@implementation MWZMeasurement

- (instancetype) initWithLatitude: (NSNumber*) latitude longitude: (NSNumber*) longitude floor:(NSNumber*) floor accuracy: (NSNumber*) accuracy valitidy: (NSNumber*) validity source: (NSString*) source {
    self = [super init];
    _latitude = latitude;
    _longitude = longitude;
    _floor = floor;
    _accuracy = accuracy;
    _validity = validity;
    _source = source;
    return self;
}

- (instancetype)initFromDictionnary:(NSDictionary*)dic {
    self = [super init];
    _latitude = [dic objectForKey:@"latitude"];
    _longitude = [dic objectForKey:@"longitude"];
    _floor = [dic objectForKey:@"floor"];
    _accuracy = [dic objectForKey:@"accuracy"];
    _validUntil = [dic objectForKey:@"validUntil"];
    _validity = [dic objectForKey:@"validity"];
    _source = [dic objectForKey:@"source"];
    return self;
}

- (NSString*) toStringJSON {
    NSMutableDictionary* userPositionDic = [[NSMutableDictionary alloc] init];
    if (_latitude != nil) {
        [userPositionDic setObject:_latitude forKey:@"latitude"];
    }
    if (_longitude != nil) {
        [userPositionDic setObject:_longitude forKey:@"longitude"];
    }
    if (_floor != nil) {
        [userPositionDic setObject:_floor forKey:@"floor"];
    }
    if (_accuracy != nil) {
        [userPositionDic setObject:_accuracy forKey:@"accuracy"];
    }
    if (_validity != nil) {
        [userPositionDic setObject:[self validity] forKey:@"validity"];
    }
    if (_source != nil) {
        [userPositionDic setObject:[self source] forKey:@"source"];
    }
    
    NSData *userPositionJSON = [NSJSONSerialization dataWithJSONObject:userPositionDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* userPositionString = [[NSString alloc] initWithData:userPositionJSON encoding:NSUTF8StringEncoding];
    
    return userPositionString;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZMeasurement: Latitude=%@ Longitude=%@ Floor=%@ Accuracy=%@ Validity=%@ Source=%@", _latitude, _longitude, _floor, _accuracy, _validity, _source];
}

@end
