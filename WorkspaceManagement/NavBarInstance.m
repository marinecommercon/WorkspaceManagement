//
//  NavBarInstance.m
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "NavBarInstance.h"
#import <UIKit/UIKit.h>
#import "UIColor+AppAdditions.h"
#import "UIFont+AppAdditions.h"

@interface NavBarInstance ()

@property (nonatomic, retain) UIImage *buttonImageLeft;
@property (nonatomic, retain) UIImage *buttonImageRight;

@end

@implementation NavBarInstance

@dynamic navBarTitle;
@dynamic buttonImageLeft;
@dynamic buttonImageRight;

static NavBarInstance *_sharedInstance;

+ (NavBarInstance *)sharedInstance
{
    // TODO : initialize singleton using dispatch_once.
    
    if(!_sharedInstance)
    {
        _sharedInstance = [[NavBarInstance alloc] init];
    }
    
    return _sharedInstance;
}

//- (void)styleNavBar:(UIViewController *)view setTitle:(NSString *)title setLeftButton:(UIImage *)left setRightButton:(UIImage *)right
- (void)setTitle:(NSString *)title leftButtonImage:(UIImage *)leftImage rightButtonImage:(UIImage *)rightImage forViewController:(UIViewController *)controller
{
//    self.viewController = controller;
    [controller.navigationController setNavigationBarHidden:YES animated:NO];
    
    _myNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(controller.view.bounds), controller.view.frame.size.width / 5)];
    [_myNavBar setTintColor:UIColor.whiteColor];
    
    _navItem       = [[UINavigationItem alloc] init];
    _navItem.title = title;
    
    _myNavBar.items       = @[_navItem];
    _myNavBar.barTintColor = UIColor.whiteColor;
    _myNavBar.translucent  = NO;
    
    _myNavBar.backgroundColor     = UIColor.clearColor;
    _myNavBar.layer.shadowOpacity = 0.5;
    _myNavBar.layer.shadowOffset  = CGSizeZero;
    _myNavBar.layer.shadowRadius  = 1.0;
    _myNavBar.layer.masksToBounds = NO;
    
    NSShadow *shadow    = [[NSShadow alloc] init];
    shadow.shadowColor  = UIColor.bnpNavBarShadow;
    shadow.shadowOffset = CGSizeMake(0, 1);
    _myNavBar.titleTextAttributes = @{NSFontAttributeName:UIFont.navBarTitle, NSForegroundColorAttributeName:UIColor.bnpNavBarText};
  
    UIImage *imageErase = leftImage;
    
//    CGRect frame1 = CGRectMake(self.myNavBar.frame.origin.x, self.myNavBar.frame.origin.y, imageErase.size.width / 3.2, imageErase.size.height / 3.2);
    
    //    UIButton *button1 = [[UIButton alloc] initWithFrame:frame1];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:imageErase forState:UIControlStateNormal];
    [button1 sizeToFit];
    [button1 addTarget:controller
                action:@selector(launchLeft)
      forControlEvents:UIControlEventTouchUpInside];
    button1.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *eraseButton =[[UIBarButtonItem alloc] initWithCustomView:button1];
    _navItem.leftBarButtonItem = eraseButton;
    
    UIImage *imageHelp = rightImage;
//    CGRect frame2 = CGRectMake(self.myNavBar.frame.origin.x, self.myNavBar.frame.origin.y, imageHelp.size.width / 3.2, imageHelp.size.height / 3.2);
//    UIButton *button2 = [[UIButton alloc] initWithFrame:frame2];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:imageHelp forState:UIControlStateNormal];
    [button2 sizeToFit];
    [button2 addTarget:controller
                action:@selector(launchRight)
      forControlEvents:UIControlEventTouchUpInside];
    button2.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *HelpButton =[[UIBarButtonItem alloc] initWithCustomView:button2];
    _navItem.rightBarButtonItem = HelpButton;
    
    [controller.view addSubview:_myNavBar];
}

//- (void)setButtonImageLeft:(UIImage *)leftImage
//{
//    CGRect leftFrame = CGRectMake(0, 0, leftImage.size.width / 3.5, leftImage.size.height / 3.5);
//    
//    self.buttonLeft = [[UIButton alloc] initWithFrame:leftFrame];
//    
//    [self.buttonLeft setBackgroundImage:leftImage
//                               forState:UIControlStateNormal];
//    [self.buttonLeft addTarget:self.viewController
//                        action:@selector(navbarLeftButton)
//              forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.buttonLeft setShowsTouchWhenHighlighted:NO];
//    
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.buttonLeft];
//    
//    _navItem.leftBarButtonItem  = leftBarButton;
//    
//    self.buttonLeft.hidden = true;
//}
//
//- (UIImage *)buttonImageLeft
//{
//    return [self.buttonLeft imageForState:UIControlStateNormal];
//}
//
//- (void)setButtonImageRight:(UIImage *)rightImage
//{
//    CGRect rightFrame = CGRectMake(0, 0, rightImage.size.width / 3.5, rightImage.size.height / 3.5);
//    
//    self.buttonRight = [[UIButton alloc] initWithFrame:rightFrame];
//    
//    [self.buttonRight setBackgroundImage:rightImage
//                                forState:UIControlStateNormal];
//    [self.buttonRight addTarget:self.viewController
//                         action:@selector(navbarRightButton)
//               forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.buttonRight setShowsTouchWhenHighlighted:NO];
//    
//    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc] initWithCustomView:self.buttonRight];
//    
//    _navItem.rightBarButtonItem = rightBarButton;
//}
//
//- (UIImage *)buttonImageRight
//{
//    return [self.buttonRight imageForState:UIControlStateNormal];
//}

- (void)setNavBarTitle:(NSString *)title
{
    self.navItem.title = title;
}

- (NSString *)navBarTitle
{
    return self.navItem.title;
}

@end
