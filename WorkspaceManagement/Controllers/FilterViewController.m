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

@synthesize carousel;
@synthesize slider;
@synthesize viewSlider;

- (void)awakeFromNib
{
    
    [self checkBeforeNextRound];
}

- (void)dealloc
{
    carousel.delegate = nil;
    carousel.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    asynchtaskRunning = false;
    
    // INIT STATE = 1 = NOT SELECTED
    self.numberOfPeople = 1;
    
    //[self shouldStartAsynchtaskCarousel];
    [self initSlider];
    [self initCarousel];
    
    // Init the filters
    [self updatePeopleLabel];
}

- (void) viewDidAppear:(BOOL)animated{
    [self shouldStartAsynchtaskCarousel];
}


// Buttons and logic

- (void) updatePeopleLabel {
    NSString *peopleMsg = [NSString stringWithFormat:@"%d personne(s)", self.numberOfPeople];
    [self.peopleLabel setText:peopleMsg];
}

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
    [self checkBeforeNextRound];
    [self updatePeopleLabel];
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

// HANDLE ASYNCHTASK

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
                                         selector:@selector(updateCarousel:)
                                         userInfo:nil repeats:YES];
        
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:timer forMode: NSDefaultRunLoopMode];
        asynchtaskRunning = true;
    }
}

// HANDLE SLIDER

- (void) initSlider {
    numbers = @[@(0), @(1), @(2), @(3), @(4)];
    NSInteger numberOfSteps = ((float)[numbers count] - 1);
    
    slider.maximumValue = numberOfSteps;
    slider.minimumValue = 0;
    slider.continuous = YES;
    
    [slider addTarget:self
               action:@selector(valueChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    UIImage *sliderMinTrackImage = [UIImage imageNamed: @"Maxtrackimage.png"];
    UIImage *sliderMaxTrackImage = [UIImage imageNamed: @"Mintrackimage.png"];
    sliderMinTrackImage = [sliderMinTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
    sliderMaxTrackImage = [sliderMaxTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
    
    [self.viewSlider addGestureRecognizer:recognizer];
    [self.viewSlider addGestureRecognizer:tapGestureRecognizer];
    [slider setMinimumTrackImage:sliderMinTrackImage forState:UIControlStateNormal];
    [slider setMaximumTrackImage:sliderMaxTrackImage forState:UIControlStateNormal];
}

- (void)sliderTapped:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pointTaped = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGPoint positionOfSlider = slider.frame.origin;
    
    float widthOfSlider = slider.frame.size.width;
    float newValue = ((pointTaped.x - positionOfSlider.x) * slider.maximumValue) / widthOfSlider;
    int closedPoint = (int)roundf(newValue);
    [slider setValue:closedPoint];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        slider.value = slider.value + 1;
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        slider.value = slider.value - 1;
    }
}

- (void)valueChanged:(UISlider *)sender
{
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    NSNumber *number = numbers[index];
    NSLog(@"Index: %i", (int)index);
    NSLog(@"Number: %@", number);
}

// HANDLE CAROUSEL

- (void) updateCarousel:(NSTimer *)timer {
    self.hoursDictionnary = [Utils generateHoursForCaroussel:[self.schedulesArray objectAtIndex:self.realTimePosition]];
    
    if(self.hoursDictionnary != nil){
        self.schedulesArray   = [self.hoursDictionnary objectForKey:@"hours"];
        self.realTimePosition = [[self.hoursDictionnary objectForKey:@"position"] intValue];
        [self.carousel reloadData];
        
        // We need tu update carousel position if (for example) we go from 14:30 to 14:31
        // 14:00 (position 13) 14:29(position 14) 14:30(position 15)
        // Then, 14:00 (position 13) 14:30(position 14) 15:00(position 15)
        // Then, 14:00 (position 13) 14:30(position 14) 14:31(position 15)
        
        if(self.realTimePosition > self.carousel.currentItemIndex){
            [self.carousel reloadData];
            // scrollToItemAtIndex already delegate didChangeCarousel. No need to do it again.
            [self.carousel scrollToItemAtIndex:self.realTimePosition animated:NO];
        }
        else if(self.realTimePosition == self.carousel.currentItemIndex) {
            [self.delegate didChangeCarousel:[self.schedulesArray objectAtIndex:self.carousel.currentItemIndex] realTime:self.realTime];
        }
    }
}

- (void) initCarousel {
    // INIT TYPE
    carousel.type   = iCarouselTypeLinear;
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
        [self.delegate didChangeCarousel:[self.schedulesArray objectAtIndex:self.carousel.currentItemIndex] realTime:self.realTime];
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
                                            [self.delegate didChangeCarousel:[self.schedulesArray objectAtIndex:self.carousel.currentItemIndex] realTime:self.realTime];
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
            [self.delegate didChangeCarousel:[self.schedulesArray objectAtIndex:self.carousel.currentItemIndex] realTime:self.realTime];
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

@end