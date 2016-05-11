//
//  DSIViewController.m
//  WorkspaceManagement
//
//  Created by Technique on 01/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "DSIViewController.h"
#import "Constants.h"
#import "UIFont+AppAdditions.h"

@interface DSIViewController () {
    NSArray<Room*> *_pickerData;
    Room *roomSelected;
    NSMutableArray<NSArray<NSString *> *> *cellDetails;
}

@end

@implementation DSIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset"
    //                                                                    style:UIBarButtonItemStyleDone target:nil action:nil];
    //    self.navigationItem.rightBarButtonItem = rightButton;
    //
    //    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
    //                                                                   style:UIBarButtonItemStyleDone target:nil action:nil];
    //    self.navigationItem.leftBarButtonItem = leftButton;

    self.schedulesArray = @[@"07:30", @"08:00", @"08:30", @"09:00",
                            @"09:30", @"10:00", @"10:30", @"11:00",
                            @"11:30", @"12:00",@"12:30", @"13:00",
                            @"13:30", @"14:00", @"14:30", @"15:00",
                            @"15:30", @"16:00", @"16:30", @"17:00",
                            @"17:30", @"18:00", @"18:30", @"19:00",
                            @"19:30", @"20:00", @"20:30",@"21:00"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type CONTAINS[cd] %@", kReservationTypeDsi];
    
    NSArray *rooms = [DAO getObjects:kDAORoomEntity withPredicate:predicate];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kDAORoomName ascending:YES]];
    _pickerData = [rooms sortedArrayUsingDescriptors:sortDescriptors];
    
    roomSelected = [_pickerData objectAtIndex:0];
    
    // Set Picker Delegate
    self.pickerViewOutlet.dataSource = self;
    self.pickerViewOutlet.delegate   = self;
    
    // Set TableView Delegate
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    
    // Init the statesList
    cellDetails = [[NSMutableArray alloc] init];
    [self clearDetails];
}

- (void) updateNavBar
{
//    UIImage *left = [UIImage imageNamed:@"WSMImagesBtnRetour"];
//    UIImage *right = [UIImage imageNamed:@"WSMImagesBtnEffacer"];
//    
//    NavBarInstance *custom = [NavBarInstance sharedInstance];
//    [custom styleNavBar:self setTitle:@"GESTION DES SALLES" setLeftButton:left setRightButton:right];

    [[NavBarInstance sharedInstance] setTitle:@"GESTION DES SALLES"
                              leftButtonImage:[UIImage imageNamed:@"WSMImagesBtnRetour"]
                             rightButtonImage:[UIImage imageNamed:@"WSMImagesBtnEffacer"]
                            forViewController:self];
}

- (void)backTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    roomSelected = _pickerData.firstObject;
    
    [self updateNavBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}

- (void)launchLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"MDr");
}

- (void)launchRight
{
    [ModelDAO deleteAllReservations];
    [self clearDetails];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColor.grayColor;
    label.text = _pickerData[row].name;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    
    UILabel *labelSelected = (UILabel*)[pickerView viewForRow:row forComponent:component];
    labelSelected.textColor = UIColor.bnpDsiTextBlue;
    return label;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row].name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self clearDetails];
    roomSelected = _pickerData[row];
    [_tableView reloadData];
}

// TABLE VIEW DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.schedulesArray.count-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *CellIdentifier = @"ScheduleCellIdentifier";
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel  *timeUpLabel  = cell.timeUpLabel;
    UILabel  *timeDownLabel  = cell.timeDownLabel;
    UIButton *button = cell.buttonCell;
    
    timeUpLabel.text   = self.schedulesArray[indexPath.row];
    timeDownLabel.text = self.schedulesArray[indexPath.row+1];
    
    [button setTag:indexPath.row];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *beginString = self.schedulesArray[indexPath.row];
    NSString *endString   = self.schedulesArray[indexPath.row+1];
    
    // No changes detected
    if( [cellDetails[indexPath.row][1] isEqualToString:kDsiCtrlReservationNotChanged] )
    {
        BOOL available = [CheckDAO checkAvailabilityBegin:beginString
                                                  withEnd:endString
                                                  forRoom:roomSelected];
        if( available )
        {
            cellDetails[indexPath.row] = @[kReservationTypeFree, kDsiCtrlReservationNotChanged];
            cell.label.text = @"Libre";
            cell.label.font = UIFont.dsiAvailable;
            cell.backgroundColor = UIColor.clearColor;
            cell.imageState1.backgroundColor = UIColor.clearColor;
            cell.imageState2.image = [UIImage imageNamed:@"DSIViewLibreImage.png"];
            cell.label.textColor = UIColor.bnpDsiTextBlue;
        }
        else
        {
            NSString *type;
            
            // Get the corresponding reservation if exist
            Reservation *reservation = [ModelDAO reservationForBegin:beginString room:roomSelected];
            if( reservation != nil )
            {
                type = reservation.type;
            }
            
            if( [type isEqualToString:kReservationTypeAppInitial] )
            {
                cell.imageState1.backgroundColor = UIColor.orangeColor;
                cellDetails[indexPath.row] = @[kReservationTypeBusyInitial, kDsiCtrlReservationNotChanged];
            }
            else if( [type isEqualToString:kReservationTypeAppConfirmed] )
            {
                cell.imageState1.backgroundColor = UIColor.redColor;
                cellDetails[indexPath.row] = @[kReservationTypeBusyConfirmed, kDsiCtrlReservationNotChanged];
            }
            else if( [type isEqualToString:kReservationTypeDsi] )
            {
                cell.imageState1.backgroundColor = UIColor.bnpBlue;
                cellDetails[indexPath.row] = @[kReservationTypeBusyDsi, kDsiCtrlReservationNotChanged];
            }
            
            cell.label.text = @"Occupé";
            cell.label.font = UIFont.dsiNotAvailable;
            cell.backgroundColor = UIColor.groupTableViewBackgroundColor;
            cell.imageState1.backgroundColor = UIColor.bnpDsiTextBlue;
            cell.imageState2.image = [UIImage imageNamed:@"DSIViewOccupeImage.png"];
            cell.label.textColor = UIColor.bnpDsiTextBlue;
        }
    }
    // Changes detected
    else
    {
        NSString *state = cellDetails[indexPath.row][0];
        
        if( [state isEqualToString:kReservationTypeFree] )
        {
            cell.label.text = @"Libre";
            cell.label.font = UIFont.dsiAvailable;
            cell.backgroundColor = UIColor.clearColor;
            cell.imageState1.backgroundColor = UIColor.clearColor;
            cell.imageState2.image = [UIImage imageNamed:@"DSIViewLibreImage.png"];
            cell.label.textColor = UIColor.bnpDsiTextBlue;
        }
        else if( [state isEqualToString:kReservationTypeBusyDsi] )
        {
            // TODO : check string @"busy"
            cell.label.text = @"Occupé";
            cell.label.font = UIFont.dsiNotAvailable;
            cell.backgroundColor = UIColor.groupTableViewBackgroundColor;
            cell.imageState1.backgroundColor = UIColor.bnpDsiTextBlue;
            cell.imageState2.image = [UIImage imageNamed:@"DSIViewOccupeImage.png"];
            cell.label.textColor = UIColor.bnpGrey;
        }
        else if( [state isEqualToString:kReservationTypeBusyConfirmed] )
        {
            cell.label.text = @"Occupé";
            cell.backgroundColor = UIColor.groupTableViewBackgroundColor;
            cell.imageState1.backgroundColor = UIColor.redColor;
            cell.imageState2.image = [UIImage imageNamed:@"DSIViewOccupeImage.png"];
            cell.label.textColor = UIColor.bnpGrey;
        }
        else
        {
            cell.label.text = @"ERROR";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    NSLog(@"ok");
}

- (IBAction)buttonClicked:(id)sender
{
    // Notify the list is now in progress
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NSString    *state     = cellDetails[indexPath.row][0];
    
    // Change value of state
    if( [state isEqualToString:kReservationTypeFree] )
    {
        cellDetails[indexPath.row] = @[kReservationTypeBusyDsi, kDsiCtrlReservationChanged];
    }
    else if( [state isEqualToString:kReservationTypeBusyDsi] || [state isEqualToString:kReservationTypeBusyConfirmed] )
    {
        cellDetails[indexPath.row] = @[kReservationTypeFree, kDsiCtrlReservationChanged];
    }
    else if( [state isEqualToString:kReservationTypeBusyInitial] )
    {
        cellDetails[indexPath.row] = @[kReservationTypeBusyConfirmed, kDsiCtrlReservationChanged];
    }
    
    [_tableView reloadData];
}

- (IBAction)saveButton:(id)sender
{
    [ModelDAO deleteReservationsFromRoom:roomSelected];
    
    for(int i = 0; i < cellDetails.count; i++)
    {
        NSString *begin = nil;
        NSString *end = nil;
        NSString *type = nil;
        NSString *cellState = cellDetails[i][0];
        
        if( [cellState isEqualToString:kReservationTypeBusyDsi] )
        {
            begin = self.schedulesArray[i];
            end   = self.schedulesArray[i+1];
            type  = kReservationTypeDsi;
        }
        else if( [cellState isEqualToString:kReservationTypeBusyInitial] )
        {
            begin = self.schedulesArray[i];
            end   = self.schedulesArray[i+1];
            type  = kReservationTypeAppInitial;
        }
        else if( [cellState isEqualToString:kReservationTypeBusyConfirmed] )
        {
            begin = self.schedulesArray[i];
            end   = self.schedulesArray[i+1];
            type  = kReservationTypeAppConfirmed;
        }
        
        if( begin && end && type )
            [ModelDAO addReservation:begin end:end room:roomSelected author:nil subject:nil type:type];
    }
}

- (void)clearDetails
{
    for(NSString *hourStr in self.schedulesArray)
        [cellDetails addObject:@[kDsiCtrlReservationWhatever, kDsiCtrlReservationNotChanged]];
}

@end
