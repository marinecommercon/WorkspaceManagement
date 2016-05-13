//
//  ValidationReservationViewController.m
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ValidationReservationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "Utils.h"
#import "UIFont+AppAdditions.h"
#import "Room.h"

@interface ValidationReservationViewController ()

@end

@implementation ValidationReservationViewController

@synthesize buttonFindRoom;
@synthesize timeFrameLabel;
@synthesize roomName;
@synthesize instructionsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [buttonFindRoom addTarget:self
//                       action:@selector(buttonFindRoomAction)
//             forControlEvents:UIControlEventTouchUpInside];
    
    buttonFindRoom.layer.cornerRadius = 5;
    buttonFindRoom.clipsToBounds = YES;
    
    self.roomName.text = self.reservation.room.name;
    
    // set Timeframe label
    
    NSString *timeframeStr = [NSString stringWithFormat:@"Votre espace a bien été réservé aujourd'hui de %@ à %@.", self.reservation.beginTime, self.reservation.endTime];
    NSMutableAttributedString *timeFrameAttrStr = [[NSMutableAttributedString alloc] initWithString:timeframeStr attributes:@{NSFontAttributeName: UIFont.felicitationTimeframe}];
    
    [timeFrameAttrStr beginEditing];
    [timeFrameAttrStr addAttribute:NSFontAttributeName
                             value:UIFont.felicitationTimeframeBold
                             range:[timeframeStr rangeOfString:self.reservation.beginTime]];
    [timeFrameAttrStr addAttribute:NSFontAttributeName
                             value:UIFont.felicitationTimeframeBold
                             range:[timeframeStr rangeOfString:self.reservation.endTime]];
    [timeFrameAttrStr endEditing];
   
    self.timeFrameLabel.attributedText = timeFrameAttrStr;
    
    // set instruction label
    
    NSDate *confirmDate = [[Utils parseTimeToDate:self.reservation.beginTime] dateByAddingTimeInterval:-15*60];
    NSString *confirmDateStr = [Utils parseDateToTime:confirmDate];
    
    NSString *instructionStr = [NSString stringWithFormat:@"Merci de bien vouloir vous y rendre au plus tard à %@, sinon votre espace sera libéré pour d’autres collaborateurs.", confirmDateStr];
    
    NSMutableAttributedString *instructionAttrStr = [[NSMutableAttributedString alloc] initWithString:instructionStr attributes:@{NSFontAttributeName: UIFont.felicitationInstruction}];
    
    [instructionAttrStr beginEditing];
    [instructionAttrStr addAttribute:NSFontAttributeName
                             value:UIFont.felicitationInstructionBold
                             range:[instructionStr rangeOfString:confirmDateStr]];
    [instructionAttrStr endEditing];

    self.instructionsLabel.attributedText = instructionAttrStr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonFindRoomAction
{
    NSLog(@"Button Find Room");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FindRoomViewController *viewController = (FindRoomViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FindRoomViewController"];
    [self presentViewController:viewController animated:NO completion:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateNavBar];
}
    
- (void) updateNavBar
{
//    UIImage *right = [UIImage imageNamed:@"WSMImagesNavbarQuit"];
//    
//    NavBarInstance *custom = [NavBarInstance sharedInstance];
//    [custom styleNavBar:self setTitle:@"RÉSERVER UNE SALLE" setLeftButton:nil setRightButton:right];
    
    [[NavBarInstance sharedInstance] setTitle:[NSString stringWithFormat:@"RÉSERVER %@", self.reservation.room.name]
                              leftButtonImage:nil
                             rightButtonImage:[UIImage imageNamed:@"WSMImagesNavbarQuit"]
                            forViewController:self];
}

- (void)launchLeft
{
    NSLog(@"launchLeft");
}

- (void)launchRight
{
    NSLog(@"Goto MapViewController");
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

// HANDLE NAVBAR

/*
- (IBAction)findRoom:(id)sender {    
    FindRoomViewController *findRoom = [self.storyboard instantiateViewControllerWithIdentifier:@"FindRoomViewController"];
    [self.navigationController pushViewController:findRoom animated:YES];
}
*/
@end
