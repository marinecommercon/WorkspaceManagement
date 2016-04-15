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

- (void)styleNavBar:(UIViewController *) view setTitle:(NSString *)title setLeftButton:(UIImage *)leftButton setRightButton:(UIImage *)rightButton {
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
    
    UIImage *imageErase = leftButton;
    CGRect frame1 = CGRectMake(0, 0, imageErase.size.width / 3.5, imageErase.size.height / 3.5);
    UIButton *Button1 = [[UIButton alloc] initWithFrame:frame1];
    [Button1 setBackgroundImage:imageErase forState:UIControlStateNormal];
    [Button1 addTarget:view action:@selector(launchLeft)
      forControlEvents:UIControlEventTouchUpInside];
    [Button1 setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *EraseButton =[[UIBarButtonItem alloc] initWithCustomView:Button1];
    _navItem.leftBarButtonItem = EraseButton;
    
    UIImage *imageHelp = rightButton;
    CGRect frame2 = CGRectMake(0, 0, imageHelp.size.width / 3.5, imageHelp.size.height / 3.5);
    UIButton *Button2 = [[UIButton alloc] initWithFrame:frame2];
    [Button2 setBackgroundImage:imageHelp forState:UIControlStateNormal];
    [Button2 addTarget:view action:@selector(launchRight)
      forControlEvents:UIControlEventTouchUpInside];
    [Button2 setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *HelpButton =[[UIBarButtonItem alloc] initWithCustomView:Button2];
    _navItem.rightBarButtonItem = HelpButton;
    
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
