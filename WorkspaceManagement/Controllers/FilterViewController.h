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
#import "UIColor+AppAdditions.h"

@protocol FilterViewControllerDelegate
- (void)didChangeCarousel:(NSString*)hour realTime:(BOOL)realTime;
- (void)didChangeSlider:(int)sliderValue;
@end

@interface FilterViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@property (nonatomic,strong)  NSMutableArray *schedulesArray;
@property (nonatomic,strong)  NSDictionary *hoursDictionnary;
@property NSInteger realTimePosition;

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIView *viewSlider;

@property (weak, nonatomic) IBOutlet UIButton *retroButton;
@property (weak, nonatomic) IBOutlet UIButton *screenButton;
@property (weak, nonatomic) IBOutlet UIButton *tableButton;
@property (weak, nonatomic) IBOutlet UIButton *dockButton;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

- (IBAction)retroAction:(id)sender;
- (IBAction)screenAction:(id)sender;
- (IBAction)tableAction:(id)sender;
- (IBAction)dockAction:(id)sender;
- (IBAction)stepperAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;

@property BOOL realTime;
@property int  numberOfPeople;

- (BOOL) filtersChanged;
- (void) initState;

@end




