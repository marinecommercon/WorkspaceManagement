//
//  DSIViewController.m
//  WorkspaceManagement
//
//  Created by Technique on 01/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "DSIViewController.h"

@interface DSIViewController () {
    NSArray<Room*> *_pickerData;
    Room           *roomSelected;
    NSMutableArray *cellDetails;
}

@end

@implementation DSIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavbar];

    self.schedulesArray = @[@"07:30", @"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30", @"12:00",@"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30",@"21:00"];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type CONTAINS[cd] %@", @"dsi"];
    NSArray *rooms  = [DAO getObjects:@"Room" withPredicate:nil];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    _pickerData = [rooms sortedArrayUsingDescriptors:sortDescriptors];
    
    roomSelected = [_pickerData objectAtIndex:0];
    
    // Set Picker Delegate
    self.pickerViewOutlet.dataSource = self;
    self.pickerViewOutlet.delegate   = self;
    
    // Set TableView Delegate
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection = NO;
    
    // Init the statesList
    cellDetails     = [[NSMutableArray alloc] init];
    for (int i=0; i<self.schedulesArray.count -1; i++) {
        // state + changed ?
        cellDetails[i] = @[@"Whatever",@"notChanged"];
    }
}

-(void) initNavbar {
    UIImage *left = [UIImage imageNamed:@"WSMImagesBtnExit"];
    UIImage *right = [UIImage imageNamed:@"DSIViewLibreImage"];
    self.navbar = [NavBarInstance sharedInstance];
    [self.navbar styleNavBar:self setTitle:@"PLANNING DSI" setLeftButton:left setRightButton:right];
    [self.navbar.buttonLeft setHidden:false];
}

- (void)navbarLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navbarRightButton {
    [ModelDAO deleteAllReservations];
    [self clearDetails];
    [_tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    roomSelected = [_pickerData objectAtIndex:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.text = _pickerData[row].name;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    
    UILabel *labelSelected = (UILabel*)[pickerView viewForRow:row forComponent:component];
    [labelSelected setTextColor:[UIColor bnpBlue]];
    return label;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row].name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self clearDetails];
    roomSelected = [_pickerData objectAtIndex:row];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// TABLE VIEW DELEGATE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.schedulesArray count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString  *CellIdentifier = @"ScheduleCellIdentifier";
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel  *timeUpLabel  = cell.timeUpLabel;
    UILabel  *timeDownLabel  = cell.timeDownLabel;
    UIButton *button = cell.buttonCell;
    
    timeUpLabel.text = self.schedulesArray[indexPath.row];
    timeDownLabel.text = self.schedulesArray[indexPath.row+1];
    
    [button setTag:indexPath.row];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *beginString = [self.schedulesArray objectAtIndex:indexPath.row];
    NSString *endString   = [self.schedulesArray objectAtIndex:indexPath.row+1];
    
    // No changes detected
    if([[cellDetails objectAtIndex:indexPath.row][1] isEqualToString:@"notChanged"]){
        BOOL available = [CheckDAO checkAvailabilityBegin:beginString withEnd:endString forRoom:roomSelected];
        if(available){
            cellDetails[indexPath.row] = @[@"free",@"notChanged"];
            cell.label.text = @"Libre";
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.imageState1 setBackgroundColor:[UIColor clearColor]];
            [cell.imageState2 setImage:[UIImage imageNamed:@"DSIViewLibreImage.png"]];
            cell.label.textColor = [UIColor bnpBlue];
        } else {
            NSString *type;
            
            // Get the corresponding reservation if exist
            Reservation *reservation = [ModelDAO getReservationForBegin:beginString room:roomSelected];
            if(reservation != nil) {
                type = reservation.type;
            }
            
            if([type isEqualToString:@"app-initial"]){
                [cell.imageState1 setBackgroundColor:[UIColor orangeColor]];
                cellDetails[indexPath.row] = @[@"busy-initial",@"notChanged"];
            }
            else if([type isEqualToString:@"app-confirmed"]){
                [cell.imageState1 setBackgroundColor:[UIColor redColor]];
                cellDetails[indexPath.row] = @[@"busy-confirmed",@"notChanged"];
            }
            else if([type isEqualToString:@"dsi"]){
                [cell.imageState1 setBackgroundColor:[UIColor bnpBlue]];
                cellDetails[indexPath.row] = @[@"busy-dsi",@"notChanged"];
            }
            cell.label.text = @"Occupé";
            [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            [cell.imageState2 setImage:[UIImage imageNamed:@"DSIViewOccupeImage.png"]];
            cell.label.textColor = [UIColor bnpBlue];
        }
    }
    // Changes detected
    else {
        NSString *state = [cellDetails objectAtIndex:indexPath.row][0];
        if([state isEqualToString:@"free"]){
            cell.label.text = @"Libre";
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.imageState1 setBackgroundColor:[UIColor clearColor]];
            [cell.imageState2 setImage:[UIImage imageNamed:@"DSIViewLibreImage.png"]];
            cell.label.textColor = [UIColor bnpBlue];
        }
        
        else if([state isEqualToString:@"busy-dsi"]){
            cell.label.text = @"Occupé";
            [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            [cell.imageState1 setBackgroundColor:[UIColor bnpBlue]];
            [cell.imageState2 setImage:[UIImage imageNamed:@"DSIViewOccupeImage.png"]];
            cell.label.textColor = [UIColor bnpGrey];
        }
        else if([state isEqualToString:@"busy-confirmed"]){
            cell.label.text = @"Occupé";
            [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            [cell.imageState1 setBackgroundColor:[UIColor redColor]];
            [cell.imageState2 setImage:[UIImage imageNamed:@"DSIViewOccupeImage.png"]];
            cell.label.textColor = [UIColor bnpGrey];
        }
        
        else {
            cell.label.text = @"ERROR";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath{
    NSLog(@"ok");
}

-(IBAction)buttonClicked:(id)sender {
    // Notify the list is now in progress
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NSString    *state     = [cellDetails objectAtIndex:indexPath.row][0];
    
    // Change value of state
    if([state isEqualToString:@"free"]){
        cellDetails[indexPath.row] = @[@"busy-dsi",@"changed"];
    }
    else if([state isEqualToString:@"busy-dsi"] || [state isEqualToString:@"busy-confirmed"]){
        cellDetails[indexPath.row] = @[@"free",@"changed"];
    }
    else if([state isEqualToString:@"busy-initial"]){
        cellDetails[indexPath.row] = @[@"busy-confirmed",@"changed"];
    }
    [_tableView reloadData];
    
}

- (IBAction)saveButton:(id)sender {
    [ModelDAO deleteReservationsFromRoom:roomSelected];
    for(int i=0; i<[cellDetails count]; i++){
        if ([cellDetails[i][0] isEqualToString:@"busy-dsi"]) {
            NSString *begin = [self.schedulesArray objectAtIndex:i];
            NSString *end = [self.schedulesArray objectAtIndex:i+1];
            [ModelDAO addReservation:begin end:end room:roomSelected author:nil subject:nil type:@"dsi"];
        }
        else if ([cellDetails[i][0] isEqualToString:@"busy-initial"]) {
            NSString *begin = [self.schedulesArray objectAtIndex:i];
            NSString *end   = [self.schedulesArray objectAtIndex:i+1];
            [ModelDAO addReservation:begin end:end room:roomSelected author:nil subject:nil type:@"app-initial"];
        }
        else if ([cellDetails[i][0] isEqualToString:@"busy-confirmed"]) {
            NSString *begin = [self.schedulesArray objectAtIndex:i];
            NSString *end   = [self.schedulesArray objectAtIndex:i+1];
            [ModelDAO addReservation:begin end:end room:roomSelected author:nil subject:nil type:@"app-confirmed"];
        }
    }
}

- (void) clearDetails {
    for (int i=0; i<[cellDetails count]; i++) {
        cellDetails[i] = @[@"Whatever",@"notChanged"];
    }
}

@end
