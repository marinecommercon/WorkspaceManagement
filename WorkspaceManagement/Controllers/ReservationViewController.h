//
//  ReservationViewController.h
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidationReservationViewController.h"
#import "ReservationViewController.h"
#import "Room.h"
#import "CheckDAO.h"

@interface ReservationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIView *viewSlider;
@property (strong,nonatomic) NavBarInstance *navbar;

@property (strong,nonatomic)  Room *room;
@property (strong,nonatomic)  NSString *beginTime;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAuthor;
@property (strong, nonatomic) IBOutlet UITextField *textFieldSubject;
@property float maxValue;

- (IBAction)validate:(id)sender;

@end
