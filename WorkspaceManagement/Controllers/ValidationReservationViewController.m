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

@synthesize buttonFindRoom;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [buttonFindRoom    addTarget:self
                          action:@selector(buttonFindRoom)
                forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonFindRoom
{
    NSLog(@"Button Find Room");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FindRoomViewController *viewController = (FindRoomViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FindRoomViewController"];
    [self presentViewController:viewController animated:NO completion:nil];
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [self updateNavBar];
}

- (void) updateNavBar
{
    UIImage *right = [UIImage imageNamed:@"WSMImagesBtnExit"];
    
    NavBarInstance *custom = [NavBarInstance sharedInstance];
    [custom styleNavBar:self setTitle:@"RESERVER UNE SALLE" setLeftButton:nil setRightButton:right];
    
}

- (void)launchLeft {
    NSLog(@"Help");
}

- (void)launchRight {
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    MapViewController *viewController = (MapViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    //    [self presentViewController:viewController animated:YES completion:nil];
    
    NSLog(@"Goto MapViewController");
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
