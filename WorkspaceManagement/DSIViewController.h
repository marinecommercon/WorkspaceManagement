//
//  DSIViewController.h
//  WorkspaceManagement
//
//  Created by Technique on 01/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSIViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong)  NSArray               *schedulesArray;
@property (nonatomic,strong)  NSArray               *beginSchedules;
@property (nonatomic,strong)  NSArray               *endSchedules;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerViewOutlet;
@property (strong, nonatomic) IBOutlet UITableView  *tableView;

- (IBAction)saveButton:(id)sender;
- (IBAction)resetButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
