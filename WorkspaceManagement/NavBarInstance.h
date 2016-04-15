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

@property (nonatomic, retain) UINavigationItem *navItem;
@property (nonatomic, retain) UINavigationBar *myNavBar;

+ (NavBarInstance *) sharedInstance;

- (void)styleNavBar:(UIViewController *) view setTitle:(NSString *)title setLeftButton:(UIImage *)leftButton setRightButton:(UIImage *)rightButton;

- (void)setNavBarTitle: (NSString *) title;

@end
