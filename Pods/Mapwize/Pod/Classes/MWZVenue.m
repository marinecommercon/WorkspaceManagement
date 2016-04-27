#import "MWZVenue.h"

@implementation MWZVenue

- (instancetype)initFromDictionnary:(NSDictionary*)dic {
    self = [super init];
    _identifier = [dic objectForKey:@"_id"];
    _name = [dic objectForKey:@"name"];
    _alias = [dic objectForKey:@"alias"];
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"MWZVenue: Identifier=%@ Name=%@ Alias=%@", _identifier, _name, _alias];
}

@end
