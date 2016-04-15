//
//  MapViewController.m
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "MapViewController.h"
#import "NavBarInstance.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize container;
@synthesize myMapView;
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.asynchtaskRunning = false;
    
    // INIT PARAMS FOR DECISION
    self.realTime    = true;
    self.filtersON   = false;
    
    [self initMapWize];
    [self initContainerSwipeGesture];
    
    // FOR SENSOR UPDATE
    self.finishedSensorUpdate = true;
    self.manager = [[Manager alloc]init];
    self.manager.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated {
    self.stepForSwipe = 1;
    [self shouldStartAsynchtaskSensors];
    [self getMapStates];
    [self updateNavBar];
    
    if(self.filterViewController == nil){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        self.filterViewController = [storyboard instantiateViewControllerWithIdentifier:@"filterViewController"];
        self.filterViewController.delegate = self;
        [self addChildViewController:self.filterViewController];
        self.filterViewController.view.frame = CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height);
        [self.container addSubview:self.filterViewController.view];
        [self.filterViewController didMoveToParentViewController:self];
    }
}

- (void) updateNavBar {
    
    
    UIImage *right = [UIImage imageNamed:@"WSMImagesBtnHelp"];
    
    NavBarInstance *custom = [NavBarInstance sharedInstance];
    [custom styleNavBar:self setTitle:@"SÉLECTIONNER UN ESPACE" setLeftButton:nil setRightButton:right];
    
}

- (void)launchLeft {
    NSLog(@"Erase");
}

- (void)launchRight {
    NSLog(@"Help");
}

- (void) getMapStates {
    [self updateMap];
}

// FILTER DELEGATE

- (void)didChangeCarousel:(NSArray*)schedulesArray position:(NSInteger)position realTime:(BOOL)realTime {
    self.realTime   = realTime;
    self.timeIndex1 = [schedulesArray objectAtIndex:position];
    self.timeIndex2 = [schedulesArray objectAtIndex:position+1];
    self.timeIndex3 = [schedulesArray objectAtIndex:position+2];
    [self decide:[NSString stringWithFormat:@"time is : %@ realTime ? : %d", self.timeIndex1,self.realTime]];
}

- (void) didChangeSlider:(int)sliderValue {
    self.sliderValue = sliderValue;
    [self decide:[NSString stringWithFormat:@"slider : %d ", self.sliderValue]];
}

- (void) decide:(NSString*)keyword{
    
    NSPredicate *predicateAppDsi = [NSPredicate predicateWithFormat:@"type != %@", @"free"];
    NSArray *roomsAppDsi = [DAO getObjects:@"Room" withPredicate:predicateAppDsi];
    NSPredicate *predicateFree = [NSPredicate predicateWithFormat:@"type == %@", @"free"];
    NSArray *roomsFree = [DAO getObjects:@"Room" withPredicate:predicateFree];
    
    // If main map view
    switch (self.stepForSwipe) {
        case 0 || 1:
            
            // ROOMS FREE
            for(Room *room in roomsFree){
                if(self.realTime){
                    
                    // SENSOR = 1
                    if([CheckDAO roomHasSensorOn:room]){
                     [room setMapState:@"red"];
                    }
                    // SENSOR = 0
                    else{
                        [room setMapState:@"green_free"];
                    }
                }
            }
            
            // ROOMS APP-DSI
            for(Room *room in roomsAppDsi){
                if(self.realTime){
                    
                    
                    // AVAILABLE ??
                    NSString *reservationType = [CheckDAO checkCurrentReservationType:self.timeIndex1 room:room];
                    if([reservationType isEqualToString:@"dsi"]){
                        [room setMapState:@"red"];
                    }
                    else if([reservationType isEqualToString:@"app"]) {
                        [room setMapState:@"grey"];
                    }
                    else if(reservationType == nil){
                        NSString *nextReservationType = [CheckDAO checkNextReservationType:self.timeIndex2 room:room];
                        if(nextReservationType != nil){
                            [room setMapState:@"green_book_ko"];
                        }
                        else {
                            [room setMapState:@"green_book_ok"];
                        }
                        NSLog(@"room: %@ available : %@",room.name, nextReservationType);
                    }
                    
                }
            }
            
            
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
   
    
    [self updateMap];
}

// MANAGER DELEGATE

- (void)finishCheckWithUpdate:(BOOL)updateNeeded {
    if(updateNeeded){
        [self decide:@"sensors"];
    }
    self.finishedSensorUpdate = true;
}

// HANDLE MAP

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
    }
}

- (void)initMapWize
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
    if(self.filtersON){
        self.filtersON = false;
        [self decide:[NSString stringWithFormat:@"filtersOn ? : %d", self.filtersON]];
        [self.filterViewController initState];
    }
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

- (void) changeTitle {
    NavBarInstance *test = [NavBarInstance sharedInstance];
    [test setNavBarTitle:@"SÉLECTIONNER UN ESPACE"];
}

- (void) changeTitle2 {
    NavBarInstance *test = [NavBarInstance sharedInstance];
    [test setNavBarTitle:@"CHOIX DES CRITÈRES"];
}

- (void)swipeUp:(UIGestureRecognizer *)swipe
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.3];
    
    CGRect frame = container.frame;
    switch (self.stepForSwipe)
    {
        case (1):
            // CAROUSEL -> CAROUSEL + DURATION
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.465;
            [self changeTitle2];
            container.frame = frame;
            self.stepForSwipe = 2;
            break;
            
        case (2):
            // CAROUSEL + DURATION -> FILTERS
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 6.35;
            container.frame = frame;
            self.stepForSwipe = 3;
            self.myMapView.userInteractionEnabled = false;
            [self shouldStopAsynchtaskSensors];
            break;
            
        default:
            break;
    }
    [UIView commitAnimations];
}

- (void)swipeDown:(UIGestureRecognizer *)swipe
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.3];
    
    CGRect frame = container.frame;
    switch (self.stepForSwipe) {
        case (2):
            // CAROUSEL + DURATION -> CAROUSEL
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.22;
            [self changeTitle];
            container.frame = frame;
            self.stepForSwipe = 1;
            break;
            
        case (3):
            // FILTERS -> CAROUSEL + DURATION
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.465;
            container.frame = frame;
            self.stepForSwipe = 2;
            self.myMapView.userInteractionEnabled = true;
            self.filtersON = [self.filterViewController filtersChanged];
            [self decide:[NSString stringWithFormat:@"filtersOn ? : %d", self.filtersON]];
            [self shouldStartAsynchtaskSensors];
            break;
            
        default:
            break;
    }
    [UIView commitAnimations];
}

// HANDLE SENSORS

- (void) shouldStartAsynchtaskSensors {
        if(!self.asynchtaskRunning){
            NSDate  *delay = [NSDate dateWithTimeIntervalSinceNow: 0.0];
            self.timer = [[NSTimer alloc] initWithFireDate: delay
                                             interval: 60
                                               target: self
                                             selector:@selector(checkSensors:)
                                             userInfo:nil repeats:YES];
    
            NSRunLoop *runner = [NSRunLoop currentRunLoop];
            [runner addTimer:self.timer forMode: NSDefaultRunLoopMode];
            self.asynchtaskRunning = true;
        }
}

- (void) shouldStopAsynchtaskSensors {
    if(self.asynchtaskRunning){
        [self.timer invalidate];
        self.timer = nil;
        self.asynchtaskRunning = false;
    }
}

- (void)checkSensors:timer {
    if(self.finishedSensorUpdate){
        NSLog(@"Execute WebService");
        [self.manager checkSensors:[ModelDAO getAllSensorsId]];
        self.finishedSensorUpdate = false;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
