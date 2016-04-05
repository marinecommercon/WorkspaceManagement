//
//  MapViewController.m
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
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

- (void)swipeUp:(UIGestureRecognizer *)swipe
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.3];
    
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
    [UIView commitAnimations];
}

- (void)swipeDown:(UIGestureRecognizer *)swipe
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.3];
    
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
            self.myMapView.userInteractionEnabled = true;
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
    [UIView commitAnimations];
}

//Listering to delegate events
- (void) map:(MWZMapView*) map didClick:(MWZLatLon*) latlon {
    
}

- (void) map:(MWZMapView*) map didClickOnPlace:(MWZPlace*) place {
    [myMapView access: @"h14aEHT8O6OvxoNo"];
    [myMapView centerOnCoordinates:@48.82594334079911 longitude:@2.259484827518463 floor:@5 zoom:@19];
    
    UIViewController *presentingController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopupDetailController"];
    
    CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
    popup.destinationBounds = CGRectMake(0, 0, self.view.frame.size.width / 1.19, self.view.frame.size.height / 1.2);
    popup.presentedController = presentingController;
    popup.presentingController = self;
    popup.dismissableByTouchingBackground = YES;
    popup.backgroundBlurRadius = 0;
    popup.backgroundViewAlpha = 0.7;
    popup.backgroundViewColor = [UIColor blackColor];
    [self presentViewController:presentingController animated:YES completion:nil];
    
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
