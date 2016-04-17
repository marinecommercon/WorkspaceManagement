//
//  NavBarInstance.h
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavBarInstance : NSObject

@property (nonatomic, retain) UIViewController *view;
@property (nonatomic, retain) UINavigationItem *navItem;
@property (nonatomic, retain) UINavigationBar  *myNavBar;
@property (nonatomic, retain) UIButton *buttonLeft;
@property (nonatomic, retain) UIButton *buttonRight;

+ (NavBarInstance *) sharedInstance;

- (void)styleNavBar:(UIViewController*)view setTitle:(NSString *)title setLeftButton:(UIImage *)leftButton setRightButton:(UIImage*)rightButton;
- (void) setNavBarTitle:(NSString*)title;
- (void) setButtonImageLeft:(UIImage*)leftImage;
- (void) setButtonImageRight:(UIImage*)rightImage;

@end
