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
    [self initNavbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    }

- (void) viewDidAppear:(BOOL)animated
{
}


// HANDLE NAVBAR

- (void) initNavbar
{
    UIImage *right = [UIImage imageNamed:@"WSMImagesBtnExit"];
    self.navbar = [NavBarInstance sharedInstance];
    [self.navbar styleNavBar:self setTitle:@"EMPLACEMENT DE L'ESPACE" setLeftButton:nil setRightButton:right];
    [self.navbar.buttonLeft setHidden:false];
    
}

- (void)navbarRightButton {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
