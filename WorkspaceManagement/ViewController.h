//
//  ViewController.h
//  Workspace Management
//
//  Created by Lyess on 31/03/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

@import Mapwize;
#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"

@interface ViewController : UIViewController <MWZMapDelegate>

@property (strong, nonatomic)CLLocationManager* locationManager;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet MWZMapView *myMapView;


@end