#import "MWZPlaceStyle.h"

@implementation MWZPlaceStyle

- (instancetype) initWithStrokeColor: (UIColor*) strokeColor strokeWidth: (NSNumber*) strokeWidth fillColor: (UIColor*) fillColor labelBackgroundColor: (UIColor*) labelBackgroundColor markerUrl: (NSString*) markerUrl {
    self = [super init];
    _strokeColor = strokeColor;
    _strokeWidth = strokeWidth;
    _fillColor = fillColor;
    _labelBackgroundColor = labelBackgroundColor;
    _markerUrl = markerUrl;
    return self;
}

- (NSString*) toStringJSON {
    NSMutableDictionary* placeStyleDic = [[NSMutableDictionary alloc] init];
    if (_strokeColor != nil) {
        NSDictionary* tmp = [MWZPlaceStyle hexStringFromColor:_strokeColor];
        [placeStyleDic setObject:[tmp objectForKey:@"color"] forKey:@"strokeColor"];
        [placeStyleDic setObject:[tmp objectForKey:@"alpha"] forKey:@"strokeOpacity"];
    }
    if (_strokeWidth != nil) {
        [placeStyleDic setObject:_strokeWidth forKey:@"strokeWidth"];
    }
    if (_fillColor != nil) {
        NSDictionary* tmp = [MWZPlaceStyle hexStringFromColor:_fillColor];
        [placeStyleDic setObject:[tmp objectForKey:@"color"] forKey:@"fillColor"];
        [placeStyleDic setObject:[tmp objectForKey:@"alpha"] forKey:@"fillOpacity"];
    }
    if (_labelBackgroundColor != nil) {
        NSDictionary* tmp = [MWZPlaceStyle hexStringFromColor:_labelBackgroundColor];
        [placeStyleDic setObject:[tmp objectForKey:@"color"] forKey:@"labelBackgroundColor"];
        [placeStyleDic setObject:[tmp objectForKey:@"alpha"] forKey:@"labelBackgroundOpacity"];
    }
    if (_markerUrl != nil) {
        [placeStyleDic setObject:_markerUrl forKey:@"markerUrl"];
    }
    NSData *placeStyleJSON = [NSJSONSerialization dataWithJSONObject:placeStyleDic options:(NSJSONWritingOptions) 0 error:nil];
    NSString* placeStyleString = [[NSString alloc] initWithData:placeStyleJSON encoding:NSUTF8StringEncoding];
    
    return placeStyleString;
}

+ (NSDictionary *)hexStringFromColor:(UIColor *)color
{
    CGColorSpaceModel colorSpace = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r, g, b, a;
    
    if (colorSpace == kCGColorSpaceModelMonochrome) {
        r = components[0];
        g = components[0];
        b = components[0];
        a = components[1];
    }
    else if (colorSpace == kCGColorSpaceModelRGB) {
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    else {
        r=0;g=0;b=0;a=0;
    }
    
    NSString* stringcolor = [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
    
    NSNumber* alpha = @(a);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
     stringcolor, @"color",
     alpha, @"alpha",
     nil];
    
    
}

@end
