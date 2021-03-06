//
//  Utils.h
//  WorkspaceManagement
//
//  Created by Lyess on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Room.h"

extern NSString *kCarouselKeyHours;
extern NSString *kCarouselKeyPosition;

@interface Utils : NSObject

@property (assign) int chunkID;

+ (NSDate *)parseTimeToDate:(NSString *)time;
+ (NSString *)parseDateToTime:(NSDate *)date;
+ (NSArray *)sortReservationsOfRoom:(NSSet *)reservations;
+ (NSDictionary *)generateHoursForCaroussel:(NSString *)currentTime;
+ (NSMutableArray *)jsonWithPath:(NSString *)name;
+ (NSDate *)aleaDate;

@end
