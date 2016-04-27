#import <Foundation/Foundation.h>

@interface MWZPlaceStyle : NSObject

@property UIColor* strokeColor;             // Supports alpha channel. If null, defaults are used.
@property NSNumber* strokeWidth;            // Size in points. If null, defaults are used.
@property UIColor* fillColor;               // Supports alpha channel. If null, defaults are used.
@property UIColor* labelBackgroundColor;    // Supports alpha channel. If null, defaults are used.
@property NSString* markerUrl;              // Absolute URL. If null, defaults are used.

- (instancetype) initWithStrokeColor: (UIColor*) strokeColor strokeWidth: (NSNumber*) strokeWidth fillColor: (UIColor*) fillColor labelBackgroundColor: (UIColor*) labelBackgroundColor markerUrl: (NSString*) markerUrl;
- (NSString*) toStringJSON;

@end
