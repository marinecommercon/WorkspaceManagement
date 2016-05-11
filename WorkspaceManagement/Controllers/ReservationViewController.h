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

@protocol ReservationViewControllerDelegate

- (void)didChangeSlider:(int)sliderValue;
@end

@interface ReservationViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<ReservationViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *buttonValidationReservation;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIView *viewSlider;
@property (assign, nonatomic) float sliderInitialValue;

@property (strong, nonatomic) IBOutlet UIView *viewTextField;
@property (strong, nonatomic) IBOutlet UITextField *TextFieldNom;
@property (strong, nonatomic) IBOutlet UITextField *TextFieldNameReunion;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAdd;



//@property (strong,nonatomic) NavBarInstance *navbar;

@property (strong, nonatomic)  Room *room;
@property (copy, nonatomic)  NSString *beginTime;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAuthor;
@property (strong, nonatomic) IBOutlet UITextField *textFieldSubject;
@property float maxValue;

- (IBAction)validate:(id)sender;

@end
