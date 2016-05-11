//
//  MapViewController.m
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "MapViewController.h"
#import "NavBarInstance.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize container;
@synthesize myMapView;
@synthesize locationManager;
@synthesize popupDetailViewController;
@dynamic reservationBeginTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.asynchtaskRunning = false;
    
    // INIT PARAMS FOR DECISION
    self.realTime     = YES;
    self.filtersON    = NO;
    self.sliderValue  = 1;
    self.stepForSwipe = 1;
    
    [self initMapWize];
    [self initContainerSwipeGesture];
    
    // FOR SENSOR UPDATE
    self.finishedSensorUpdate = YES;
    self.manager = [[Manager alloc] init];
    self.manager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getMapStates];
    [self updateNavBar];
    
    [self performSelector:@selector(initContainerSwipeGesture) withObject:nil afterDelay:1.0];
    // Because of small bug
    // [self initContainerSwipeGesture];
   
    self.stepForSwipe = 1;
    
    if( !self.filterViewController )
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        self.filterViewController = [storyboard instantiateViewControllerWithIdentifier:@"filterViewController"];
        self.filterViewController.delegate = self;
        [self addChildViewController:self.filterViewController];
        self.filterViewController.view.frame = CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height);
        [self.container addSubview:self.filterViewController.view];
        [self.filterViewController didMoveToParentViewController:self];
    }
    
    [self shouldStartAsynchtaskSensors];
    [self decide];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.stepForSwipe = 1;
}

- (void)updateNavBar
{
//    UIImage *left  = [UIImage imageNamed:@"WSMImagesNavbarRecommencer"];
//    UIImage *right = [UIImage imageNamed:@"WSMImagesNavbarHelp"];
//    
//    NavBarInstance *custom = [NavBarInstance sharedInstance];
//    [custom styleNavBar:self setTitle:@"SÉLECTIONNER UN ESPACE" setLeftButton:left setRightButton:right];

    [[NavBarInstance sharedInstance] setTitle:@"SÉLECTIONNER UN ESPACE"
                              leftButtonImage:[UIImage imageNamed:@"WSMImagesNavbarRecommencer"]
                             rightButtonImage:[UIImage imageNamed:@"WSMImagesNavbarHelp"]
                            forViewController:self];
}

- (void)launchLeft
{
    NSLog(@"Erase");
    [self.filterViewController initState];
    self.filtersON = self.filterViewController.filtersChanged;
    [self decide];
}

- (void)launchRight
{
    NSString *helpImageName = nil;
    
    switch( self.stepForSwipe )
    {
        case 1 : helpImageName = @"TutoSelectionEspace"; break;
        case 2 : 
        case 3 : helpImageName = @"TutoChoixCriteres"; break;
    }
    
    if( !helpImageName )
        return;
    
    UIButton *helpView = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpView setImage:[UIImage imageNamed:helpImageName] forState:UIControlStateNormal];
    helpView.adjustsImageWhenHighlighted = NO;
    [helpView sizeToFit];
    [helpView addTarget:self action:@selector(dismissHelp:) forControlEvents:UIControlEventTouchUpInside];
//    helpView.alpha = 0.25;
    [((AppDelegate *)UIApplication.sharedApplication.delegate).window addSubview:helpView];
//    [self.view addSubview:helpView];
}

- (void)dismissHelp:(UIButton *)sender
{
    [sender removeFromSuperview];
}

- (void)getMapStates
{
    [self updateMap];
}

// FILTER DELEGATE

- (void)didChangeCarousel:(NSArray *)schedulesArray position:(NSInteger)position realTime:(BOOL)realTime
{
    self.realTime   = realTime;
    
    switch ( schedulesArray.count - position )
    {
        case 1:
            self.currentTime = schedulesArray[position];
            break;
    
        default:
            self.currentTime = schedulesArray[position];
            self.nextTime    = schedulesArray[position+1];
            break;
    }
    
    [self decide];
}

- (void)didChangeSlider:(int)sliderValue
{
    self.sliderValue = sliderValue;
    [self decide];
}

- (void)decide
{
    // INIT ROOMS
    NSPredicate *predicateAppDsi = [NSPredicate predicateWithFormat:@"type != %@", kReservationTypeFree];
    self.roomsAppDsi = [DAO getObjects:kDAORoomEntity withPredicate:predicateAppDsi];
    
    NSPredicate *predicateFree = [NSPredicate predicateWithFormat:@"type == %@", kReservationTypeFree];
    self.roomsFree = [DAO getObjects:kDAORoomEntity withPredicate:predicateFree];
    
    if( self.filtersON )
    {
//        self.navbar.buttonLeft.hidden = NO;
        self.roomsAppDsi = self.filterViewController.roomsAppDsiFiltered;
        self.roomsFree   = self.filterViewController.roomsFreeFiltered;
        for(Room *room in self.filterViewController.roomsNotCorresponding)
            room.mapState = kDAORoomMapStateGrey;
    }

    switch( self.stepForSwipe )
    {
        case 0 || 1:
            // ROOMS FREE
            for(Room *room in self.roomsFree)
            {
                if(self.realTime) // ROOMS FREE + REALTIME
                    [self decideSensors:room];
                else // ROOMS FREE + FUTUR
                    [room setMapState:kDAORoomMapStateGrey];
            }
            
            // ROOMS APP-DSI
            for(Room *room in self.roomsAppDsi)
            {
                if(self.realTime) // ROOMS APP-DSI + REALTIME
                {
                    NSString *reservationType;
                    
                    if(self.filtersON) // ROOMS APP-DSI + REALTIME + FILTERS
                    {
                        reservationType = [CheckDAO checkCurrentReservationType:self.currentTime room:room];
                        
                        if( ![reservationType isEqualToString:kReservationTypeNoReservation] ) // CURRENT RESERVATION
                            room.mapState = kDAORoomMapStateGrey;
                        else // NO RESERVATION
                        {
                            NSString *nextReservationType = [CheckDAO checkReservationType:self.nextTime room:room];
                            
                            if( [nextReservationType isEqualToString:kReservationTypeNoReservation] ) // NO NEXT
                                room.mapState = kDAORoomMapStateGreenBook_OK;
                            else // NEXT
                                room.mapState = kDAORoomMapStateGrey;
                        }
                    }
                    else // ROOMS APP-DSI + REALTIME + NO FILTERS
                    {
                        reservationType = [CheckDAO checkCurrentReservationType:self.currentTime room:room];
                        
                        
                        if( [reservationType isEqualToString:kReservationTypeDsi] ) // CURRENT IS DSI
                            room.mapState = kDAORoomMapStateBlueRed;
                        else if([reservationType isEqualToString:kReservationTypeAppInitial]) // CURRENT IS APP-INITIAL
                            room.mapState = kDAORoomMapStateBlue;
                        else if([reservationType isEqualToString:kReservationTypeAppConfirmed]) // CURRENT IS APP-CONFIRMED
                            room.mapState = kDAORoomMapStateBlueRed;
                        else if([reservationType isEqualToString:kReservationTypeImpossible]) // CURRENT IS IMPOSSIBLE (too late)
                            room.mapState = kDAORoomMapStateGreenBook_KO;
                        else if([reservationType isEqualToString:kReservationTypeNoReservation]) // NO RESERVATION
                        {
                            NSString *nextReservationType = [CheckDAO checkReservationType:self.nextTime room:room];
                            
                            if( [nextReservationType isEqualToString:kReservationTypeNoReservation] ) // NO NEXT
                                room.mapState = kDAORoomMapStateGreenBook_OK;
                            else // NEXT
                                room.mapState = kDAORoomMapStateGreenBook_KO;
                        }
                    }
                }
                else if(!self.realTime) // ROOMS APP-DSI + FUTURE
                {
                    NSString *reservationType = [CheckDAO checkCurrentReservationType:self.currentTime room:room];
                    [self decideCurrentType:reservationType room:room];
                }
            }
            break;
            
        case 2:
            
            for( Room *room in self.roomsFree ) // ROOMS FREE
            {
                if(self.realTime) // ROOMS FREE + REALTIME
                    [self decideSensors:room];
                else // ROOMS FREE + FUTUR
                    room.mapState = kDAORoomMapStateGrey;
            }
            
            for(Room *room in self.roomsAppDsi)// ROOMS APP-DSI
            {
                
                if(self.realTime) // ROOMS APP-DSI + REALTIME
                {
                    // Take next time on carousel + duration
                    NSString *reservationType = [CheckDAO checkReservationType:self.nextTime duration:self.sliderValue room:room];
                    [self decideCurrentType:reservationType room:room];
                }
                else if(!self.realTime) // ROOMS APP-DSI + FUTURE
                {
                    // Take current time + duration
                    NSString *reservationType = [CheckDAO checkReservationType:self.currentTime duration:self.sliderValue room:room];
                    [self decideCurrentType:reservationType room:room];
                }
            }
            break;
            
        default:
            break;
    }
    
    [self updateMap];
}

- (void)decideSensors:(Room*)room
{
    if( self.filtersON )
    {
        if([CheckDAO roomHasSensorOn:room]) // ROOMS FREE + REALTIME + SENSOR = 1
            room.mapState = kDAORoomMapStateGrey;
        else // ROOMS FREE + REALTIME + SENSOR = 0
            room.mapState = kDAORoomMapStateGreenFree;
    }
    else
    {
        if( [CheckDAO roomHasSensorOn:room] ) // ROOMS FREE + REALTIME + SENSOR = 1
            room.mapState = kDAORoomMapStateBlueRed;
        else // ROOMS FREE + REALTIME + SENSOR = 0
            room.mapState = kDAORoomMapStateGreenFree;
    }
}

- (void)decideCurrentType:(NSString* )type room:(Room *)room
{
    if( self.filtersON ) // ROOMS APP-DSI + REALTIME/FUTURE + FILTERS
    {
        if( [type isEqualToString:kReservationTypeNoReservation] ) // NO RESERVATION FOR NEXT HALF HOUR + DURATION
            room.mapState = kDAORoomMapStateGreenBook_OK;
        else // RESERVATION FOR NEXT HALF HOUR + DURATION
            room.mapState = kDAORoomMapStateGrey;
    }
    else // ROOMS APP-DSI + REALTIME/FUTURE + NO FILTERS
    {
        if( [type isEqualToString:kReservationTypeDsi] ) // IS DSI
            room.mapState = kDAORoomMapStateBlueRed;
        else if( [type isEqualToString:kReservationTypeAppInitial] ) // IS APP-INITIAL
            room.mapState = kDAORoomMapStateBlue;
        // IS APP-CONFIRMED
        else if( [type isEqualToString:kReservationTypeAppConfirmed] )
            room.mapState = kDAORoomMapStateBlueRed;
        else if( [type isEqualToString:kReservationTypeImpossible] ) // IS IMPOSSIBLE (too late)
            room.mapState = kDAORoomMapStateGreenBook_KO;
        else if( [type isEqualToString:kReservationTypeNoReservation] ) // NO RESERVATION
            room.mapState = kDAORoomMapStateGreenBook_OK;
    }
}


// POPUP DELEGATE

- (NSString *)reservationBeginTime
{
    NSString *minutes = [self.currentTime substringWithRange:NSMakeRange(3,2)];
    
    if(self.realTime && ![minutes isEqualToString:kHourMinuteEndingWith00] && ![minutes isEqualToString:kHourMinuteEndingWith30])
        return self.nextTime;
    else
        return self.currentTime;
}

// Not Used ?

//- (void)didClickOnReservation:(Room *)room
//{
//    [self.popupDetailViewController dismissViewControllerAnimated:YES completion:nil];
//    ReservationViewController *reservation = [self.storyboard instantiateViewControllerWithIdentifier:@"ReservationViewController"];
//    
//    NSString *minutes = [self.currentTime substringWithRange:NSMakeRange(3,2)];
//    if(self.realTime && ![minutes isEqualToString:@"00"] && ![minutes isEqualToString:@"30"])
//        reservation.beginTime = self.nextTime;
//    else
//        reservation.beginTime = self.currentTime;
//    
//    reservation.room = room;
//    
//    [self.navigationController pushViewController:reservation animated:YES];
//}

- (void)didClickOnGeoloc:(Room *)room
{
    [self.popupDetailViewController dismissViewControllerAnimated:YES completion:nil];
    FindRoomViewController *findRoom = [self.storyboard instantiateViewControllerWithIdentifier:@"FindRoomViewController"];
    
    [self.navigationController pushViewController:findRoom animated:YES];
}

// MANAGER DELEGATE

- (void)finishCheckWithUpdate:(BOOL)updateNeeded
{
    if( updateNeeded )
        [self decide];

    self.finishedSensorUpdate = true;
}

// HANDLE MAP

- (void)updateMap
{
    MWZPlaceStyle *redStyle   = [[MWZPlaceStyle alloc] initWithStrokeColor:UIColor.bnpRed   strokeWidth:@1 fillColor:UIColor.bnpRedLight   labelBackgroundColor:nil markerUrl:nil];
    MWZPlaceStyle *greyStyle  = [[MWZPlaceStyle alloc] initWithStrokeColor:UIColor.bnpGrey  strokeWidth:@1 fillColor:UIColor.bnpGrey       labelBackgroundColor:nil markerUrl:nil];
    MWZPlaceStyle *blueStyle  = [[MWZPlaceStyle alloc] initWithStrokeColor:UIColor.bnpBlue  strokeWidth:@1 fillColor:UIColor.bnpBlueLight  labelBackgroundColor:nil markerUrl:nil];
    MWZPlaceStyle *greenStyle = [[MWZPlaceStyle alloc] initWithStrokeColor:UIColor.bnpGreen strokeWidth:@1 fillColor:UIColor.bnpGreenLight labelBackgroundColor:nil markerUrl:nil];
    MWZPlaceStyle *testStyle  = [[MWZPlaceStyle alloc] initWithStrokeColor:UIColor.bnpPink  strokeWidth:@1 fillColor:UIColor.bnpPink       labelBackgroundColor:nil markerUrl:nil];
    
    NSDictionary *styleForState = @{kDAORoomMapStateGrey: greyStyle,
                                    kDAORoomMapStateGreenFree: greenStyle,
                                    kDAORoomMapStateGreenBook_OK: greenStyle,
                                    kDAORoomMapStateGreenBook_KO: greenStyle,
                                    kDAORoomMapStateBlue: blueStyle,
                                    kDAORoomMapStateBlueRed: redStyle,
                                    kDAORoomMapStateBlueTest: testStyle };
    
    NSArray *listRooms = [DAO getObjects:kDAORoomEntity withPredicate:nil];
    
    for(Room *room in listRooms)
    {
//        if([room.mapState isEqualToString:@"grey"]){
//            [self.myMapView setStyle:greyStyle forPlaceById:room.idMapwize];
//        }
//        else if([room.mapState isEqualToString:@"green_free"] || [room.mapState isEqualToString:@"green_book_ok"] || [room.mapState isEqualToString:@"green_book_ko"]){
//            [self.myMapView setStyle:greenStyle forPlaceById:room.idMapwize];
//        }
//        else if([room.mapState isEqualToString:@"blue"]){
//            [self.myMapView setStyle:blueStyle forPlaceById:room.idMapwize];
//        }
//        else if([room.mapState isEqualToString:@"red"]){
//            [self.myMapView setStyle:redStyle forPlaceById:room.idMapwize];
//        }
//        else if([room.mapState isEqualToString:@"test"]){
//            [self.myMapView setStyle:testStyle forPlaceById:room.idMapwize];
//        }
        
        [self.myMapView setStyle:styleForState[room.mapState]
                    forPlaceById:room.idMapwize];
    }
}

- (void)initMapWize
{
    locationManager = [[CLLocationManager alloc] init];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status ==kCLAuthorizationStatusAuthorizedWhenInUse)
        NSLog(@"Location Authorization granted");
    else
        NSLog(@"Requesting Location Authorization");
        [locationManager requestWhenInUseAuthorization];
    
    myMapView = (MWZMapView*)[self myMapView];
    MWZMapOptions* options = [[MWZMapOptions alloc] init];
    options.apiKey = kMapWizeApiKey;
    myMapView.delegate = self;
    [myMapView loadMapWithOptions: options];
    
    [myMapView access:kMapWizeAccessKey];
    [myMapView centerOnCoordinates:@48.82576 longitude:@2.25957 floor:@5 zoom:@21];
}

- (void)map:(MWZMapView *)map didClick:(MWZLatLon *)latlon {
}

- (void)map:(MWZMapView *)map didClickOnPlace:(MWZPlace *)place
{
    Room *room = [ModelDAO roomWithId:place.identifier];
    
    // Only if room is not grey
    if( room ) // && ![room.mapState isEqualToString:kDAORoomMapStateGrey] )
    {
        self.popupDetailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopupDetailController"];
        self.popupDetailViewController.room = room;
        
        //[self presentViewController:self.popupDetailViewController animated:YES completion:nil];
        
        BIZPopupViewController *popupViewController = [[BIZPopupViewController alloc] initWithContentViewController:popupDetailViewController
                                                                                                        contentSize:CGSizeMake(self.view.frame.size.width - 55, self.view.frame.size.height - 136)];
        [self presentViewController:popupViewController animated:NO completion:nil];
    }
}

- (void)map:(MWZMapView *)map didClickOnVenue:(MWZVenue *)venue {
}

- (void)map:(MWZMapView *)map didClickOnMarker:(MWZPosition *)marker {
}

- (void)map:(MWZMapView *)map didChangeFloor:(NSNumber *)floor {
}

- (void)map:(MWZMapView *)map didChangeFloors:(NSArray *)floors {
}

- (void)map:(MWZMapView *)map didMove:(MWZLatLon *)center {
}

- (void)map:(MWZMapView *)map didFailWithError:(NSError *)error {
}

- (void)map:(MWZMapView *)map didChangeFollowUserMode:(BOOL)followUserMode {
}

- (void)map:(MWZMapView *)map didChangeUserPosition:(MWZMeasurement *)userPosition {
}

- (void )map:(MWZMapView *)map didChangeZoom:(NSNumber *)zoom {
}

- (void )map:(MWZMapView *)map didClickLong:(MWZLatLon *)latlon
{
    if( self.filtersON )
    {
        self.filtersON = NO;
        [self decide];
        [self.filterViewController initState];
    }
}

- (void)map:(MWZMapView *)map didStartDirections:(NSString *)infos {
}

- (void )map:(MWZMapView *)map didStopDirections:(NSString *)infos {
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

- (void)setStepForSwipe:(int)stepForSwipe
{
    if( stepForSwipe == self.stepForSwipe )
        return;
    
    _stepForSwipe = stepForSwipe;
    
    [NavBarInstance sharedInstance].navBarTitle = ( self.stepForSwipe == 1 ? @"SÉLECTIONNER UN ESPACE"  :@"CHOIX DES CRITÈRES" );
}

//- (void) changeTitle2
//{
//    [NavBarInstance sharedInstance].navBarTitle = @"CHOIX DES CRITÈRES";
//}

- (void)swipeUp:(UIGestureRecognizer *)swipe
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.3];
    
    CGRect frame = container.frame;
    
    switch (self.stepForSwipe)
    {
        case 1 : // CAROUSEL -> CAROUSEL + DURATION
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.57;
//            [self changeTitle2];
            container.frame = frame;
            self.stepForSwipe = 2;
            self.filterViewController.stepForSwipe = 2;
            [self decide];
            break;
            
        case 2 : // CAROUSEL + DURATION -> FILTERS
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 6.35;
            container.frame = frame;
            self.stepForSwipe = 3;
            self.filterViewController.stepForSwipe = 3;
            self.myMapView.userInteractionEnabled = NO;
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
    
    switch (self.stepForSwipe)
    {
        case 2 : // CAROUSEL + DURATION -> CAROUSEL
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.22;
            container.frame = frame;
            self.stepForSwipe = 1;
            self.filterViewController.stepForSwipe = 1;
            [self decide];
            break;
            
        case 3 : // FILTERS -> CAROUSEL + DURATION
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.22;
            container.frame = frame;
            self.stepForSwipe = 1;
            self.myMapView.userInteractionEnabled = true;
            self.filtersON = self.filterViewController.filtersChanged;
            [self shouldStartAsynchtaskSensors];
            [self decide];
//            self.navbar.navBarTitle = @"SÉLECTIONNER UN ESPACE";
            break;
            
        default:
            break;
    }

    [UIView commitAnimations];
}

// HANDLE SENSORS

- (void)shouldStartAsynchtaskSensors
{
    if( !self.asynchtaskRunning )
    {
//        NSDate  *delay = [NSDate dateWithTimeIntervalSinceNow: 0.0];
//        self.timer = [[NSTimer alloc] initWithFireDate: delay
//                                              interval: 2
//                                                target: self
//                                              selector:@selector(checkSensors:)
//                                              userInfo:nil repeats:YES];
//        
//        // Can not disappear or will bug ;)
//        NSRunLoop *runner = [NSRunLoop currentRunLoop];
//        [runner addTimer:self.timer forMode: NSDefaultRunLoopMode];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                      target:self
                                                    selector:@selector(checkSensors:)
                                                    userInfo:nil
                                                     repeats:YES];
        self.asynchtaskRunning = YES;
    }
}

- (void)shouldStopAsynchtaskSensors
{
    if( self.asynchtaskRunning )
    {
        [self.timer invalidate];
        self.timer = nil;
        self.asynchtaskRunning = NO;
    }
}

- (void)checkSensors:(NSTimer *)timer
{
    if( self.finishedSensorUpdate )
    {
        NSLog(@"Execute WebService");
        [self.manager checkSensors:ModelDAO.allSensorsId];
        self.finishedSensorUpdate = NO;
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    static unsigned int _shakeCount = 0;
    
    if (motion == UIEventSubtypeMotionShake)
    {
        _shakeCount++;
        
        if( _shakeCount % 3 == 0 )
        {
            _shakeCount = 0;
            
            UIAlertController * alert =   [UIAlertController alertControllerWithTitle:@"Attention"
                                                                              message:@"Voulez-vous vraiment remettre à zéro les données ?"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Oui"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            [ModelDAO resetDatabase:YES];
                                        }];
            UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Non"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];

            

        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end




