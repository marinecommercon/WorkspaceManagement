//
//  DSIViewController.h
//  WorkspaceManagement
//
//  Created by Technique on 01/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"
#import "CheckDAO.h"
#import "ModelDAO.h"
#import "Room.h"
#import "Reservation.h"
#import "ScheduleTableViewCell.h"
#import "Utils.h"

@interface DSIViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong)  NSArray               *schedulesArray;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerViewOutlet;
@property (strong, nonatomic) IBOutlet UITableView  *tableView;
@property (nonatomic,strong)  UIColor               *blueColor;
@property (nonatomic,strong)  UIColor               *greyColor;

- (IBAction)saveButton:(id)sender;
- (IBAction)resetButton:(id)sender;

@end
