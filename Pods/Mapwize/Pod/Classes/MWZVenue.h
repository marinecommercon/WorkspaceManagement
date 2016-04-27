#import <Foundation/Foundation.h>

@interface MWZVenue : NSObject

@property NSString* identifier;
@property NSString* name;
@property NSString* alias;

- (instancetype)initFromDictionnary:(NSDictionary*)dic;

@end
