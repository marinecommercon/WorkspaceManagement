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

@synthesize buttonValidationReservation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [buttonValidationReservation addTarget:self
                            action:@selector(buttonValiderReservation)
                  forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)buttonValiderReservation
{
    NSLog(@"Validation Reservation");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ValidationReservationViewController *viewController = (ValidationReservationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ValidationReservationViewController"];
    [self presentViewController:viewController animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
