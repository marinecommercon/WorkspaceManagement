//
//  NavBarInstance.m
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "NavBarInstance.h"
#import <UIKit/UIKit.h>


@implementation NavBarInstance

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

- (void)styleNavBar:(UIViewController *)view setTitle:(NSString *)title setLeftButton:(UIImage *)left setRightButton:(UIImage *)right
{
    self.view = view;
    [self.view.navigationController setNavigationBarHidden:YES animated:NO];
    
    _myNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.view.bounds), view.view.frame.size.width / 5)];
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
    shadow.shadowColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    _myNavBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"DINPro-CondensedBold" size:24.0]};
  
    [self setButtonImageLeft:left];
    [self setButtonImageRight:right];
    
    [view.view addSubview:_myNavBar];
}

- (void) setButtonImageLeft:(UIImage *)leftImage
{
    CGRect leftFrame = CGRectMake(0, 0, leftImage.size.width / 3.5, leftImage.size.height / 3.5);
    
    self.buttonLeft = [[UIButton alloc] initWithFrame:leftFrame];
    
    [self.buttonLeft setBackgroundImage:leftImage
                               forState:UIControlStateNormal];
    [self.buttonLeft addTarget:self.view
                        action:@selector(navbarLeftButton)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonLeft setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:self.buttonLeft];
    
    _navItem.leftBarButtonItem  = leftBarButton;
    
    self.buttonLeft.hidden = true;
}

- (void) setButtonImageRight:(UIImage *)rightImage
{
    CGRect rightFrame = CGRectMake(0, 0, rightImage.size.width / 3.5, rightImage.size.height / 3.5);
    
    self.buttonRight = [[UIButton alloc] initWithFrame:rightFrame];
    
    [self.buttonRight setBackgroundImage:rightImage
                                forState:UIControlStateNormal];
    [self.buttonRight addTarget:self.view
                         action:@selector(navbarRightButton)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonRight setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc] initWithCustomView:self.buttonRight];
    
    _navItem.rightBarButtonItem = rightBarButton;
}

- (void)setNavBarTitle:(NSString *)title
{
    self.navItem.title = title;
}

@end
