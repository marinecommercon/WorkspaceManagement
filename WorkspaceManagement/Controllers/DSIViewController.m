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
    
    
    //      Reload database
    //      [DAO deletePlanning];
    //      [DAO addRoomsForPlanning];
    
    self.schedulesArray = @[@"7h30 - 8h00",@"8h00 - 8h30",@"8h30 - 9h00",@"9h00 - 9h30", @"9h30 - 10h00",@"10h00 - 10h30",@"10h30 - 11h00",@"11h00 - 11h30", @"11h30 - 12h00", @"12h00 - 12h30",@"12h30 - 13h00", @"13h00 - 13h30", @"13h30 - 14h00", @"14h00 - 14h30", @"14h30 - 15h00", @"15h00 - 15h30", @"15h30 - 16h00", @"16h00 - 16h30", @"16h30 - 17h00", @"17h00 - 17h30", @"17h30 - 18h00", @"18h00 - 18h30", @"18h30 - 19h00", @"19h00 - 19h30", @"19h30 - 20h00", @"20h00 - 20h30", @"20h30 - 21h00"];
    
    self.beginSchedules = @[@"07:30", @"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30", @"12:00",@"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30"];
    
    self.endSchedules = @[@"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30", @"12:00",@"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30", @"21:00"];
    
    
    _pickerData  = [DAO getObjects:@"Room" withPredicate:nil];
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
    for (int i=0; i<100; i++) {
        // state + changed ?
        cellDetails[i] = @[@"Whatever",@"notChanged"];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSLog(@"initial value %@", [_pickerData objectAtIndex:0].name);
    roomSelected = [_pickerData objectAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"new value %@", [_pickerData objectAtIndex:row].name);
    [self clearDetails];
    roomSelected = [_pickerData objectAtIndex:row];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// TABLE VIEW DELEGATE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.schedulesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString  *CellIdentifier = @"ScheduleCellIdentifier";
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Show the title of the hike
    UILabel  *label  = cell.label;
    UIButton *button = cell.buttonCell;
    
    label.text = self.schedulesArray[indexPath.row];
    [button setTag:indexPath.row];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *beginString = [self.beginSchedules objectAtIndex:indexPath.row];
    NSString *endString   = [self.endSchedules objectAtIndex:indexPath.row];
    
    
    // No changes in changed
    if([[cellDetails objectAtIndex:indexPath.row][1] isEqualToString:@"notChanged"]){
        BOOL available = [DAO checkAvailability:beginString End:endString Room:roomSelected];
        
        if(available){
            cellDetails[indexPath.row] = @[@"free",@"notChanged"];
            [button setTitle:@"LIBRE" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor greenColor]];
        } else {
            cellDetails[indexPath.row] = @[@"busy",@"notChanged"];
            [button setTitle:@"OCCUPE" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor redColor]];
        }
    }
    // Changes in changed
    else {
        NSString *state = [cellDetails objectAtIndex:indexPath.row][0];
        if([state isEqualToString:@"free"]){
            [button setTitle:@"LIBRE" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor greenColor]];
        }
        
        else if([state isEqualToString:@"busy"]){
            [button setTitle:@"OCCUPE" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor redColor]];
        }
        
        else {
            [button setTitle:@"ERROR" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor yellowColor]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)buttonClicked:(id)sender {
    // Notify the list is now in progress
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NSString    *state     = [cellDetails objectAtIndex:indexPath.row][0];
    
    // Change value of state
    if([state isEqualToString:@"free"]){
        cellDetails[indexPath.row] = @[@"busy",@"changed"];
    }
    else {
        cellDetails[indexPath.row] = @[@"free",@"changed"];
    }
    [_tableView reloadData];
}

- (IBAction)saveButton:(id)sender {
    [DAO deleteReservationsFromRoom:roomSelected];
    for(int i=0; i<[cellDetails count]; i++){
        if ([cellDetails[i][0] isEqualToString:@"busy"]) {
            NSString *begin = [self.beginSchedules objectAtIndex:i];
            [DAO addReservationWithBegin:begin forRoom:roomSelected];
        }
    }
}

- (IBAction)resetButton:(id)sender {
    [DAO deleteAllReservations];
    [self clearDetails];
    [_tableView reloadData];
}

- (void) clearDetails {
    for (int i=0; i<[cellDetails count]; i++) {
        cellDetails[i] = @[@"Whatever",@"notChanged"];
    }
}

@end
