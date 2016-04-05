//
//  ScheduleTableViewCell.h
//  WorkspaceManagement
//
//  Created by Lyess on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel  *timeUpLabel;
@property (weak, nonatomic) IBOutlet UILabel  *timeDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonCell;

@end
