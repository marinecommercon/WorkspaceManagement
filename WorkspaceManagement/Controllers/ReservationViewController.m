//
//  ReservationViewController.m
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ReservationViewController.h"

@interface ReservationViewController ()


@end

@implementation ReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSlider];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self initNavbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)validate:(id)sender {
    NSDate   *currentDate   = [Utils parseTimeToDate:self.beginTime];
    NSDate   *dateDeltaMore = [currentDate dateByAddingTimeInterval:(self.slider.value*30*60)];
    NSString *endTime = [Utils parseDateToTime:dateDeltaMore];
    
    // Save the reservation
    [ModelDAO addReservation:self.beginTime end:endTime room:self.room author:self.textFieldAuthor.text subject:self.textFieldSubject.text type:@"app-initial"];
    
    ValidationReservationViewController *validation = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationReservationViewController"];
    [self.navigationController pushViewController:validation animated:YES];
}

// HANDLE SLIDER

- (void) initSlider {
    
    // Check the maximum duration possible
    self.maxValue = [CheckDAO getMaxDuration:self.beginTime room:self.room];
    
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
    if ([(UISlider*)sender value] > self.maxValue) {
        [(UISlider*)sender setValue:self.maxValue];
    }
    
    int index = (int)(self.slider.value + 0.5);
    [self.slider setValue:index animated:NO];
}


// HANDLE NAVBAR

-(void) initNavbar {
    UIImage *left = [UIImage imageNamed:@"WSMImagesBtnExit"];
    self.navbar = [NavBarInstance sharedInstance];
    [self.navbar styleNavBar:self setTitle:@"RÉSERVER UNE SALLE" setLeftButton:left setRightButton:nil];
    [self.navbar.buttonLeft setHidden:false];
}

- (void)navbarLeftButton {
   [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
