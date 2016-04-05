//
//  ContainerViewController.h
//  Workspace Management
//
//  Created by Lyess on 31/03/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DSIViewController.h"

@interface FilterViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (strong, nonatomic) IBOutlet UIView *viewSlider;

@end