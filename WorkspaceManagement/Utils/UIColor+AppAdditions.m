//
//  UIColor+AppAdditions.m
//  WorkspaceManagement
//
//  Created by Technique on 12/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "UIColor+AppAdditions.h"

UIColor *_colorWithRGBA(unsigned int r, unsigned int g, unsigned int b, CGFloat a)
{
    return [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:a];
}

@implementation UIColor (AppAdditions)

+ (UIColor *)bnpBlue        { return _colorWithRGBA(111, 134, 204, 1.0); }
+ (UIColor *)bnpBlueLight   { return _colorWithRGBA(194, 205, 241, 1.0); }
+ (UIColor *)bnpGrey        { return _colorWithRGBA(149, 149, 149, 1.0); }
+ (UIColor *)bnpGreen       { return _colorWithRGBA( 90, 183, 147, 1.0); }
+ (UIColor *)bnpGreenLight  { return _colorWithRGBA(193, 229, 217, 1.0); }
+ (UIColor *)bnpRed         { return _colorWithRGBA(202,  84, 105, 1.0); }
+ (UIColor *)bnpRedLight    { return _colorWithRGBA(238, 194, 203, 1.0); }
+ (UIColor *)bnpPink        { return _colorWithRGBA(255,   0, 186, 1.0); }
+ (UIColor *)bnpDsiTextBlue { return _colorWithRGBA( 19, 144, 255, 1.0); }
+ (UIColor *)bnpNavBarText  { return _colorWithRGBA( 81, 76, 68, 1.0); } // #514C44
+ (UIColor *)bnpNavBarShadow { return _colorWithRGBA( 0, 0, 0, 0.8); }


@end