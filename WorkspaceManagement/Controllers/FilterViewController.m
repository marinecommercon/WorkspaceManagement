//
//  ContainerViewController.m
//  Workspace Management
//
//  Created by Lyess on 31/03/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()
{
    NSArray *numbers;
    NSTimer *timer;
    BOOL asynchtaskRunning;
}

@end

@implementation FilterViewController

- (void)awakeFromNib
{
    [self checkBeforeNextRound];
}

- (void)dealloc
{
    self.carousel.delegate = nil;
    self.carousel.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSeparatorShadow];
    
    asynchtaskRunning = false;
    
    [self initState];
    [self initSlider];
    [self initCarousel];
    self.roomsAppDsiFiltered   = [[NSMutableArray alloc] init];
    self.roomsFreeFiltered     = [[NSMutableArray alloc] init];
    self.roomsNotCorresponding = [[NSMutableArray alloc] init];
    
    // Init the filters
    [self updatePeopleLabel];
}

- (void) viewDidAppear:(BOOL)animated{
    [self shouldStartAsynchtaskCarousel];
}

- (void) initSeparatorShadow {
    self.view.layer.shadowOpacity = 0.5;
    self.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.view.layer.shadowRadius = 1;
    
    self.viewSlider.layer.shadowOpacity = 0.5;
    self.viewSlider.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewSlider.layer.shadowRadius = 1;
    
    self.viewDate.layer.shadowOpacity = 0.5;
    self.viewDate.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewDate.layer.shadowRadius = 1;
    
    self.viewNbrPeople.layer.shadowOpacity = 0.5;
    self.viewNbrPeople.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewNbrPeople.layer.shadowRadius = 1;
    
    self.viewRoomItems.layer.shadowOpacity = 0.5;
    self.viewRoomItems.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewRoomItems.layer.shadowRadius = 1;
    
    self.viewSearch.layer.shadowOpacity = 0.5;
    self.viewSearch.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewSearch.layer.shadowRadius = 1;
}


// Buttons and logic

- (void) updatePeopleLabel {
    NSString *peopleMsg = [NSString stringWithFormat:@"%d", self.numberOfPeople];
    [self.peopleLabel setText:peopleMsg];
}

// State 1 : can be selected
// State 2 : is selected
// State 0 : Can not be selected

- (IBAction)retroAction:(id)sender {
    Equipment *retro = [ModelDAO getEquipmentByKey:@"retro"];
    if([retro.filterState  isEqual: @(1)]){
        [retro setFilterState:@(2)];
        [self.retroButton setBackgroundColor:[UIColor bnpGreen]];
    }
    else if([retro.filterState  isEqual: @(2)]){
        [retro setFilterState:@(1)];
        [self.retroButton setBackgroundColor:nil];
    }
    [self checkBeforeNextRound];
}
- (IBAction)screenAction:(id)sender {
    Equipment *screen = [ModelDAO getEquipmentByKey:@"screen"];
    if([screen.filterState  isEqual: @(1)]){
        [screen setFilterState:@(2)];
        [self.screenButton setBackgroundColor:[UIColor bnpGreen]];
    }
    else if([screen.filterState  isEqual: @(2)]){
        [screen setFilterState:@(1)];
        [self.screenButton setBackgroundColor:nil];
    }
    [self checkBeforeNextRound];
}
- (IBAction)tableAction:(id)sender {
    Equipment *table = [ModelDAO getEquipmentByKey:@"table"];
    if([table.filterState  isEqual: @(1)]){
        [table setFilterState:@(2)];
        [self.tableButton setBackgroundColor:[UIColor bnpGreen]];
    }
    else if([table.filterState  isEqual: @(2)]){
        [table setFilterState:@(1)];
        [self.tableButton setBackgroundColor:nil];
    }
    [self checkBeforeNextRound];
}
- (IBAction)dockAction:(id)sender {
    Equipment *dock = [ModelDAO getEquipmentByKey:@"dock"];
    if([dock.filterState  isEqual: @(1)]){
        [dock setFilterState:@(2)];
        [self.dockButton setBackgroundColor:[UIColor bnpGreen]];
    }
    else if([dock.filterState  isEqual: @(2)]){
        [dock setFilterState:@(1)];
        [self.dockButton setBackgroundColor:nil];
    }
    [self checkBeforeNextRound];
}

- (IBAction)stepperAction:(id)sender {
    self.numberOfPeople = self.stepper.value;
    [self updatePeopleLabel];
    [self checkBeforeNextRound];
}

- (void) checkBeforeNextRound {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filterState != %@", @(2)];
    NSArray *equipmentList = [DAO getObjects:@"Equipment" withPredicate:predicate];
    for (Equipment *equipment in equipmentList){
        [self simulateSelectionForEquipment:equipment];
    }
    [self checkStepper];
}

- (void) checkStepper {
    self.numberOfPeople = self.stepper.value+1;
    NSPredicate    *predicate = [NSPredicate predicateWithFormat:@"filterState == %@", @(2)];
    NSMutableArray *equipmentList = (NSMutableArray *)[DAO getObjects:@"Equipment" withPredicate:predicate];
    
    if(![self atLeastOneRoomHasEquipments:equipmentList]){
        self.stepper.maximumValue = self.stepper.value;
    } else { self.stepper.maximumValue = 16;}
    self.numberOfPeople = self.stepper.value;
}

// For each equipment
// Turn button into transparent if combinaison would be possible
// Turn button into grey if combinaison wouldn't be possible

- (BOOL) simulateSelectionForEquipment:(Equipment*)equipment {
    
    // Suppose this equipment is selected in the next round
    [equipment setFilterState:@(2)];
    NSPredicate    *predicate = [NSPredicate predicateWithFormat:@"filterState == %@", @(2)];
    NSMutableArray *newEquipmentList = (NSMutableArray *)[DAO getObjects:@"Equipment" withPredicate:predicate];
    
    // Check if the new selection of selected equipment (state = 2) would find a room
    if([self atLeastOneRoomHasEquipments:newEquipmentList]){
        [equipment setFilterState:@(1)];
        
        if([equipment.key isEqualToString:@"retro"]){
            [self.retroButton setBackgroundColor:nil];
        }
        if([equipment.key isEqualToString:@"screen"]){
            [self.screenButton setBackgroundColor:nil];
        }
        if([equipment.key isEqualToString:@"table"]){
            [self.tableButton setBackgroundColor:nil];
        }
        if([equipment.key isEqualToString:@"dock"]){
            [self.dockButton setBackgroundColor:nil];
        }
        return true;
        
    } else {
        
        // Turn some equipments to grey
        [equipment setFilterState:@(0)];
        
        if([equipment.key isEqualToString:@"retro"]){
            [self.retroButton setBackgroundColor:[UIColor bnpGrey]];
        }
        if([equipment.key isEqualToString:@"screen"]){
            [self.screenButton setBackgroundColor:[UIColor bnpGrey]];
        }
        if([equipment.key isEqualToString:@"table"]){
            [self.tableButton setBackgroundColor:[UIColor bnpGrey]];
        }
        if([equipment.key isEqualToString:@"dock"]){
            [self.dockButton setBackgroundColor:[UIColor bnpGrey]];
        }
        return false;
    }
}

- (BOOL) atLeastOneRoomHasEquipments:(NSArray*)equipmentList {
    // At least one room is OK
    NSPredicate *predicate;
    if(self.realTime == false){
        predicate = [NSPredicate predicateWithFormat:@"type != %@", @"free"];
    } else {
        predicate = nil;
    }
    
    NSArray *rooms = [DAO getObjects:@"Room" withPredicate:predicate];
    for (Room *room in rooms){
        if([self room:room hasEquipments:equipmentList]){
            return true;
        }
    }
    return  false;
}

- (BOOL)room:(Room*)room hasEquipments:(NSArray*)equipmentList {
    for(Equipment *equipment in equipmentList){
        if(![room.equipments containsObject:equipment]){
            return false;
        }
    }
    if([room.maxPeople intValue] >= (int)self.numberOfPeople){
        return true;
    } else {
        return false;
    }
}

// MAPVIEW CALL

- (void) updateFilteredLists:(NSArray*)equipmentList {
    [self.roomsFreeFiltered     removeAllObjects];
    [self.roomsAppDsiFiltered   removeAllObjects];
    [self.roomsNotCorresponding removeAllObjects];
    
    NSArray *rooms = [DAO getObjects:@"Room" withPredicate:nil];
    for (Room *room in rooms){
        if([self room:room hasEquipments:equipmentList]){
            if([room.type isEqualToString:@"free"]){
                [self.roomsFreeFiltered addObject:room];
            }
            else {
                [self.roomsAppDsiFiltered addObject:room];
            }
        }
        else {
            [self.roomsNotCorresponding addObject:room];
        }
    }
}

#pragma mark HANDLE ASYNCHTASK CAROUSEL

- (void) shouldStopAsynchtaskCarousel {
    if(asynchtaskRunning){
        [timer invalidate];
        timer = nil;
        asynchtaskRunning = false;
    }
}

- (void) shouldStartAsynchtaskCarousel {
    if(!asynchtaskRunning){
        NSDate  *delay = [NSDate dateWithTimeIntervalSinceNow: 0.0];
        timer = [[NSTimer alloc] initWithFireDate: delay
                                         interval: 1
                                           target: self
                                         selector:@selector(updateCarousel:andPosition:)
                                         userInfo:nil repeats:YES];
        
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:timer forMode: NSDefaultRunLoopMode];
        asynchtaskRunning = true;
    }
}

// HANDLE SLIDER

- (void) initSlider {
    NSInteger numberOfSteps = 8;
    self.slider.maximumValue = numberOfSteps;
    self.slider.minimumValue = 0;
    self.slider.value = 1;
    self.slider.continuous   = YES;
    
    [self.slider addTarget:self
               action:@selector(valueChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    UIImage *sliderMinTrackImage = [UIImage imageNamed: @"Maxtrackimage.png"];
    UIImage *sliderMaxTrackImage = [UIImage imageNamed: @"Mintrackimage.png"];
    
    [self.slider setMinimumTrackImage:sliderMinTrackImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:sliderMaxTrackImage forState:UIControlStateNormal];
    
    [self.viewSlider addGestureRecognizer:recognizer];
    
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        self.slider.value = self.slider.value + 1;
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        self.slider.value = self.slider.value - 1;
    }
}

- (void)valueChanged:(UISlider *)sender
{
    float minValue = 1.0f;
    if ([(UISlider*)sender value] < minValue) {
        [(UISlider*)sender setValue:minValue];
    }
    
    int index = (int)(self.slider.value + 0.5);
    [self.slider setValue:index animated:NO];
    [self.delegate didChangeSlider:index];
}

// HANDLE CAROUSEL

- (void) updateCarousel:(NSTimer *)timer andPosition:(BOOL)updatePosition {
    
    self.hoursDictionnary = [Utils generateHoursForCaroussel:[self.schedulesArray objectAtIndex:self.realTimePosition]];
    if(updatePosition){
        [self.carousel scrollToItemAtIndex:self.realTimePosition animated:NO];
    }
    
    if(self.hoursDictionnary != nil){
        self.schedulesArray   = [self.hoursDictionnary objectForKey:@"hours"];
        self.realTimePosition = [[self.hoursDictionnary objectForKey:@"position"] intValue];
        [self.carousel reloadData];
        
        // We need to update carousel position if (for example) we go from 14:30 to 14:31
        // 14:00 (position 13) 14:29(position 14) 14:30(position 15)
        // Then, 14:00 (position 13) 14:30(position 14) 15:00(position 15)
        // Then, 14:00 (position 13) 14:30(position 14) 14:31(position 15)
        
        if(self.realTimePosition > self.carousel.currentItemIndex){
            [self.carousel reloadData];
            // scrollToItemAtIndex already delegate didChangeCarousel. No need to do it again.
            [self.carousel scrollToItemAtIndex:self.realTimePosition animated:NO];
        }
        else if(self.realTimePosition == self.carousel.currentItemIndex) {
            [self.delegate didChangeCarousel:self.schedulesArray position:self.carousel.currentItemIndex realTime:self.realTime];
        }
    }
}

- (void) initCarousel {
    // INIT TYPE
    [self.carousel setType:iCarouselTypeLinear];
    
    // Only to create movment
    [self.carousel setCurrentItemIndex:-1];
    
    UITapGestureRecognizer *tripleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapped:)];
    tripleTapGestureRecognizer.numberOfTapsRequired = 3;
    [self.carousel addGestureRecognizer:tripleTapGestureRecognizer];

    // INIT DATA
    self.schedulesArray = [[NSMutableArray alloc] init];
    self.hoursDictionnary = [Utils generateHoursForCaroussel:nil];
    if(self.hoursDictionnary != nil){
    
        self.schedulesArray   = [self.hoursDictionnary objectForKey:@"hours"];
        self.realTimePosition = [[self.hoursDictionnary objectForKey:@"position"] intValue];
        [self.carousel reloadData];
        [self.carousel scrollToItemAtIndex:self.realTimePosition animated:NO];
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78.0f, 78.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"CarouselitemindexGrey.png"];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor bnpGrey];
        label.font = [label.font fontWithSize:15];
        label.tag = 1;
        [view addSubview:label];
        
        self.carousel.scrollSpeed = 0.1;
        self.carousel.scrollToItemBoundary = true;
    }
    
    else
    {
        label = (UILabel *)[view viewWithTag:1];
    }
    
    label.text = self.schedulesArray[index];
    
    if (index == self.carousel.currentItemIndex)
    {
        label.font = [label.font fontWithSize:20];
        label.textColor = [UIColor bnpGreen];
        ((UIImageView *)view).image = [UIImage imageNamed:@"CarouselitemindexGreen.png"];
    }
    
    return view;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.schedulesArray count];
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
    
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    [self.carousel reloadData];
    
    // REAL TIME
    if(self.realTimePosition == self.carousel.currentItemIndex){
        self.realTime = true;
        [self checkBeforeNextRound];
        [self.delegate didChangeCarousel:self.schedulesArray position:self.carousel.currentItemIndex realTime:self.realTime];
    }
    
    // FUTURE + DOCK SELECTED
    else if(self.realTimePosition < self.carousel.currentItemIndex){
        Equipment *dock = [ModelDAO getEquipmentByKey:@"dock"];
        if([dock.filterState isEqual:@(2)]){
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"attention"
                                          message:@"Vous risquez de perdre votre sélection en cours. Souhaitez-vous poursuivre ?"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Oui"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [dock setFilterState:@(1)];
                                            self.realTime = false;
                                            [self checkBeforeNextRound];
                                            [self.delegate didChangeCarousel:self.schedulesArray position:self.carousel.currentItemIndex realTime:self.realTime];
                                        }];
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Non"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [self.carousel scrollToItemAtIndex:self.realTimePosition animated:NO];
                                       }];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        // FUTURE
        else {
            self.realTime = false;
            [self checkBeforeNextRound];
            [self.delegate didChangeCarousel:self.schedulesArray position:self.carousel.currentItemIndex realTime:self.realTime];
        }
    }
    
    // PAST TIME
    else {
        // Goes back to real Time
        [self.carousel scrollToItemAtIndex:self.realTimePosition animated:NO];
        self.realTime = true;
    }
}

// HANDLE OTHER

- (void) tripleTapped:(UIGestureRecognizer *)gestureRecognizer {
    DSIViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"DSIViewController"];
    [self.navigationController pushViewController:newView animated:YES];
    [self shouldStopAsynchtaskCarousel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// CHECK IF FILTERS CHANGED
- (BOOL) filtersChanged {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filterState == %@", @(2)];
    NSArray *equipmentList = [DAO getObjects:@"Equipment" withPredicate:predicate];

    // This is the initial state
    if(self.numberOfPeople == 1 && [equipmentList count] == 0){
        return false;
    }
    // Changes have been detected
    else {
        [self updateFilteredLists:equipmentList];
        return true;
    }
}

- (void) initState {
    self.stepper.value   = 1;
    self.numberOfPeople  = 1;
    self.slider.value    = 1;
    [self updatePeopleLabel];
    
    NSArray *equipmentList = [DAO getObjects:@"Equipment" withPredicate:nil];
    for(Equipment *equipment in equipmentList){
        [equipment setFilterState:@(1)];
    }
    [self.retroButton setBackgroundColor:nil];
    [self.screenButton setBackgroundColor:nil];
    [self.tableButton setBackgroundColor:nil];
    [self.dockButton setBackgroundColor:nil];
}

@end