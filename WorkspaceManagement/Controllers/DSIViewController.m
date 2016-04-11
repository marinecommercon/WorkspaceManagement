//
//  DSIViewController.m
//  WorkspaceManagement
//
//  Created by Technique on 01/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

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
    
    //    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset"
    //                                                                    style:UIBarButtonItemStyleDone target:nil action:nil];
    //    self.navigationItem.rightBarButtonItem = rightButton;
    //
    //    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
    //                                                                   style:UIBarButtonItemStyleDone target:nil action:nil];
    //    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.schedulesArray = @[@"07:30", @"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30", @"12:00",@"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30",@"21:00"];
    
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

//- (void)styleNavBar {
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
//    [newNavBar setTintColor:[UIColor whiteColor]];
//    UINavigationItem *newItem = [[UINavigationItem alloc] init];
//    newItem.title = @"Paths";
//
//    // BackButtonBlack is an image we created and added to the app’s asset catalog
//    UIImage *backButtonImage = [UIImage imageNamed:@"WSMImagesBtnExit"];
//
//    // any buttons in a navigation bar are UIBarButtonItems, not just regular UIButtons. backTapped: is the method we’ll call when this button is tapped
//    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
//
//    // the bar button item is actually set on the navigation item, not the navigation bar itself.
//    newItem.leftBarButtonItem = backBarButtonItem;
//
//    [newNavBar setItems:@[newItem]];
//    [self.view addSubview:newNavBar];
//}

- (void)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSLog(@"initial value %@", [_pickerData objectAtIndex:0].name);
    roomSelected = [_pickerData objectAtIndex:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}

- (void)launchLeft {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"MDr");
}

- (void)launchRight {
    [ModelDAO deleteAllReservations];
    [self clearDetails];
    [_tableView reloadData];
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
    [labelSelected setTextColor:UIColorFromRGB(0x0086f4)];
    
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
    return [self.schedulesArray count]-1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString  *CellIdentifier = @"ScheduleCellIdentifier";
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Show the title of the hike
    UILabel  *timeUpLabel  = cell.timeUpLabel;
    UILabel  *timeDownLabel  = cell.timeDownLabel;
    UIButton *button = cell.buttonCell;
    
    timeUpLabel.text = self.schedulesArray[indexPath.row];
    timeDownLabel.text = self.schedulesArray[indexPath.row+1];
    
    
    [button setTag:indexPath.row];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *beginString = [self.schedulesArray objectAtIndex:indexPath.row];
    NSString *endString   = [self.schedulesArray objectAtIndex:indexPath.row+1];
    
    
    // No changes in changed
    if([[cellDetails objectAtIndex:indexPath.row][1] isEqualToString:@"notChanged"]){
        BOOL available = [CheckDAO checkAvailability:beginString End:endString Room:roomSelected];
        
        if(available){
            cellDetails[indexPath.row] = @[@"free",@"notChanged"];
            cell.label.text = @"Libre";
            //[button setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.imageState1 setBackgroundColor:[UIColor clearColor]];
            [cell.imageState2 setImage:[UIImage imageNamed:@"DSIViewLibreImage.png"]];
            cell.label.textColor = UIColorFromRGB(0x0086f4);
            //[cell.buttonCell setTitleColor:UIColorFromRGB(0x0086f4) forState:UIControlStateNormal];
        } else {
            cellDetails[indexPath.row] = @[@"busy",@"notChanged"];
            cell.label.text = @"Occupé";
            //[button setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            [cell.imageState1 setBackgroundColor:UIColorFromRGB(0x0086f4)];
            [cell.imageState2 setImage:[UIImage imageNamed:@"DSIViewOccupeImage.png"]];
            cell.label.textColor = UIColorFromRGB(0x7e7a70);
            //[cell.buttonCell setTitleColor:UIColorFromRGB(0x7e7a70) forState:UIControlStateNormal];
            
        }
    }
    // Changes in changed
    else {
        NSString *state = [cellDetails objectAtIndex:indexPath.row][0];
        if([state isEqualToString:@"free"]){
            cell.label.text = @"Libre";
            //[button setBackgroundColor:[UIColor greenColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.imageState1 setBackgroundColor:[UIColor clearColor]];
            [cell.imageState2 setImage:[UIImage imageNamed:@"DSIViewLibreImage.png"]];
            cell.label.textColor = UIColorFromRGB(0x0086f4);
            //[cell.buttonCell setTitleColor:UIColorFromRGB(0x0086f4) forState:UIControlStateNormal];
        }
        
        else if([state isEqualToString:@"busy"]){
            cell.label.text = @"Occupé";
            //[button setBackgroundColor:[UIColor redColor]];
            [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            [cell.imageState1 setBackgroundColor:UIColorFromRGB(0x0086f4)];
            [cell.imageState2 setImage:[UIImage imageNamed:@"DSIViewOccupeImage.png"]];
            cell.label.textColor = UIColorFromRGB(0x7e7a70);
            //[cell.buttonCell setTitleColor:UIColorFromRGB(0x7e7a70) forState:UIControlStateNormal];
        }
        
        else {
            cell.label.text = @"ERROR";
            //[button setBackgroundColor:[UIColor yellowColor]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"ok");
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
    [ModelDAO deleteReservationsFromRoom:roomSelected];
    for(int i=0; i<[cellDetails count]; i++){
        if ([cellDetails[i][0] isEqualToString:@"busy"]) {
            NSString *begin = [self.schedulesArray objectAtIndex:i];
            [ModelDAO addReservationWithBegin:begin forRoom:roomSelected];
        }
    }
}

- (IBAction)resetButton:(id)sender {
    [ModelDAO deleteAllReservations];
    [self clearDetails];
    [_tableView reloadData];
}

- (void) clearDetails {
    for (int i=0; i<[cellDetails count]; i++) {
        cellDetails[i] = @[@"Whatever",@"notChanged"];
    }
}

@end
