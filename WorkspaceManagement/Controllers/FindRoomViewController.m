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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self updateNavBar];
}

- (void) updateNavBar
{
    UIImage *left = [UIImage imageNamed:@"WSMImagesBtnExit"];
    
    NavBarInstance *custom = [NavBarInstance sharedInstance];
    [custom styleNavBar:self setTitle:@"EMPLACEMENT DE L'ESPACE" setLeftButton:left setRightButton:nil];
    
}

- (void)launchLeft {
    NSLog(@"Left");
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)launchRight {
    
    NSLog(@"Right");
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
