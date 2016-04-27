#import <Foundation/Foundation.h>

@interface MWZPlace : NSObject

@property NSString* identifier;
@property NSString* name;
@property NSString* alias;
@property NSString* venueId;

- (instancetype)initFromDictionnary:(NSDictionary*)dic;

@end
