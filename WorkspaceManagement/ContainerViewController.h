//
//  ContainerViewController.h
//  Workspace Management
//
//  Created by Lyess on 31/03/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ContainerViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@end
