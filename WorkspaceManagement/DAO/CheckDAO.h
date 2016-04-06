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

+ (BOOL)checkAvailability:(NSString*)beginTimeWished withEnd:(NSString*)endTimeWished;

+ (BOOL)checkAvailability:(NSDate*)beginDateWished withEnd:(NSDate*)endDateWished withRoom:(Room*)room;

+ (BOOL)checkAvailability:(NSString*)beginStringWished End:(NSString*)endStringWished Room:(Room*)room;

+ (int)getPossibleDurationForBeginTime:(NSString*)beginTime withRoom: (Room*)room;

+ (double)getMaxDurationForBeginTime:(NSString*)beginTime;

+ (BOOL)getCurrentStateForRoom:(NSString*)idMapwize;

+ (BOOL)getStateForRoom:(NSString*)idMapwize time:(NSString*)time timeInterval:(int)interval;

+ (BOOL)roomHasSensorOn:(NSString*)idMapwize;

@end
