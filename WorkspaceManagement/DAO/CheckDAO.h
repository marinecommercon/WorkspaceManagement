//
//  CheckDAO.h
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"
#import "Utils.h"
#import "DAO.h"
#import "ModelDAO.h"

@interface CheckDAO : NSObject

+ (BOOL)checkAvailabilityBegin:(NSString*)begin withEnd:(NSString*)end forRoom:(Room*)room;

+ (NSString*)checkReservationTypeIfExist:(NSString*)begin withEnd:(NSString*)end forRoom:(Room*)room;

+ (BOOL)checkAvailability: (NSString*)begin withEnd:(NSString*)end;

+ (NSString*)checkCurrentReservationType:(NSString*)currentTime room:(Room*)room;

+ (NSString*)checkReservationType:(NSString*)nextHalfHour duration:(int)sliderValue room:(Room*)room;

+ (NSString*)checkReservationType:(NSString*)nextHalfHour room:(Room*)room;

+ (int)getMaxDuration:(NSString*)beginTime room: (Room*)room;

+ (double)getMaxDurationForBeginTime:(NSString*)beginTime;

+ (BOOL)getStateForRoom:(NSString*)idMapwize time:(NSString*)time timeInterval:(int)interval;

+ (BOOL)roomHasSensorOn:(Room*)room;

@end
