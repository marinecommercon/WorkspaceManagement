//
//  NavBarInstance.m
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]


#import "NavBarInstance.h"
#import <UIKit/UIKit.h>


@implementation NavBarInstance

static NavBarInstance *_sharedInstance;

- (void)styleNavBar:(UIViewController *) view setTitle:(NSString *)title setLeftButton:(UIImage *)left setRightButton:(UIImage *)right {
    [view.navigationController setNavigationBarHidden:YES animated:NO];
    
    _myNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.view.bounds), view.view.frame.size.width / 5)];
    [_myNavBar setTintColor:[UIColor whiteColor]];
    
    _navItem = [[UINavigationItem alloc] init];
    _navItem.title = title;
    
    [_myNavBar setItems:@[_navItem]];
    [_myNavBar setBarTintColor:UIColorFromRGB(0xFFFFFF)];
    _myNavBar.translucent = NO;
    
    _myNavBar.backgroundColor = [UIColor clearColor];
    _myNavBar.layer.shadowOpacity = 0.5;
    _myNavBar.layer.shadowOffset = CGSizeMake(0, 0);
    _myNavBar.layer.shadowRadius = 1;
    _myNavBar.layer.masksToBounds = NO;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [_myNavBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"DINPro-CondensedBold" size:24.0],NSFontAttributeName,
      nil]];
    
    
    // LEFT
    UIImage *leftImage = left;
    CGRect leftFrame = CGRectMake(0, 0, leftImage.size.width / 3.5, leftImage.size.height / 3.5);
    
    UIButton *buttonLeft = [[UIButton alloc] initWithFrame:leftFrame];
    [buttonLeft setBackgroundImage:leftImage forState:UIControlStateNormal];
    [buttonLeft addTarget:view action:@selector(navbarLeftButton)
      forControlEvents:UIControlEventTouchUpInside];
    [buttonLeft setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    _navItem.leftBarButtonItem  = leftBarButton;
    
    // RIGHT
    UIImage *rightImage = right;
    CGRect rightFrame = CGRectMake(0, 0, rightImage.size.width / 3.5, rightImage.size.height / 3.5);
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:rightFrame];
    
    [buttonRight setBackgroundImage:rightImage forState:UIControlStateNormal];
    [buttonRight addTarget:view action:@selector(navbarRightButton)
      forControlEvents:UIControlEventTouchUpInside];
    [buttonRight setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    _navItem.rightBarButtonItem = rightBarButton;
    
    [view.view addSubview:_myNavBar];
}


+ (NavBarInstance *) sharedInstance
{
    if(!_sharedInstance){
        _sharedInstance = [[NavBarInstance alloc] init];
    }
    
    return _sharedInstance;
}

- (void)setNavBarTitle: (NSString *) title{
    self.navItem.title = title;
}

@end
