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
#import "DSIViewController.h"
#import "CCMPopup/CCMPopupTransitioning.h"
#import "PopupDetailViewController.h"
#import "Manager.h"

@interface MapViewController : UIViewController <MWZMapDelegate, ManagerDelegate, FilterViewControllerDelegate>

@property (strong,nonatomic) FilterViewController *filterViewController;

@property (strong, nonatomic)CLLocationManager* locationManager;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet MWZMapView *myMapView;
@property (nonatomic, strong) Manager *manager;

- (void)checkSensors:timer;
- (void)finishCheckWithUpdate:(BOOL)updateNeeded;
- (void)updateMap;

@end