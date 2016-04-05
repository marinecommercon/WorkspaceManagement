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
    int stepForSwipe;
}

@synthesize container;
@synthesize myMapView;
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    stepForSwipe = 1;
    
    [self initContainerSwipeGesture];
    [self initMap];
}

- (void) updateMap:timer {
    
    UIColor *redColor   = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:30/255.0 alpha:0.7];
    UIColor *greenColor = [UIColor colorWithRed:14/255.0 green:238/255.0 blue:55/255.0 alpha:0.7];
    UIColor *blueColor  = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:231/255.0 alpha:0.7];
    
    MWZPlaceStyle* redStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:redColor strokeWidth:@3 fillColor:redColor labelBackgroundColor:nil markerUrl:nil];
    MWZPlaceStyle* greenStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:greenColor strokeWidth:@3 fillColor:greenColor labelBackgroundColor:nil markerUrl:nil];
    MWZPlaceStyle* blueStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:blueColor strokeWidth:@3 fillColor:blueColor labelBackgroundColor:nil markerUrl:nil];
    
    NSArray *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
    for(Room *room in listRooms){
        CGFloat moduloResult = (float)((int)timer % 2);
        [self.myMapView setStyle:greenStyle forPlaceById:room.idMapwize];
    }
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
    
    [myMapView access: @"h14aEHT8O6OvxoNo"];
    [myMapView centerOnCoordinates:@48.82594334079911 longitude:@2.259484827518463 floor:@5 zoom:@19];
}

- (void) map:(MWZMapView*) map didClick:(MWZLatLon*) latlon {
        [myMapView access: @"h14aEHT8O6OvxoNo"];
        [myMapView centerOnCoordinates:@48.82594334079911 longitude:@2.259484827518463 floor:@5 zoom:@19];
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
    switch (stepForSwipe)
    {
        case (0):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.13;
            container.frame = frame;
            stepForSwipe = 1;
            self.myMapView.userInteractionEnabled = true;
            break;
        case (1):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.3;
            container.frame = frame;
            stepForSwipe = 2;
            self.myMapView.userInteractionEnabled = false;
            break;
        case (2):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 3;
            container.frame = frame;
            stepForSwipe = 3;
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
<<<<<<< HEAD
=======
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.3];
    
>>>>>>> 5b44e6bcdf45428ddc78370a9fa7159150a8b498
    CGRect frame = container.frame;
    switch (stepForSwipe) {
        case (1):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.13;
            container.frame = frame;
            stepForSwipe = 0;
            self.myMapView.userInteractionEnabled = true;
            break;
        case (2):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.13;
            container.frame = frame;
<<<<<<< HEAD
            stepForSwipe = 1;
            self.myMapView.userInteractionEnabled = false;
=======
            floor = 1;
            self.myMapView.userInteractionEnabled = true;
>>>>>>> 5b44e6bcdf45428ddc78370a9fa7159150a8b498
            break;
        case (3):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.3;
            container.frame = frame;
            stepForSwipe = 1;
            self.myMapView.userInteractionEnabled = false;
            break;
        default:
            NSLog(@"Error");
            break;
    }
    [UIView commitAnimations];
}



- (void) map:(MWZMapView*) map didClickOnPlace:(MWZPlace*) place {

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
