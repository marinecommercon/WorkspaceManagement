//
//  ValidationReservationViewController.h
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBarInstance.h"
#import "FindRoomViewController.h"
#import "Reservation.h"

@interface ValidationReservationViewController : UIViewController

@property (strong, nonatomic) Reservation *reservation;
@property (strong, nonatomic) IBOutlet UIButton *buttonFindRoom;
@property (strong, nonatomic) IBOutlet UILabel *roomName;
@property (strong, nonatomic) IBOutlet UILabel *timeFrameLabel;
@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;

@end
