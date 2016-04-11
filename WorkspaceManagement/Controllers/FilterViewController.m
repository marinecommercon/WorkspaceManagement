//
//  ContainerViewController.m
//  Workspace Management
//
//  Created by Lyess on 31/03/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#import "FilterViewController.h"

@interface FilterViewController ()
{
    NSArray *numbers;
    NSTimer *timer;
    BOOL asynchtaskRunning;
    
    BOOL retroSelected;
    BOOL screenSelected;
    BOOL tableSelected;
    BOOL dockSelected;
}


@end

@implementation FilterViewController

@synthesize carousel;
@synthesize slider;
@synthesize viewSlider;

- (void)awakeFromNib
{
    self.schedulesArray = [[NSMutableArray alloc] init];
    self.schedulesArray = [[Utils generateHoursForCaroussel] objectForKey:@"hours"];
    [self.carousel reloadData];
}

- (void)dealloc
{
    carousel.delegate = nil;
    carousel.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.shadowOpacity = 0.5;
    self.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.view.layer.shadowRadius = 1;
    
    asynchtaskRunning = false;
    
    retroSelected     = false;
    screenSelected     = false;
    tableSelected     = false;
    dockSelected     = false;
    
    [self shouldStartAsynchtask];
    
    [self initSlider];
    [self initCarousel];
    [self updatePeopleLabel];
    
}

- (void) viewDidAppear:(BOOL)animated{
    [self shouldStartAsynchtask];
}


// Buttons and logic

- (void) updatePeopleLabel {
    NSString *peopleMsg = [NSString stringWithFormat:@"%d personne(s)", (int)self.stepper.value];
    [self.peopleLabel setText:peopleMsg];
}



- (IBAction)retroAction:(id)sender {
    if(!retroSelected){
        [self.retroButton setBackgroundColor:[self colorFromHexString:@"0acd00"]];
        retroSelected = true;
    } else {
        [self.retroButton setBackgroundColor:nil];
        retroSelected = false;
    }
}
- (IBAction)screenAction:(id)sender {
    if(!screenSelected){
        [self.screenButton setBackgroundColor:[self colorFromHexString:@"0acd00"]];
        screenSelected = true;
    } else {
        [self.screenButton setBackgroundColor:nil];
        screenSelected = false;
    }
}
- (IBAction)tableAction:(id)sender {
    if(!tableSelected){
        [self.tableButton setBackgroundColor:[self colorFromHexString:@"0acd00"]];
        tableSelected = true;
    } else {
        [self.tableButton setBackgroundColor:nil];
        tableSelected = false;
    }
}
- (IBAction)dockAction:(id)sender {
    if(!dockSelected){
        [self.dockButton setBackgroundColor:[self colorFromHexString:@"0acd00"]];
        dockSelected = true;
    } else {
        [self.dockButton setBackgroundColor:nil];
        dockSelected = false;
    }
}
- (IBAction)stepperAction:(id)sender {
    [self updatePeopleLabel];
}




- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}



- (void) shouldStopAsynchtask {
    if(asynchtaskRunning){
        [timer invalidate];
        timer = nil;
        asynchtaskRunning = false;
    }
}

- (void) shouldStartAsynchtask {
    if(!asynchtaskRunning){
        NSDate  *delay = [NSDate dateWithTimeIntervalSinceNow: 0.0];
        timer = [[NSTimer alloc] initWithFireDate: delay
                                         interval: 60
                                           target: self
                                         selector:@selector(updateCarousel:)
                                         userInfo:nil repeats:YES];
        
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:timer forMode: NSDefaultRunLoopMode];
        asynchtaskRunning = true;
    }
}


- (void) updateCarousel:(NSTimer *)timer {
    self.hoursDictionnary = [Utils generateHoursForCaroussel];
    self.schedulesArray   = [self.hoursDictionnary objectForKey:@"hours"];
    self.carouselPosition = [[self.hoursDictionnary objectForKey:@"position"] intValue];
    [self.carousel reloadData];
    [self.carousel scrollToItemAtIndex:self.carouselPosition animated:NO];
}

- (void) initCarousel {
    carousel.type   = iCarouselTypeLinear;
    UITapGestureRecognizer *tripleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapped:)];
    tripleTapGestureRecognizer.numberOfTapsRequired = 3;
    [self.carousel addGestureRecognizer:tripleTapGestureRecognizer];
    //[self updateCarousel:nil];
}

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

- (void) tripleTapped:(UIGestureRecognizer *)gestureRecognizer {
    DSIViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"DSIViewController"];
    [self.navigationController pushViewController:newView animated:YES];
    
    [self shouldStopAsynchtask];
    [self.delegate shouldStopAsynchtask];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.schedulesArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, self.view.frame.size.width / 5, self.view.frame.size.height / 5)];
        
        ((UIImageView *)view).image = [UIImage imageNamed:@"CarouselitemindexGrey.png"];
        
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0xbbbbbc);
        [label setFont:[UIFont fontWithName:@"DINPro-CondensedBold" size:20]];
        
        label.adjustsFontSizeToFitWidth=YES;
        label.minimumScaleFactor=0.5;
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
        [label setFont:[UIFont fontWithName:@"DINPro-CondensedBold" size:30]];
        label.textColor = UIColorFromRGB(0x24b270);
        label.adjustsFontSizeToFitWidth=YES;
        label.minimumScaleFactor=0.5;
        ((UIImageView *)view).image = [UIImage imageNamed:@"CarouselitemindexGreen.png"];
    }
    
    return view;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end