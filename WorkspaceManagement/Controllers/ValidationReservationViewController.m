//
//  ValidationReservationViewController.m
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ValidationReservationViewController.h"

@interface ValidationReservationViewController ()

@end

@implementation ValidationReservationViewController

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
    UIImage *right = [UIImage imageNamed:@"WSMImagesBtnExit"];
    NavBarInstance *custom = [NavBarInstance sharedInstance];
    [custom styleNavBar:self setTitle:@"RÉSERVER UNE SALLE" setLeftButton:nil setRightButton:right];
}

- (void)navbarRightButton {
    [self.navigationController popToRootViewControllerAnimated:YES];}

- (IBAction)findRoom:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FindRoomViewController *viewController = (FindRoomViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FindRoomViewController"];
    [self presentViewController:viewController animated:NO completion:nil];
}
@end
