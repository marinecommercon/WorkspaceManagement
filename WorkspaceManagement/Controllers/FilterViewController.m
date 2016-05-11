//
//  ContainerViewController.m
//  Workspace Management
//
//  Created by Lyess on 31/03/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "FilterViewController.h"
#import "Constants.h"
#import "UIFont+AppAdditions.h"
#import "Equipment.h"

@interface FilterViewController ()
{
    NSArray *numbers;
    NSTimer *timer;
    BOOL asynchtaskRunning;
}

@end

@implementation FilterViewController

@synthesize carousel;
@synthesize slider;
@synthesize viewSlider;
@synthesize viewDate;
@synthesize viewNbrPeople;
@synthesize viewRoomItems;
@synthesize viewSearch;
@synthesize textFieldSearch;

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
    
    textFieldSearch.delegate = self;
    asynchtaskRunning = false;
    
    // INIT STATE = 1 = NOT SELECTED
    self.numberOfPeople = 1;
    
    //[self shouldStartAsynchtaskCarousel];
    [self initSlider];
    [self initCarousel];
    
    self.roomsAppDsiFiltered   = [[NSMutableArray alloc] init];
    self.roomsFreeFiltered     = [[NSMutableArray alloc] init];
    self.roomsNotCorresponding = [[NSMutableArray alloc] init];
    
    // Init the filters
    [self updatePeopleLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)textFieldEditingChanged:(id)sender
{
    textFieldSearch.font = UIFont.filterSearch;
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    textFieldSearch.font = UIFont.filterSearchDone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:NSDate.date dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self shouldStartAsynchtaskCarousel];
}

- (void) initSeparatorShadow
{
    for( UIView *v in @[self.view, self.viewSlider, self.viewDate, self.viewNbrPeople, self.viewRoomItems, self.viewSearch] )
    {
        v.layer.shadowOpacity = 0.5;
        v.layer.shadowOffset  = CGSizeZero;
        v.layer.shadowRadius  = 1;
    }
//    self.view.layer.shadowOpacity = 0.5;
//    self.view.layer.shadowOffset = CGSizeMake(0, 0);
//    self.view.layer.shadowRadius = 1;
//    
//    self.viewSlider.layer.shadowOpacity = 0.5;
//    self.viewSlider.layer.shadowOffset = CGSizeMake(0, 0);
//    self.viewSlider.layer.shadowRadius = 1;
//    
//    self.viewDate.layer.shadowOpacity = 0.5;
//    self.viewDate.layer.shadowOffset = CGSizeMake(0, 0);
//    self.viewDate.layer.shadowRadius = 1;
//    
//    self.viewNbrPeople.layer.shadowOpacity = 0.5;
//    self.viewNbrPeople.layer.shadowOffset = CGSizeMake(0, 0);
//    self.viewNbrPeople.layer.shadowRadius = 1;
//    
//    self.viewRoomItems.layer.shadowOpacity = 0.5;
//    self.viewRoomItems.layer.shadowOffset = CGSizeMake(0, 0);
//    self.viewRoomItems.layer.shadowRadius = 1;
//    
//    self.viewSearch.layer.shadowOpacity = 0.5;
//    self.viewSearch.layer.shadowOffset = CGSizeMake(0, 0);
//    self.viewSearch.layer.shadowRadius = 1;
}


// Buttons and logic

- (void) updatePeopleLabel
{
    self.peopleLabel.text = [NSString stringWithFormat:@"%d", self.numberOfPeople];
}

// State 1 : can be selected
// State 2 : is selected
// State 0 : Can not be selected

- (IBAction)retroAction:(id)sender
{
    Equipment *retro = [ModelDAO equipmentWithKey:kDAOEquipmentTypeRetro];
    
//    if( [retro.filterState isEqualToNumber:@(1)] )
//    {
//        retro.filterState = @(2);
//        //[self.retroButton setBackgroundColor:[UIColor bnpGreen]];
//        UIImage *image = [UIImage imageNamed: @"WSMImagesBtnSelectedRetro"];
//        [self.retroButton setImage:image forState:UIControlStateNormal];
//    }
//    else if( [retro.filterState isEqualToNumber: @(2)] )
//    {
//        [retro setFilterState:@(1)];
//        [self.retroButton setBackgroundColor:nil];
//    }
    
    switch( (EquipmentSelectableState)retro.filterState.intValue )
    {
        case kEquipmentUnselectable: break;

        case kEquipmentSelectable : // can be selected
            retro.filterState = @(kEquipmentSelected);
            //[self.retroButton setBackgroundColor:[UIColor bnpGreen]];
            [self.retroButton setImage:[UIImage imageNamed: @"WSMImagesBtnSelectedRetro"]
                              forState:UIControlStateNormal];
            break;
            
        case kEquipmentSelected : // is selected
            retro.filterState = @(kEquipmentSelectable);
            [self.retroButton setImage:[UIImage imageNamed: @"WSMImagesBtnOffRetro"]
                              forState:UIControlStateNormal];
            break;
    }

    [self checkBeforeNextRound];
}
- (IBAction)screenAction:(id)sender
{
    Equipment *screen = [ModelDAO equipmentWithKey:kDAOEquipmentTypeScreen];
    
//    if([screen.filterState isEqual: @(1)])
//    {
//        screen.filterState = @(2);
//        UIImage *image = [UIImage imageNamed: @"WSMImagesBtnSelectedScreen"];
//        [self.screenButton setImage:image forState:UIControlStateNormal];
//    }
//    else if([screen.filterState  isEqual: @(2)]){
//        [screen setFilterState:@(1)];
//        UIImage *image = [UIImage imageNamed: @"WSMImagesBtnOffScreen"];
//        [self.screenButton setImage:image forState:UIControlStateNormal];
//    }
    
    switch( (EquipmentSelectableState)screen.filterState.intValue )
    {
        case kEquipmentUnselectable: break;

        case kEquipmentSelectable : // can be selected
            screen.filterState = @(kEquipmentSelected);
            [self.screenButton setImage:[UIImage imageNamed: @"WSMImagesBtnSelectedScreen"]
                               forState:UIControlStateNormal];
            break;
            
        case kEquipmentSelected : // is selected
            screen.filterState = @(kEquipmentSelectable);
            [self.screenButton setImage:[UIImage imageNamed: @"WSMImagesBtnOffScreen"]
                               forState:UIControlStateNormal];
            break;
    }

    [self checkBeforeNextRound];
}

- (IBAction)tableAction:(id)sender
{
    Equipment *table = [ModelDAO equipmentWithKey:kDAOEquipmentTypeTable];
    
//    if([table.filterState  isEqual: @(1)]){
//        [table setFilterState:@(2)];
//        //[self.tableButton setBackgroundColor:[UIColor bnpGreen]];
//        UIImage *image = [UIImage imageNamed: @"WSMImagesBtnSelectedTable"];
//        [self.tableButton setImage:image forState:UIControlStateNormal];
//    }
//    else if([table.filterState  isEqual: @(2)]){
//        [table setFilterState:@(1)];
//        UIImage *image = [UIImage imageNamed: @"WSMImagesBtnOffTable"];
//        [self.tableButton setImage:image forState:UIControlStateNormal];;
//    }
    
    switch( (EquipmentSelectableState)table.filterState.intValue )
    {
        case kEquipmentUnselectable: break;

        case kEquipmentSelectable : // can be selected
            table.filterState = @(kEquipmentSelected);
            [self.tableButton setImage:[UIImage imageNamed: @"WSMImagesBtnSelectedTable"]
                              forState:UIControlStateNormal];
            break;
            
        case kEquipmentSelected : // is selected
            table.filterState = @(kEquipmentSelectable);
            [self.tableButton setImage:[UIImage imageNamed: @"WSMImagesBtnOffTable"]
                              forState:UIControlStateNormal];;
            break;
    }
    
    [self checkBeforeNextRound];
}
- (IBAction)dockAction:(id)sender
{
    Equipment *dock = [ModelDAO equipmentWithKey:kDAOEquipmentTypeDock];
    
//    if([dock.filterState  isEqual: @(1)]){
//        [dock setFilterState:@(2)];
//        //[self.dockButton setBackgroundColor:[UIColor bnpGreen]];
//        UIImage *image = [UIImage imageNamed: @"WSMImagesBtnSelectedDock"];
//        [self.dockButton setImage:image forState:UIControlStateNormal];
//    }
//    else if([dock.filterState  isEqual: @(2)]){
//        [dock setFilterState:@(1)];
//        UIImage *image = [UIImage imageNamed: @"WSMImagesBtnOffDock"];
//        [self.dockButton setImage:image forState:UIControlStateNormal];
//    }
    
    switch( (EquipmentSelectableState)dock.filterState.intValue )
    {
        case kEquipmentUnselectable: break;
            
        case kEquipmentSelectable : // can be selected
            dock.filterState = @(kEquipmentSelected);
            [self.dockButton setImage:[UIImage imageNamed: @"WSMImagesBtnSelectedDock"]
                              forState:UIControlStateNormal];
            break;
            
        case kEquipmentSelected : // is selected
            dock.filterState = @(kEquipmentSelectable);
            [self.dockButton setImage:[UIImage imageNamed: @"WSMImagesBtnOffDock"]
                              forState:UIControlStateNormal];;
            break;
    }
    
    [self checkBeforeNextRound];
}

- (IBAction)stepperAction:(id)sender
{
    self.numberOfPeople = self.stepper.value;
    [self checkBeforeNextRound];
    [self updatePeopleLabel];
}

- (void)checkBeforeNextRound
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filterState != %d", kEquipmentSelected];
    NSArray *equipmentList = [DAO getObjects:kDAOEquipmentEntity withPredicate:predicate];
    
    for (Equipment *equipment in equipmentList)
        [self simulateSelectionForEquipment:equipment];

    [self checkStepper];
}

- (void)checkStepper
{
    self.numberOfPeople = self.stepper.value+1;
    
    NSPredicate    *predicate = [NSPredicate predicateWithFormat:@"filterState == %d", kEquipmentSelected];
    NSMutableArray *equipmentList = (NSMutableArray *)[DAO getObjects:kDAOEquipmentEntity withPredicate:predicate];
    
//    if( ![self atLeastOneRoomHasEquipments:equipmentList] )
//        self.stepper.maximumValue = self.stepper.value;
//    else
//        self.stepper.maximumValue = 16;
    
    self.stepper.maximumValue = ( [self atLeastOneRoomHasEquipments:equipmentList] ? 16 : self.stepper.value );
    
    self.numberOfPeople = self.stepper.value;
}

// For each equipment
// Turn button into transparent if combinaison would be possible
// Turn button into grey if combinaison wouldn't be possible

- (BOOL)simulateSelectionForEquipment:(Equipment *)equipment
{
    // Suppose this equipment is selected in the next round
    equipment.filterState = @(kEquipmentSelected);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filterState == %d", kEquipmentSelected];
    NSArray *newEquipmentList = [DAO getObjects:kDAOEquipmentEntity withPredicate:predicate];
    
    // Check if the new selection of selected equipment (state = 2) would find a room
    if( [self atLeastOneRoomHasEquipments:newEquipmentList] )
    {
        equipment.filterState = @(kEquipmentSelectable);
        
        if( [equipment.key isEqualToString:kDAOEquipmentTypeRetro] )
            self.retroButton.backgroundColor = nil;
        else if( [equipment.key isEqualToString:kDAOEquipmentTypeScreen] )
            self.screenButton.backgroundColor = nil;
        else if( [equipment.key isEqualToString:kDAOEquipmentTypeTable] )
            self.tableButton.backgroundColor = nil;
        else if( [equipment.key isEqualToString:kDAOEquipmentTypeDock] )
            self.dockButton.backgroundColor = nil;

        return true;
    }
    else
    {
        // Turn some equipments to grey
        equipment.filterState = @(kEquipmentUnselectable);
        
        if( [equipment.key isEqualToString:kDAOEquipmentTypeRetro] )
            [self.retroButton setImage:[UIImage imageNamed: @"WSMImagesBtnOffRetro"]
                              forState:UIControlStateNormal];
        else if( [equipment.key isEqualToString:kDAOEquipmentTypeScreen] )
            [self.screenButton setImage:[UIImage imageNamed: @"WSMImagesBtnOffScreen"]
                               forState:UIControlStateNormal];
        else if( [equipment.key isEqualToString:kDAOEquipmentTypeTable] )
            [self.tableButton setImage:[UIImage imageNamed: @"WSMImagesBtnOffTable"]
                              forState:UIControlStateNormal];
        else if( [equipment.key isEqualToString:kDAOEquipmentTypeDock] )
            [self.dockButton setImage:[UIImage imageNamed: @"WSMImagesBtnOffDock"]
                             forState:UIControlStateNormal];
        
        return false;
    }
}

- (BOOL)atLeastOneRoomHasEquipments:(NSArray *)equipmentList
{
    // At least one room is OK
    NSPredicate *predicate = ( self.realTime ? nil : [NSPredicate predicateWithFormat:@"type != %@", kReservationTypeFree] );
    
//    if(self.realTime == false){
//        predicate = [NSPredicate predicateWithFormat:@"type != %@", @"free"];
//    } else {
//        predicate = nil;
//    }
    
    NSArray *rooms = [DAO getObjects:kDAORoomEntity withPredicate:predicate];
    
    for (Room *room in rooms)
        if( [self room:room hasEquipments:equipmentList] )
            return YES;

    return NO;
}

- (BOOL)room:(Room *)room hasEquipments:(NSArray *)equipmentList
{
    // Does Room have ALL esuipments listed ?
    for(Equipment *equipment in equipmentList)
        if( ![room.equipments containsObject:equipment] )
            return NO;

//    if( [room.maxPeople intValue] >= (int)self.numberOfPeople){
//        return true;
//    } else {
//        return false;
//    }
    
    return room.maxPeople.intValue >= self.numberOfPeople;
}

// MAPVIEW CALL

- (void)updateFilteredLists:(NSArray *)equipmentList
{
    [self.roomsFreeFiltered     removeAllObjects];
    [self.roomsAppDsiFiltered   removeAllObjects];
    [self.roomsNotCorresponding removeAllObjects];
    
    NSArray *rooms = [DAO getObjects:kDAORoomEntity withPredicate:nil];
    
    for (Room *room in rooms)
    {
        if( [self room:room hasEquipments:equipmentList] )
        {
            if( [room.type isEqualToString:kReservationTypeFree] )
                [self.roomsFreeFiltered addObject:room];
            else
                [self.roomsAppDsiFiltered addObject:room];
        }
        else
            [self.roomsNotCorresponding addObject:room];
    }
}

#pragma mark HANDLE ASYNCHTASK CAROUSEL

- (void)shouldStopAsynchtaskCarousel
{
    if( asynchtaskRunning )
    {
        [timer invalidate];
        timer = nil;
        asynchtaskRunning = NO;
    }
}

- (void)shouldStartAsynchtaskCarousel
{
    if( !asynchtaskRunning )
    {
//        NSDate *delay = [NSDate dateWithTimeIntervalSinceNow:0.0];
//        timer = [[NSTimer alloc] initWithFireDate: delay
//                                         interval: 1
//                                           target: self
//                                         selector:@selector(updateCarousel:andPosition:)
//                                         userInfo:nil repeats:YES];
//        
//        NSRunLoop *runner = [NSRunLoop currentRunLoop];
//        [runner addTimer:timer forMode: NSDefaultRunLoopMode];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(updateCarousel:andPosition:)
                                               userInfo:nil
                                                repeats:YES];
        
        asynchtaskRunning = YES;
    }
}

// HANDLE SLIDER

- (void)initSlider
{
    NSInteger numberOfSteps = 8;
    slider.maximumValue = numberOfSteps;
    slider.minimumValue = 0;
    slider.continuous = YES;
    
    [self.slider addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    UIImage *sliderMinTrackImage = [UIImage imageNamed: @"Maxtrackimage.png"];
    UIImage *sliderMaxTrackImage = [UIImage imageNamed: @"Mintrackimage.png"];
    
    [self.slider setMinimumTrackImage:sliderMinTrackImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:sliderMaxTrackImage forState:UIControlStateNormal];
    
    [self.viewSlider addGestureRecognizer:recognizer];
    [self.viewSlider addGestureRecognizer:tapGestureRecognizer];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)sliderTapped:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pointTaped = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGPoint positionOfSlider = slider.frame.origin;
    
    float widthOfSlider = slider.frame.size.width;
    float newValue = ((pointTaped.x - positionOfSlider.x) * slider.maximumValue) / widthOfSlider;
    int closedPoint = (int)roundf(newValue);
    slider.value = closedPoint;
    [self.delegate didChangeSlider:closedPoint];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
//    {
//        self.slider.value++;
//    }
//    
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
//    {
//        self.slider.value = self.slider.value - 1;
//    }
    
    switch( recognizer.direction )
    {
        case UISwipeGestureRecognizerDirectionRight : self.slider.value = self.slider.value + 1.0; break;
        case UISwipeGestureRecognizerDirectionLeft : self.slider.value = self.slider.value - 1.0; break;
            
        default: break;
    }
}

- (void)valueChanged:(UISlider *)sender
{
//    float minValue = 1.0f;
//    if ([(UISlider*)sender value] < minValue) {
//        [(UISlider*)sender setValue:minValue];
//    }
    
    sender.value = MAX( 1.0, sender.value );
    
    int index = (int)(self.slider.value + 0.5);
    
    [self.slider setValue:index animated:NO];
    [self.delegate didChangeSlider:index];
}

// HANDLE CAROUSEL

- (void)updateCarousel:(NSTimer *)timer andPosition:(BOOL)updatePosition
{
    self.hoursDictionnary = [Utils generateHoursForCaroussel:self.schedulesArray[self.realTimePosition]];
    
    if(updatePosition)
        [self.carousel scrollToItemAtIndex:self.realTimePosition animated:NO];
    
    if(self.hoursDictionnary != nil)
    {
        self.schedulesArray   = self.hoursDictionnary[kCarouselKeyHours];
        self.realTimePosition = [self.hoursDictionnary[kCarouselKeyPosition] intValue];
        [self.carousel reloadData];
        
        // We need to update carousel position if (for example) we go from 14:30 to 14:31
        // 14:00 (position 13) 14:29(position 14) 14:30(position 15)
        // Then, 14:00 (position 13) 14:30(position 14) 15:00(position 15)
        // Then, 14:00 (position 13) 14:30(position 14) 14:31(position 15)
        
        if( self.realTimePosition > self.carousel.currentItemIndex )
        {
            [self.carousel reloadData];
            // scrollToItemAtIndex already delegate didChangeCarousel. No need to do it again.
            [self.carousel scrollToItemAtIndex:self.realTimePosition animated:NO];
        }
        else if( self.realTimePosition == self.carousel.currentItemIndex )
        {
            [self.delegate didChangeCarousel:self.schedulesArray
                                    position:self.carousel.currentItemIndex
                                    realTime:self.realTime];
        }
    }
}

- (void)initCarousel
{
    // INIT TYPE
    self.carousel.type = iCarouselTypeLinear;
    
    // Only to create movment
    self.carousel.currentItemIndex = -1;
    
    UITapGestureRecognizer *tripleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapped:)];
    tripleTapGestureRecognizer.numberOfTapsRequired = 3;
    [self.carousel addGestureRecognizer:tripleTapGestureRecognizer];

    // INIT DATA
    self.schedulesArray = [[NSMutableArray alloc] init];
    self.hoursDictionnary = [Utils generateHoursForCaroussel:nil];
    if( self.hoursDictionnary != nil )
    {
        self.schedulesArray   = self.hoursDictionnary[kCarouselKeyHours];
        self.realTimePosition = [self.hoursDictionnary[kCarouselKeyPosition] intValue];
        [self.carousel reloadData];
        [self.carousel scrollToItemAtIndex:self.realTimePosition animated:NO];
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    if (view == nil)
    {
        CGRect carouselFrm = self.carousel.frame;
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake( carouselFrm.origin.x, carouselFrm.origin.y, carouselFrm.size.width / 2.97, carouselFrm.size.height)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"CarouselitemindexGrey.png"];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = UIColor.clearColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColor.bnpGrey;
        label.font = UIFont.carouselSmall;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5;
        label.tag = 1;
        [view addSubview:label];
        
        CGRect frame = label.frame;
        frame.origin.y = -2;
        frame.origin.x = 0;
        label.frame= frame;
        
        self.carousel.scrollSpeed = 0.1;
        self.carousel.scrollToItemBoundary = true;
    }
    else
        label = (UILabel *)[view viewWithTag:1];
    
    label.text = self.schedulesArray[index];
    
    if (index == self.carousel.currentItemIndex )
    {
        label.font = UIFont.carouselBig;
        label.textColor = UIColor.bnpGreen;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5;
        ((UIImageView *)view).image = [UIImage imageNamed:@"CarouselitemindexGreen.png"];

        CGRect frame = label.frame;
        frame.origin.y = -7;
        frame.origin.x = 0;
        label.frame= frame;
    }
    
    return view;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.schedulesArray.count;
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
    if( self.realTimePosition == self.carousel.currentItemIndex )
    {
        self.realTime = YES;
        [self checkBeforeNextRound];
        [self.delegate didChangeCarousel:self.schedulesArray
                                position:self.carousel.currentItemIndex
                                realTime:self.realTime];
    }
    
    // FUTURE + DOCK SELECTED
    else if( self.realTimePosition < self.carousel.currentItemIndex )
    {
        Equipment *dock = [ModelDAO equipmentWithKey:kDAOEquipmentTypeDock];
        
        if( (EquipmentSelectableState)dock.filterState.intValue == kEquipmentSelected )
        {
            UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Attention"
                                                                             message:@"Vous risquez de perdre votre sélection en cours. Souhaitez-vous poursuivre ?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Oui"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            dock.filterState = @(kEquipmentSelectable);
                                            self.realTime = false;
                                            [self checkBeforeNextRound];
                                            [self.delegate didChangeCarousel:self.schedulesArray
                                                                    position:self.carousel.currentItemIndex
                                                                    realTime:self.realTime];
                                        }];
            UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Non"
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
        else
        {
            self.realTime = NO;
            [self checkBeforeNextRound];
            [self.delegate didChangeCarousel:self.schedulesArray
                                    position:self.carousel.currentItemIndex
                                    realTime:self.realTime];
        }
    }
    
    // PAST TIME
    else
    {
        // Goes back to real Time
        [self.carousel scrollToItemAtIndex:self.realTimePosition animated:NO];
        self.realTime = YES;
    }
}

// HANDLE OTHER

- (void)tripleTapped:(UIGestureRecognizer *)gestureRecognizer
{
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
- (BOOL)filtersChanged
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filterState == %d", kEquipmentSelected];
    NSArray *equipmentList = [DAO getObjects:kDAOEquipmentEntity withPredicate:predicate];

    // This is the initial state
    if( self.numberOfPeople == 1 && equipmentList.count == 0)
        return NO;
    // Changes have been detected
    else
    {
        [self updateFilteredLists:equipmentList];
        return YES;
    }
}

- (void)initState
{
    self.stepper.value   = 1;
    self.numberOfPeople  = 1;
    self.slider.value    = 1;
    [self updatePeopleLabel];
    
    NSArray *equipmentList = [DAO getObjects:kDAOEquipmentEntity withPredicate:nil];
    
    for(Equipment *equipment in equipmentList)
        equipment.filterState = @(kEquipmentSelectable);
    
    self.retroButton.backgroundColor  = nil;
    self.screenButton.backgroundColor = nil;
    self.tableButton.backgroundColor  = nil;
    self.dockButton.backgroundColor   = nil;
}

@end