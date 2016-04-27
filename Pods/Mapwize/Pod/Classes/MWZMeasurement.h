#import <Foundation/Foundation.h>

@interface MWZMeasurement : NSObject

@property NSNumber* latitude;
@property NSNumber* longitude;
@property NSNumber* floor;
@property NSNumber* accuracy;
@property NSNumber* validUntil;
@property NSNumber* validity;
@property NSString* source;

- (instancetype) initWithLatitude: (NSNumber*) latitude longitude: (NSNumber*) longitude floor:(NSNumber*) floor accuracy:(NSNumber*) accuracy valitidy: (NSNumber*) validity source: (NSString*) source;
- (instancetype)initFromDictionnary:(NSDictionary*)dic;
- (NSString*) toStringJSON;

@end
