//
//  PopupDetailViewController.h
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "ModelDAO.h"
#import "UIColor+AppAdditions.h"
#import "ReservationViewController.h"

@protocol PopupDetailViewControllerDelegate
- (void)didClickOnReservation:(Room*)room;
@end

@interface PopupDetailViewController : UIViewController

@property (nonatomic, weak) id<PopupDetailViewControllerDelegate> delegate;

@property (strong,nonatomic)  Room *room;
@property (strong, nonatomic) IBOutlet UIImageView *PopupImagesBackgroundRoom;
@property (strong, nonatomic) IBOutlet UIButton *ButtonExit;
@property (strong, nonatomic) IBOutlet UIImageView *PopupImagesGeoloc;
@property (strong, nonatomic) IBOutlet UILabel *PopupRoomNameTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *PopupRoomCapacityLabel;
@property (strong, nonatomic) IBOutlet UILabel *PopupRoomDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *PopupReservationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *Popup1ItemsImage;
@property (strong, nonatomic) IBOutlet UIImageView *Popup2ItemsImage;
@property (strong, nonatomic) IBOutlet UIImageView *Popup3ItemsImage;
@property (strong, nonatomic) IBOutlet UIImageView *Popup4ItemsImage;
@property (strong, nonatomic) IBOutlet UILabel *Popup1ItemsLabel;
@property (strong, nonatomic) IBOutlet UILabel *Popup2ItemsLabel;
@property (strong, nonatomic) IBOutlet UILabel *Popup3ItemsLabel;
@property (strong, nonatomic) IBOutlet UILabel *Popup4ItemsLabel;
@property (strong, nonatomic) IBOutlet UIButton *PopupRoomBookButton;
@property (strong, nonatomic) IBOutlet UILabel *PopupRoomStateLabel;

- (void) setInfos:(Room*)room;

@end
