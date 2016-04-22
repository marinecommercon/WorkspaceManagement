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
- (void)didChangeCarousel:(NSArray*)schedulesArray position:(NSInteger)position realTime:(BOOL)realTime;
- (void)didChangeSlider:(int)sliderValue;
@end

@interface FilterViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@property (nonatomic,strong)  NSMutableArray *schedulesArray;
@property (nonatomic,strong)  NSDictionary *hoursDictionnary;
@property int realTimePosition;

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIView *viewSlider;
@property (strong, nonatomic) IBOutlet UIView *viewDate;
@property (strong, nonatomic) IBOutlet UIView *viewNbrPeople;
@property (strong, nonatomic) IBOutlet UIView *viewRoomItems;
@property (strong, nonatomic) IBOutlet UIView *viewSearch;

@property (weak, nonatomic) IBOutlet UIButton *retroButton;
@property (weak, nonatomic) IBOutlet UIButton *screenButton;
@property (weak, nonatomic) IBOutlet UIButton *tableButton;
@property (weak, nonatomic) IBOutlet UIButton *dockButton;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@property (strong, nonatomic) IBOutlet UITextField *textFieldSearch;

- (IBAction)retroAction:(id)sender;
- (IBAction)screenAction:(id)sender;
- (IBAction)tableAction:(id)sender;
- (IBAction)dockAction:(id)sender;
- (IBAction)stepperAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;

@property (strong,nonatomic) NSMutableArray *roomsAppDsiFiltered;
@property (strong,nonatomic) NSMutableArray *roomsFreeFiltered;
@property (strong,nonatomic) NSMutableArray *roomsNotCorresponding;

@property int  stepForSwipe;
@property BOOL realTime;
@property int  numberOfPeople;

- (BOOL) filtersChanged;
- (void) initState;
- (void) updateFilteredLists:(NSArray*)equipmentList;
- (void) updateCarousel:(NSTimer *)timer andPosition:(BOOL)updatePosition;

@end




