//
//  ViewController.m
//  Workspace Management
//
//  Created by Lyess on 31/03/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    int floor;
}

@synthesize container;
@synthesize myMapView;
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initContainerSwipeGesture];
    
    floor = 1;
    
    [self initMap];


    
}

- (void)initMap
{
    
    locationManager = [[CLLocationManager alloc] init];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status ==kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Location Authorization granted");
    } else {
        NSLog(@"Requesting Location Authorization");
        [locationManager requestWhenInUseAuthorization];
    }
    
    myMapView = (MWZMapView*)[self myMapView];
    MWZMapOptions* options = [[MWZMapOptions alloc] init];
    options.apiKey = @"f1a08de88e9353ed5a9e97a0f89bdxdf";
    myMapView.delegate = self;
    [myMapView loadMapWithOptions: options];
    
    [myMapView fitBounds:[[MWZLatLonBounds alloc] initWithNorthEast:[[MWZLatLon alloc] initWithLatitude:@48.82633358744936 longitude:@2.259978353977203] southWest:[[MWZLatLon alloc] initWithLatitude:@48.8254489062897 longitude:@2.258988618850708]]];
}

- (void)initContainerSwipeGesture
{
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [container addGestureRecognizer:swipeUp];
    [container addGestureRecognizer:swipeDown];
}

- (void)initContainerAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
}

- (void)swipeUp:(UIGestureRecognizer *)swipe
{
    [self initContainerAnimation];
    
    CGRect frame = container.frame;
    switch (floor)
    {
        case (0):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.13;
            container.frame = frame;
            floor = 1;
            self.myMapView.userInteractionEnabled = true;
            break;
        case (1):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.3;
            container.frame = frame;
            floor = 2;
            self.myMapView.userInteractionEnabled = false;
            break;
        case (2):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 3;
            container.frame = frame;
            floor = 3;
            self.myMapView.userInteractionEnabled = false;
            break;
        default:
            NSLog(@"Error");
            break;
    }
}

- (void)swipeDown:(UIGestureRecognizer *)swipe
{
    [self initContainerAnimation];
    
    CGRect frame = container.frame;
    switch (floor) {
        case (1):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.13;
            container.frame = frame;
            floor = 0;
            self.myMapView.userInteractionEnabled = true;
            break;
        case (2):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.13;
            container.frame = frame;
            floor = 1;
            self.myMapView.userInteractionEnabled = false;
            break;
        case (3):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.3;
            container.frame = frame;
            floor = 1;
            self.myMapView.userInteractionEnabled = false;
            break;
        default:
            NSLog(@"Error");
            break;
    }
}

//Listering to delegate events
- (void) map:(MWZMapView*) map didClick:(MWZLatLon*) latlon {
    
}

- (void) map:(MWZMapView*) map didClickOnPlace:(MWZPlace*) place {
    [myMapView access: @"h14aEHT8O6OvxoNo"];
    [myMapView centerOnCoordinates:@48.82594334079911 longitude:@2.259484827518463 floor:@5 zoom:@19];
}

- (void) map:(MWZMapView*) map didClickOnVenue:(MWZVenue*) venue {
   
}

- (void) map:(MWZMapView*) map didClickOnMarker:(MWZPosition *)marker {
  
}

- (void) map:(MWZMapView*) map didChangeFloor:(NSNumber*) floor {

}

- (void) map:(MWZMapView*) map didChangeFloors:(NSArray*) floors {

}

- (void) map:(MWZMapView *)map didMove:(MWZLatLon *)center {

}

- (void) map:(MWZMapView*) map didFailWithError: (NSError *)error {
   
}

- (void) map:(MWZMapView*) map didChangeFollowUserMode:(BOOL)followUserMode {
}

- (void) map:(MWZMapView*) map didChangeUserPosition:(MWZMeasurement *)userPosition {
}

- (void )map:(MWZMapView*) map didChangeZoom: (NSNumber*) zoom {
}

- (void )map:(MWZMapView*) map didClickLong: (MWZLatLon*) latlon {
}

- (void) map:(MWZMapView*) map didStartDirections: (NSString*) infos {
}

- (void )map:(MWZMapView*) map didStopDirections: (NSString*) infos {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end