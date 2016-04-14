//
//  FindRoomViewController.m
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "FindRoomViewController.h"

@interface FindRoomViewController ()

@end

@implementation FindRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    }

- (void) viewDidAppear:(BOOL)animated
{
    [self initNavbar];
}


// HANDLE NAVBAR

- (void) initNavbar
{
    UIImage *left = [UIImage imageNamed:@"WSMImagesBtnExit"];
    NavBarInstance *custom = [NavBarInstance sharedInstance];
    [custom styleNavBar:self setTitle:@"EMPLACEMENT DE L'ESPACE" setLeftButton:left setRightButton:nil];
    
}

- (void)navbarLeftButton {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)navbarRightButton {

}

@end
