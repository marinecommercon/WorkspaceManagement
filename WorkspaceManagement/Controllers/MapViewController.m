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
    BOOL finished;
    NSTimer *timer;
    BOOL asynchtaskRunning;
}

@synthesize container;
@synthesize myMapView;
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    stepForSwipe      = 1;
    asynchtaskRunning = false;
    
    [self initContainerSwipeGesture];
    [self initMap];
    
    // FOR SENSOR UPDATE
    finished   = true;
    self.manager = [[Manager alloc]init];
    self.manager.delegate = self;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.filterViewController = [storyboard instantiateViewControllerWithIdentifier:@"filterViewController"];
    self.filterViewController.delegate = self;
    [self addChildViewController:self.filterViewController];
    self.filterViewController.view.frame = CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height);
    [self.container addSubview:self.filterViewController.view];
    [self.filterViewController didMoveToParentViewController:self];

}

- (void) viewDidAppear:(BOOL)animated {
    stepForSwipe      = 1;
    [self shouldStartAsynchtask];
    [self updateMap];
}

- (void) shouldStopAsynchtask {
    if(asynchtaskRunning){
        [timer invalidate];
        timer = nil;
        asynchtaskRunning = false;
    }
}

- (void) shouldStartAsynchtask {
//    if(!asynchtaskRunning){
//        NSDate  *delay = [NSDate dateWithTimeIntervalSinceNow: 0.0];
//        timer = [[NSTimer alloc] initWithFireDate: delay
//                                         interval: 60
//                                           target: self
//                                         selector:@selector(checkSensors:)
//                                         userInfo:nil repeats:YES];
//        
//        NSRunLoop *runner = [NSRunLoop currentRunLoop];
//        [runner addTimer:timer forMode: NSDefaultRunLoopMode];
//        asynchtaskRunning = true;
//    }
}

- (void)checkSensors:timer {
    if(finished){
        NSLog(@"Execute WebService");
        [self.manager checkSensors:[ModelDAO getAllSensorsId]];
        finished = false;
    }
}

- (void)finishCheckWithUpdate:(BOOL)updateNeeded {
    if(updateNeeded){
        // Do something when sensors are updated
    }
    finished = true;
}



- (void) updateMap {
    MWZPlaceStyle* redStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:[UIColor bnpRed] strokeWidth:@1 fillColor:[UIColor bnpRedLight] labelBackgroundColor:nil markerUrl:nil];
    
    MWZPlaceStyle* greyStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:[UIColor bnpGrey] strokeWidth:@1 fillColor:[UIColor bnpGrey] labelBackgroundColor:nil markerUrl:nil];
    
    MWZPlaceStyle* blueStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:[UIColor bnpBlue] strokeWidth:@1 fillColor:[UIColor bnpBlueLight] labelBackgroundColor:nil markerUrl:nil];
    
    MWZPlaceStyle* greenStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:[UIColor bnpGreen] strokeWidth:@1 fillColor:[UIColor bnpGreenLight] labelBackgroundColor:nil markerUrl:nil];
    
    NSArray *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
    for(Room *room in listRooms){
   
        if([room.mapState isEqualToString:@"grey"]){
            [self.myMapView setStyle:greyStyle forPlaceById:room.idMapwize];
        }
        else if([room.mapState isEqualToString:@"green_free"] || [room.mapState isEqualToString:@"green_book_ok"] || [room.mapState isEqualToString:@"green_book_ko"]){
            [self.myMapView setStyle:greenStyle forPlaceById:room.idMapwize];
        }
        else if([room.mapState isEqualToString:@"blue"]){
            [self.myMapView setStyle:blueStyle forPlaceById:room.idMapwize];
        }
        else if([room.mapState isEqualToString:@"red"]){
            [self.myMapView setStyle:redStyle forPlaceById:room.idMapwize];
        }
                
//        if([CheckDAO roomHasSensorOn:room.idMapwize]){
//            [self.myMapView setStyle:redStyle forPlaceById:room.idMapwize];
//        }
//        else {
//            [self.myMapView setStyle:greenStyle forPlaceById:room.idMapwize];
//        }
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

- (void)map:(MWZMapView*) map didClick:(MWZLatLon*) latlon {

}

- (void) map:(MWZMapView*) map didClickOnPlace:(MWZPlace*) place {
    Room *room = [ModelDAO getRoomById:place.identifier];
    
    // Only if room is not grey
    if(![room.mapState isEqualToString:@"grey"]){
        self.popupDetailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopupDetailController"];
        [self.popupDetailViewController setInfos:room];
        
        CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
        popup.destinationBounds = CGRectMake(0, 0, self.view.frame.size.width / 1.19, self.view.frame.size.height / 1.2);
        popup.presentedController = self.popupDetailViewController;
        popup.presentingController = self;
        popup.dismissableByTouchingBackground = YES;
        popup.backgroundBlurRadius = 0;
        popup.backgroundViewAlpha = 0.7;
        popup.backgroundViewColor = [UIColor blackColor];
        
        [self presentViewController:self.popupDetailViewController animated:YES completion:nil];
    }
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

// HANDLE SWIPE GESTURE

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
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.133;
            container.frame = frame;
            stepForSwipe = 1;
            [self shouldStartAsynchtask];
            break;
            
        case (1):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.3;
            container.frame = frame;
            stepForSwipe = 2;
            [self shouldStartAsynchtask];
            break;
            
        case (2):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 3;
            container.frame = frame;
            stepForSwipe = 3;
            self.myMapView.userInteractionEnabled = false;
            [self shouldStopAsynchtask];
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
    switch (stepForSwipe) {
        case (1):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.133;
            container.frame = frame;
            stepForSwipe = 0;
            [self shouldStartAsynchtask];
            break;
            
        case (2):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.133;
            container.frame = frame;
            stepForSwipe = 1;
            [self shouldStartAsynchtask];
            break;
            
        case (3):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.3;
            container.frame = frame;
            stepForSwipe = 1;
            self.myMapView.userInteractionEnabled = true;
            [self shouldStartAsynchtask];
            break;
            
        default:
            NSLog(@"Error");
            break;
    }
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
