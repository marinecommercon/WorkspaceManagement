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
#import "Utils.h"

@protocol FilterViewControllerDelegate
- (void)shouldStartAsynchtask;
- (void)shouldStopAsynchtask;
@end

@interface FilterViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@property (nonatomic,strong)  NSMutableArray *schedulesArray;
@property (nonatomic,strong)  NSDictionary *hoursDictionnary;
@property int carouselPosition;

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIView *viewSlider;

@end




