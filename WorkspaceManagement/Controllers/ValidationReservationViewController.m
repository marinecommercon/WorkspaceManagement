//
//  ValidationReservationViewController.m
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ValidationReservationViewController.h"
#import "MapViewController.h"

@interface ValidationReservationViewController ()

@end

@implementation ValidationReservationViewController

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
    [self.navbar styleNavBar:self setTitle:@"RÉSERVER UNE SALLE" setLeftButton:nil setRightButton:right];
}

- (void)navbarRightButton {
    MapViewController *myMapViewController = (MapViewController *) self.navigationController.viewControllers[0];
    [myMapViewController navbarLeftButton];
    [myMapViewController.filterViewController updateCarousel:nil andPosition:true];
    
    [self.navigationController popToRootViewControllerAnimated:YES];}

- (IBAction)findRoom:(id)sender {    
    FindRoomViewController *findRoom = [self.storyboard instantiateViewControllerWithIdentifier:@"FindRoomViewController"];
    [self.navigationController pushViewController:findRoom animated:YES];
}
@end
