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

@interface MapViewController : UIViewController <MWZMapDelegate>

@property (strong, nonatomic)CLLocationManager* locationManager;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet MWZMapView *myMapView;


@end