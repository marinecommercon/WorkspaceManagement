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

#import "ContainerViewController.h"

@interface ContainerViewController ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ContainerViewController

@synthesize carousel;

@synthesize items;

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
        ((UIImageView *)view).image = [UIImage imageNamed:@"page2.png"];
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
    
    //Set label from array
    label.text = items[index];
    
    //Detecter position centrale
    if (index == self.carousel.currentItemIndex)
    {
        //Changement de font/couleur des items
        label.font = [label.font fontWithSize:20];
        
        //Changement de font/couleur des items
        label.textColor = UIColorFromRGB(0x24b270);
        
        //Ajout d'images en fonction de la position
        ((UIImageView *)view).image = [UIImage imageNamed:@"page1.png"];
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