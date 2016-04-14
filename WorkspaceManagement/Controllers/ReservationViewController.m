//
//  ReservationViewController.m
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ReservationViewController.h"

@interface ReservationViewController ()


@end

@implementation ReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self initNavbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)validate:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ValidationReservationViewController *viewController = (ValidationReservationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ValidationReservationViewController"];
    [self presentViewController:viewController animated:NO completion:nil];
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
