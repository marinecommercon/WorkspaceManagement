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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateNavBar];
}

- (void)updateNavBar
{
//    UIImage *left = [UIImage imageNamed:@"WSMImagesNavbarPrevious"];
//
//    NavBarInstance *custom = [NavBarInstance sharedInstance];
//    [custom styleNavBar:self setTitle:@"EMPLACEMENT DE L'ESPACE" setLeftButton:left setRightButton:nil];
    
    [[NavBarInstance sharedInstance] setTitle:@"EMPLACEMENT DE L'ESPACE"
                              leftButtonImage:[UIImage imageNamed:@"WSMImagesNavbarPrevious"]
                             rightButtonImage:nil
                            forViewController:self];
}

- (void)launchLeft
{
    NSLog(@"Left");
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)launchRight
{
    NSLog(@"Right");
}

// HANDLE NAVBAR

//- (void) initNavbar
//{
//    UIImage *right = [UIImage imageNamed:@"WSMImagesBtnExit"];
//    self.navbar = [NavBarInstance sharedInstance];
//    [self.navbar styleNavBar:self setTitle:@"EMPLACEMENT DE L'ESPACE" setLeftButton:nil setRightButton:right];
//    [self.navbar.buttonLeft setHidden:false];
//    
//}

- (void)navbarRightButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
