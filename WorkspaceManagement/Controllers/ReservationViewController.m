//
//  ReservationViewController.m
//  WorkspaceManagement
//
//  Created by Lyess on 15/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ReservationViewController.h"
#import "NavBarInstance.h"
#import "Constants.h"
#import "UIFont+AppAdditions.h"

@interface ReservationViewController ()


@end

@implementation ReservationViewController

@synthesize slider;
@synthesize viewSlider;
@synthesize viewTextField;
@synthesize textFieldAdd;
@synthesize textFieldAuthor;
@synthesize textFieldSubject;
@synthesize sliderInitialValue;

@synthesize buttonValidationReservation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSlider];
    
    textFieldAuthor.delegate = self;
    textFieldSubject.delegate = self;
    
    textFieldAdd.enabled = NO;
    
//    [buttonValidationReservation addTarget:self
//                                    action:@selector(buttonValiderReservation)
//                          forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    
    buttonValidationReservation.layer.cornerRadius = 5;
    buttonValidationReservation.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)textFieldEditingChanged:(id)sender
{
    textFieldAuthor.font = UIFont.reservationEditing;
}

- (IBAction)textFieldEditingChanged2:(id)sender
{
    textFieldSubject.font = UIFont.reservationEditing;
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    textFieldAuthor.font = UIFont.reservationEditingDone;
    textFieldSubject.font = UIFont.reservationEditingDone;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateNavBar];
}

// HANDLE SLIDER

- (void)initSlider
{
    // Check the maximum duration possible
    self.maxValue = [CheckDAO getMaxDuration:self.beginTime room:self.room];
    
    NSInteger numberOfSteps = 8;
    self.slider.maximumValue = numberOfSteps;
    self.slider.minimumValue = 0;
    self.slider.value = self.sliderInitialValue;
    self.slider.continuous   = YES;
    
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
    
- (void)sliderTapped:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pointTaped = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGPoint positionOfSlider = self.slider.frame.origin;
    
    float widthOfSlider = slider.frame.size.width;
    float newValue = ((pointTaped.x - positionOfSlider.x) * self.slider.maximumValue) / widthOfSlider;
    int closedPoint = (int)roundf(newValue);
    self.slider.value = closedPoint;
    [self.delegate didChangeSlider:closedPoint];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
//    {
//        self.slider.value = self.slider.value + 1;
//    }
//    
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
//    {
//        self.slider.value = self.slider.value - 1;
//    }
    
    switch( recognizer.direction )
    {
        case UISwipeGestureRecognizerDirectionRight: self.slider.value = self.slider.value + 1.0; break;
        case UISwipeGestureRecognizerDirectionLeft:  self.slider.value = self.slider.value - 1.0; break;
            
        default: break;
    }
}

- (void)valueChanged:(UISlider *)sender
{
//    float minValue = 1.0f;
//    if ([(UISlider*)sender value] < minValue) {
//        [(UISlider*)sender setValue:minValue];
//    }
//    if ([(UISlider*)sender value] > self.maxValue) {
//        [(UISlider*)sender setValue:self.maxValue];
//    }
    
    sender.value = MAX( 1.0, MIN( self.maxValue, sender.value ) );
    
    int index = (int)(self.slider.value + 0.5);
    [self.slider setValue:index animated:NO];
}

// HANDLE NAVBAR

- (void) updateNavBar {
    
//    UIImage *left = [UIImage imageNamed:@"WSMImagesNavbarPrevious"];
//    
//    NavBarInstance *custom = [NavBarInstance sharedInstance];
//    [custom styleNavBar:self setTitle:@"RÉSERVER UNE SALLE" setLeftButton:left setRightButton:nil];
 
    [[NavBarInstance sharedInstance] setTitle:@"RÉSERVER UNE SALLE"
                              leftButtonImage:[UIImage imageNamed:@"WSMImagesNavbarPrevious"]
                             rightButtonImage:nil
                            forViewController:self];
}

- (void)launchLeft
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)launchRight
{
    NSLog(@"Help");
}

- (IBAction)validate:(id)sender
{
    NSDate   *currentDate   = [Utils parseTimeToDate:self.beginTime];
    NSDate   *dateDeltaMore = [currentDate dateByAddingTimeInterval:(self.slider.value*30*60)]; // add 30 minutes
    NSString *endTime       = [Utils parseDateToTime:dateDeltaMore];
    
    // Save the reservation
    Reservation *r = [ModelDAO addReservation:self.beginTime
                                          end:endTime
                                         room:self.room
                                       author:self.textFieldAuthor.text
                                      subject:self.textFieldSubject.text
                                         type:kReservationTypeAppInitial];
    
    ValidationReservationViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationReservationViewController"];
    viewController.reservation = r;
    [self presentViewController:viewController animated:NO completion:nil];
}

//- (void)buttonValiderReservation
//{
//    NSLog(@"Validation Reservation");
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ValidationReservationViewController *viewController = (ValidationReservationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ValidationReservationViewController"];
//    [self presentViewController:viewController animated:NO completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
