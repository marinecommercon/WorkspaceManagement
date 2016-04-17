//
//  MapViewController.h
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

@import Mapwize;
#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "FilterViewController.h"
#import "ReservationViewController.h"
#import "DSIViewController.h"
#import "CCMPopup/CCMPopupTransitioning.h"
#import "PopupDetailViewController.h"
#import "Manager.h"
#import "UIColor+AppAdditions.h"
#import "CheckDAO.H"
#import "NavBarInstance.h"

@interface MapViewController : UIViewController <MWZMapDelegate, ManagerDelegate, FilterViewControllerDelegate, PopupDetailViewControllerDelegate>

@property (strong, nonatomic) PopupDetailViewController *popupDetailViewController;
@property (strong,nonatomic) FilterViewController *filterViewController;
@property (strong,nonatomic) NavBarInstance *navbar;

@property (strong,nonatomic) NSArray *roomsAppDsi;
@property (strong,nonatomic) NSArray *roomsFree;

@property (strong, nonatomic)CLLocationManager* locationManager;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet MWZMapView *myMapView;
@property (nonatomic, strong) Manager *manager;

// Params to handle MapViewController
@property int  stepForSwipe;
@property BOOL asynchtaskRunning;
@property BOOL finishedSensorUpdate;
@property (nonatomic, strong) NSTimer *timer;

// Params to make decision (states of rooms)
@property BOOL filtersON;
@property (nonatomic,strong)  NSString *currentTime;
@property (nonatomic,strong)  NSString *nextTime;
@property BOOL realTime;
@property int sliderValue;


@end