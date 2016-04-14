//
//  ReservationViewController.h
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidationReservationViewController.h"

@interface ReservationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIView *viewSlider;

@property (strong, nonatomic) IBOutlet UITextField *TextFieldNom;
@property (strong, nonatomic) IBOutlet UITextField *TextFieldNameReunion;

- (IBAction)validate:(id)sender;

@end
