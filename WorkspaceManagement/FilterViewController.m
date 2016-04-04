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
}

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation FilterViewController

@synthesize carousel;
@synthesize items;
@synthesize slider;
@synthesize viewSlider;

- (void)awakeFromNib
{
    self.items = [[NSMutableArray alloc] init];
    [self.items addObject:@"7:00"];
    [self.items addObject:@"7:30"];
    [self.items addObject:@"8:00"];
    [self.items addObject:@"8:30"];
    [self.items addObject:@"9:00"];
    [self.items addObject:@"9:30"];
    [self.items addObject:@"10:00"];
    [self.items addObject:@"10:30"];
    [self.items addObject:@"11:00"];
    [self.items addObject:@"11:30"];
    [self.items addObject:@"12:00"];
    [self.items addObject:@"12:30"];
    [self.items addObject:@"13:00"];
    [self.items addObject:@"13:30"];
    [self.items addObject:@"14:00"];
    [self.items addObject:@"14:30"];
    [self.items addObject:@"15:00"];
    [self.items addObject:@"15:30"];
    [self.items addObject:@"16:00"];
    [self.items addObject:@"16:30"];
    [self.items addObject:@"17:00"];
    [self.items addObject:@"17:30"];
    [self.items addObject:@"18:00"];
    [self.items addObject:@"18:30"];
    [self.items addObject:@"19:00"];
    [self.items addObject:@"19:30"];
    [self.items addObject:@"20:00"];
}

- (void)dealloc
{
    carousel.delegate = nil;
    carousel.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    carousel.type = iCarouselTypeLinear;
    [self.carousel scrollToItemAtIndex:4 animated:NO];
    
    numbers = @[@(0), @(1), @(2), @(3), @(4)];
    NSInteger numberOfSteps = ((float)[numbers count] - 1);
    
    slider.maximumValue = numberOfSteps;
    slider.minimumValue = 0;
    slider.continuous = YES;
    
    [slider addTarget:self
               action:@selector(valueChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self viewSlider] addGestureRecognizer:recognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [self.viewSlider addGestureRecognizer:tapGestureRecognizer];
    
    UIImage *sliderMinTrackImage = [UIImage imageNamed: @"Maxtrackimage.png"];
    UIImage *sliderMaxTrackImage = [UIImage imageNamed: @"Mintrackimage.png"];
    
    sliderMinTrackImage = [sliderMinTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
    sliderMaxTrackImage = [sliderMaxTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22)];
    
    [slider setMinimumTrackImage:sliderMinTrackImage forState:UIControlStateNormal];
    [slider setMaximumTrackImage:sliderMaxTrackImage forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tripleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapped:)];
    tripleTapGestureRecognizer.numberOfTapsRequired = 3;
    [self.carousel addGestureRecognizer:tripleTapGestureRecognizer];
}

- (void) tripleTapped:(UIGestureRecognizer *)gestureRecognizer {
    DSIViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"DSIViewController"];
    [self.navigationController pushViewController:newView animated:YES];
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
    return [items count];
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
        label.textColor = UIColorFromRGB(0xbbbbbc);
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
    
    label.text = items[index];
    
    if (index == self.carousel.currentItemIndex)
    {
        label.font = [label.font fontWithSize:20];
        label.textColor = UIColorFromRGB(0x24b270);
        ((UIImageView *)view).image = [UIImage imageNamed:@"CarouselitemindexGreen.png"];
    }
    
    return view;
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    NSLog(@"Carousel will begin dragging");
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    NSLog(@"Carousel did end dragging and %@ decelerate", decelerate? @"will": @"won't");
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
    NSLog(@"Carousel will begin scrolling");
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    NSLog(@"Carousel did end scrolling");
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