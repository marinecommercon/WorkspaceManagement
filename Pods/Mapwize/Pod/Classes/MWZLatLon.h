#import <Foundation/Foundation.h>

@interface MWZLatLon : NSObject

@property NSNumber* latitude;
@property NSNumber* longitude;

- (instancetype)initWithLatitude:(NSNumber*)latitude longitude:(NSNumber*)longitude;
- (instancetype)initFromDictionnary:(NSDictionary*)dic;
- (instancetype)initFromArray:(NSArray*)array;
- (instancetype)initFromLeaflet:(NSString*)json;

- (NSArray*) toArray;

@end
