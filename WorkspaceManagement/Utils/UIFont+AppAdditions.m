//
//  UIFont+AppAdditions.m
//  WorkspaceManagement
//
//  Created by Nicolas Buquet on 11/05/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "UIFont+AppAdditions.h"

@implementation UIFont (AppAdditions)

+ (UIFont *)dsiAvailable { return [UIFont fontWithName:@"Helvetica" size:18]; }
+ (UIFont *)dsiNotAvailable { return [UIFont fontWithName:@"Helvetica-LightOblique" size:18]; }

+ (UIFont *)filterSearch { return [UIFont fontWithName:@"Helvetica" size:18]; }
+ (UIFont *)filterSearchDone { return [UIFont fontWithName:@"HelveticaNeue-Italic" size:18]; }

+ (UIFont *)carouselSmall { return [UIFont fontWithName:@"DINPro-CondensedBold" size:26]; }
+ (UIFont *)carouselBig { return [UIFont fontWithName:@"DINPro-CondensedBold" size:40]; }

+ (UIFont *)navBarTitle { return [UIFont fontWithName:@"DINPro-CondensedBold" size:26]; }

+ (UIFont *)reservationEditing { return [UIFont fontWithName:@"Helvetica" size:18]; }
+ (UIFont *)reservationEditingDone { return [UIFont fontWithName:@"HelveticaNeue-Italic" size:18]; }

+ (UIFont *)felicitationTimeframe { return [UIFont fontWithName:@"Helvetica-Light" size:16]; }
+ (UIFont *)felicitationTimeframeBold { return [UIFont fontWithName:@"Helvetica-Bold" size:16]; }

+ (UIFont *)felicitationInstruction { return [UIFont fontWithName:@"Helvetica-LightOblique" size:15]; }
+ (UIFont *)felicitationInstructionBold { return [UIFont fontWithName:@"Helvetica-BoldOblique" size:15]; }

@end
