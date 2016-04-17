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

@synthesize container;
@synthesize myMapView;
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.asynchtaskRunning = false;
    
    // INIT PARAMS FOR DECISION
    self.realTime     = true;
    self.filtersON    = false;
    self.sliderValue  = 1;
    self.stepForSwipe = 1;
    
    [self initMapWize];
    [self initContainerSwipeGesture];
    
    // FOR SENSOR UPDATE
    self.finishedSensorUpdate = true;
    self.manager = [[Manager alloc]init];
    self.manager.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated {

    [self initNavbar];
    self.stepForSwipe = 1;
    
    if(self.filterViewController == nil){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        self.filterViewController = [storyboard instantiateViewControllerWithIdentifier:@"filterViewController"];
        self.filterViewController.delegate = self;
        [self addChildViewController:self.filterViewController];
        self.filterViewController.view.frame = CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height);
        [self.container addSubview:self.filterViewController.view];
        [self.filterViewController didMoveToParentViewController:self];
    }
    
    [self shouldStartAsynchtaskSensors];
    [self getMapStates];
    [self decide];
}

- (void) viewWillDisappear:(BOOL)animated {
    self.stepForSwipe = 1;
}

- (void) getMapStates {
    [self updateMap];
}

// FILTER DELEGATE

- (void)didChangeCarousel:(NSArray*)schedulesArray position:(NSInteger)position realTime:(BOOL)realTime {
    self.realTime   = realTime;
    
    switch ([schedulesArray count]-position) {
        case 1:
            self.currentTime = [schedulesArray objectAtIndex:position];
            break;
        case 2:
            self.currentTime = [schedulesArray objectAtIndex:position];
            self.nextTime = [schedulesArray objectAtIndex:position+1];
            break;
            
        default:
            self.currentTime = [schedulesArray objectAtIndex:position];
            self.nextTime = [schedulesArray objectAtIndex:position+1];
            break;
    }
    
    [self decide];
}

- (void) didChangeSlider:(int)sliderValue {
    self.sliderValue = sliderValue;
    [self decide];
}

- (void) decide {
    
    // INIT ROOMS
    NSPredicate *predicateAppDsi = [NSPredicate predicateWithFormat:@"type != %@", @"free"];
    self.roomsAppDsi = [DAO getObjects:@"Room" withPredicate:predicateAppDsi];
    NSPredicate *predicateFree = [NSPredicate predicateWithFormat:@"type == %@", @"free"];
    self.roomsFree = [DAO getObjects:@"Room" withPredicate:predicateFree];
    
    if(self.filtersON){
        [self.navbar.buttonLeft setHidden:false];
        self.roomsAppDsi = self.filterViewController.roomsAppDsiFiltered;
        self.roomsFree   = self.filterViewController.roomsFreeFiltered;
        for(Room *room in self.filterViewController.roomsNotCorresponding){
            [room setMapState:@"grey"];
        }
    }
    
    // If main map view
    switch (self.stepForSwipe) {
        case 0 || 1:
            // ROOMS FREE
            for(Room *room in self.roomsFree){
                
                // ROOMS FREE + REALTIME
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
                // ROOMS FREE + FUTUR
                else if(!self.realTime){
                    [room setMapState:@"grey"];
                }
            }
            
            // ROOMS APP-DSI
            for(Room *room in self.roomsAppDsi){
                
                // ROOMS APP-DSI + REALTIME
                if(self.realTime){
                    
                    NSString *reservationType;
                    if(!self.filtersON){
                        // Current reservation ?
                        reservationType = [CheckDAO checkCurrentReservationType:self.currentTime room:room];
                    }
                    else {
                        //Keep the duration if filters are on
                        reservationType = [CheckDAO checkCurrentReservationType:self.currentTime duration:self.sliderValue room:room];
                    }
                   
                    // Current reservation = dsi and filters off
                    if([reservationType isEqualToString:@"dsi"] && !self.filtersON){
                        [room setMapState:@"red"];
                    }
                    // Current reservation = dsi and filters on
                    if([reservationType isEqualToString:@"dsi"] && self.filtersON){
                        [room setMapState:@"grey"];
                    }
                    // Current reservation = app-initial and filters off
                    else if([reservationType isEqualToString:@"app"] && !self.filtersON) {
                        [room setMapState:@"blue"];
                    }
                    // Current reservation = app-confirmed and filters off
                    else if([reservationType isEqualToString:@"app"] && !self.filtersON) {
                        [room setMapState:@"red"];
                    }
                    // Current reservation = app and filters on
                    else if([reservationType isEqualToString:@"app"] && self.filtersON) {
                        [room setMapState:@"grey"];
                    }
                    // Current reservation is impossible because too late
                    else if([reservationType isEqualToString:@"impossible"]) {
                        [room setMapState:@"green_book_ko"];
                    }
                    // No current reservation
                    else if([reservationType isEqualToString:@"noreservation"]){
                        
                        // No current reservation and next reservation ?
                        NSString *nextReservationType = [CheckDAO checkNextReservationType:self.nextTime room:room];
                        
                        // No current reservation and next reservation = dsi
                        if([nextReservationType isEqualToString:@"dsi"]){
                            [room setMapState:@"green_book_ko"];
                        }
                        // No current reservation and next reservation = app-initial
                        else if([nextReservationType isEqualToString:@"app-initial"]) {
                            [room setMapState:@"blue"];
                        }
                        // No current reservation and next reservation = app-confirmed
                        else if([nextReservationType isEqualToString:@"app-confirmed"]) {
                            [room setMapState:@"red"];
                        }
                        // No current reservation and next reservation is impossible because too late
                        else if([nextReservationType isEqualToString:@"impossible"]) {
                            [room setMapState:@"green_book_ko"];
                        }
                        // No current reservation and no next reservation
                        else if([nextReservationType isEqualToString:@"noreservation"]) {
                            [room setMapState:@"green_book_ok"];
                        }
                    }
                }
                
                // ROOMS APP-DSI + FUTURE
                else if(!self.realTime){
                    
                    // Current reservation ?
                    NSString *reservationType = [CheckDAO checkCurrentReservationType:self.currentTime room:room];
                    
                    // Current reservation = dsi and filters off
                    if([reservationType isEqualToString:@"dsi"] && !self.filtersON){
                        [room setMapState:@"red"];
                    }
                    // Current reservation = dsi and filters on
                    if([reservationType isEqualToString:@"dsi"] && self.filtersON){
                        [room setMapState:@"grey"];
                    }
                    // Current reservation = app-initial
                    else if([reservationType isEqualToString:@"app-initial"] && !self.filtersON) {
                        [room setMapState:@"blue"];
                    }
                    // Current reservation = app-confirmed
                    else if([reservationType isEqualToString:@"app-confirmed"] && !self.filtersON) {
                        [room setMapState:@"red"];
                    }
                    // Current reservation = app and filters on
                    if([reservationType isEqualToString:@"app"] && self.filtersON){
                        [room setMapState:@"grey"];
                    }
                    // Current reservation is impossible because too late
                    else if([reservationType isEqualToString:@"impossible"]) {
                        [room setMapState:@"green_book_ko"];
                    }
                    // No current reservation
                    else if([reservationType isEqualToString:@"noreservation"]) {
                        [room setMapState:@"green_book_ok"];
                    }
                }
            }
            break;
            
        case 2:
            // ROOMS FREE
            for(Room *room in self.roomsFree){
                
                // ROOMS FREE + REALTIME
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
                // ROOMS FREE + FUTUR
                else if(!self.realTime){
                    [room setMapState:@"grey"];
                }
            }
            
            // ROOMS APP-DSI
            for(Room *room in self.roomsAppDsi){
                
                // ROOMS APP-DSI + REALTIME
                if(self.realTime){
                    
                    // Current reservation ?
                    NSString *reservationType = [CheckDAO checkCurrentReservationType:self.currentTime duration:self.sliderValue room:room];
                    
                    // Current reservation = dsi and filters off
                    if([reservationType isEqualToString:@"dsi"]  && !self.filtersON){
                        [room setMapState:@"red"];
                    }
                    // Current reservation = dsi and filters on
                    else if([reservationType isEqualToString:@"dsi"] && self.filtersON) {
                        [room setMapState:@"grey"];
                    }
                    // Current reservation = app-initial and filters off
                    else if([reservationType isEqualToString:@"app-initial"] && !self.filtersON) {
                        [room setMapState:@"blue"];
                    }
                    // Current reservation = app-confirmed and filters off
                    else if([reservationType isEqualToString:@"app-confirmed"] && !self.filtersON) {
                        [room setMapState:@"red"];
                    }
                    // Current reservation = app and filters on
                    else if([reservationType isEqualToString:@"app"] && self.filtersON) {
                        [room setMapState:@"grey"];
                    }
                    // Current reservation is impossible because too late
                    else if([reservationType isEqualToString:@"impossible"]) {
                        [room setMapState:@"green_book_ko"];
                    }
                    // No current reservation
                    else if([reservationType isEqualToString:@"noreservation"]){
                        [room setMapState:@"green_book_ok"];
                    }
                }
                
                // ROOMS APP-DSI + FUTURE
                else if(!self.realTime){
                    
                    // Current reservation ?
                    NSString *reservationType = [CheckDAO checkCurrentReservationType:self.currentTime duration:self.sliderValue room:room];
                    
                    // Current reservation = dsi and filters off
                    if([reservationType isEqualToString:@"dsi"] && !self.filtersON){
                        [room setMapState:@"red"];
                    }
                    // Current reservation = dsi and filters on
                    else if([reservationType isEqualToString:@"dsi"] && self.filtersON) {
                        [room setMapState:@"grey"];
                    }
                    // Current reservation = app-intial
                    else if([reservationType isEqualToString:@"app-initial"]) {
                        [room setMapState:@"blue"];
                    }
                    // Current reservation = app-confirmed
                    else if([reservationType isEqualToString:@"app-confirmed"]) {
                        [room setMapState:@"red"];
                    }
                    // Current reservation is impossible because too late
                    else if([reservationType isEqualToString:@"impossible"]) {
                        [room setMapState:@"green_book_ko"];
                    }
                    // No current reservation
                    else if([reservationType isEqualToString:@"noreservation"]) {
                        [room setMapState:@"green_book_ok"];
                    }
                }
            }
            break;
            
        default:
            break;
    }
    
    [self updateMap];
}

// POPUP DELEGATE

-(void) didClickOnReservation:(Room*)room{
    [self.popupDetailViewController dismissViewControllerAnimated:YES completion:nil];
    ReservationViewController *reservation = [self.storyboard instantiateViewControllerWithIdentifier:@"ReservationViewController"];
    
    NSString *minutes = [self.currentTime substringWithRange:NSMakeRange(3,2)];
    if(self.realTime && ![minutes isEqualToString:@"00"] && ![minutes isEqualToString:@"30"]){
        reservation.beginTime = self.nextTime;
    }
    else {
        reservation.beginTime = self.currentTime;
    }
    
    reservation.room = room;
    [self.navigationController pushViewController:reservation animated:YES];
}

// MANAGER DELEGATE

- (void)finishCheckWithUpdate:(BOOL)updateNeeded {
    if(updateNeeded){
        [self decide];
    }
    self.finishedSensorUpdate = true;
}

// HANDLE MAP

- (void) updateMap {
    MWZPlaceStyle* redStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:[UIColor bnpRed] strokeWidth:@1 fillColor:[UIColor bnpRedLight] labelBackgroundColor:nil markerUrl:nil];
    
    MWZPlaceStyle* greyStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:[UIColor bnpGrey] strokeWidth:@1 fillColor:[UIColor bnpGrey] labelBackgroundColor:nil markerUrl:nil];
    
    MWZPlaceStyle* blueStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:[UIColor bnpBlue] strokeWidth:@1 fillColor:[UIColor bnpBlueLight] labelBackgroundColor:nil markerUrl:nil];
    
    MWZPlaceStyle* greenStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:[UIColor bnpGreen] strokeWidth:@1 fillColor:[UIColor bnpGreenLight] labelBackgroundColor:nil markerUrl:nil];
    
    MWZPlaceStyle* testStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:[UIColor bnpPink] strokeWidth:@1 fillColor:[UIColor bnpPink] labelBackgroundColor:nil markerUrl:nil];
    
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
        else if([room.mapState isEqualToString:@"test"]){
            [self.myMapView setStyle:testStyle forPlaceById:room.idMapwize];
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
    
    [myMapView access: @"h14aEHT8O6OvxoNo"];
    [myMapView centerOnCoordinates:@48.82576 longitude:@2.25957 floor:@5 zoom:@21];
}

- (void)map:(MWZMapView*) map didClick:(MWZLatLon*) latlon {
}

- (void) map:(MWZMapView*) map didClickOnPlace:(MWZPlace*) place {
    Room *room = [ModelDAO getRoomById:place.identifier];
    
    // Only if room is not grey
    if(![room.mapState isEqualToString:@"grey"]){
        self.popupDetailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopupDetailController"];
        self.popupDetailViewController.delegate = self;
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
    switch (self.stepForSwipe)
    {
        case (1):
            // CAROUSEL -> CAROUSEL + DURATION
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.465;
            container.frame = frame;
            self.stepForSwipe = 2;
            self.filterViewController.stepForSwipe = 2;
            [self decide];
            break;
            
        case (2):
            // CAROUSEL + DURATION -> FILTERS
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 6.35;
            container.frame = frame;
            self.stepForSwipe = 3;
            self.filterViewController.stepForSwipe = 3;
            self.myMapView.userInteractionEnabled = false;
            [self shouldStopAsynchtaskSensors];
            [self.navbar setNavBarTitle:@"CHOIX DES CRITÈRES"];
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
            container.frame = frame;
            self.stepForSwipe = 1;
            self.filterViewController.stepForSwipe = 1;
            [self decide];
            break;
            
        case (3):
            // FILTERS -> CAROUSEL + DURATION
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.465;
            container.frame = frame;
            self.stepForSwipe = 2;
            self.filterViewController.stepForSwipe = 2;
            self.myMapView.userInteractionEnabled = true;
            self.filtersON = [self.filterViewController filtersChanged];
            [self shouldStartAsynchtaskSensors];
            [self decide];
            [self.navbar setNavBarTitle:@"SÉLECTIONNER UN ESPACE"];
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
                                              interval: 15
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

// HANDLE NAVBAR

- (void)initNavbar {
    UIImage *right = [UIImage imageNamed:@"WSMImagesBtnHelp"];
    UIImage *left = [UIImage imageNamed:@"WSMImagesBtnReload"];
    self.navbar = [NavBarInstance sharedInstance];
    [self.navbar styleNavBar:self setTitle:@"SÉLECTIONNER UN ESPACE" setLeftButton:left setRightButton:right];
}

- (void)navbarLeftButton {
    self.filtersON = false;
    [self.navbar.buttonLeft setHidden:true];
    [self.filterViewController initState];
    [self decide];
}

- (void)navbarRightButton {
    NSLog(@"Right");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end




