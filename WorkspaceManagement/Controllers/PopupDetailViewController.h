//
//  PopupDetailViewController.h
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *PopupImagesBackgroundRoom;

@property (strong, nonatomic) IBOutlet UIButton *ButtonExit;

@property (strong, nonatomic) IBOutlet UIImageView *PopupImagesGeoloc;

@property (strong, nonatomic) IBOutlet UILabel *PopupRoomNameTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *PopupRoomCapacityLabel;

@property (strong, nonatomic) IBOutlet UILabel *PopupRoomDescriptionLabel;

@property (strong, nonatomic) IBOutlet UILabel *PopupRoomFreeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *Popup1ItemsImage;

@property (strong, nonatomic) IBOutlet UIImageView *Popup2ItemsImage;

@property (strong, nonatomic) IBOutlet UIImageView *Popup3ItemsImage;

@property (strong, nonatomic) IBOutlet UIImageView *Popup4ItemsImage;

@property (strong, nonatomic) IBOutlet UILabel *Popup1ItemsLabel;

@property (strong, nonatomic) IBOutlet UILabel *Popup2ItemsLabel;

@property (strong, nonatomic) IBOutlet UILabel *Popup3ItemsLabel;

@property (strong, nonatomic) IBOutlet UILabel *Popup4ItemsLabel;

@property (strong, nonatomic) IBOutlet UIButton *PopupRoomBookButton;

@property (strong, nonatomic) IBOutlet UILabel *PopupRoomFreeLabel2;

@end
