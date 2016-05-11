//
//  UIFont+AppAdditions.h
//  WorkspaceManagement
//
//  Created by Nicolas Buquet on 11/05/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (AppAdditions)

+ (UIFont *)dsiAvailable;
+ (UIFont *)dsiNotAvailable;

+ (UIFont *)filterSearch;
+ (UIFont *)filterSearchDone;

+ (UIFont *)carouselSmall;
+ (UIFont *)carouselBig;

+ (UIFont *)navBarTitle;

+ (UIFont *)reservationEditing;
+ (UIFont *)reservationEditingDone;

+ (UIFont *)felicitationTimeframe;
+ (UIFont *)felicitationTimeframeBold;

+ (UIFont *)felicitationInstruction;
+ (UIFont *)felicitationInstructionBold;

@end
