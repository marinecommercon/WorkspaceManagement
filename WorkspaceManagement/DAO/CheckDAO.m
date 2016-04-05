//
//  CheckDAO.m
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "CheckDAO.h"

@implementation CheckDAO

+ (BOOL) checkAvailability: (NSDate*)beginDateWished withEnd:(NSDate*)endDateWished withRoom:(Room*)room {
    
    if(room.reservations.count != 0){
        for (Reservation *reservation in room.reservations) {
            
            //[self logReservation:beginDateWished withEnd:endDateWished];
            //[self logReservation:reservation.beginTime withEnd:reservation.endTime];
            
            // The wish is before the reservation
            if([reservation.beginTime timeIntervalSinceDate:beginDateWished]>0 &&
               [reservation.beginTime timeIntervalSinceDate:endDateWished]>=0){
                //NSLog(@"The wish is before the reservation");
            }
            
            // The wish is after the reservation
            else if([beginDateWished timeIntervalSinceDate:reservation.endTime]>=0 &&
                    [endDateWished timeIntervalSinceDate:reservation.endTime]>0){
                //NSLog(@"The wish is after the reservation");
            }
            
            // If for one reservation there is a conflict, the room is not available. Process stops.
            else {
                //NSLog(@"The wish is inside the reservation");
                return false;
            }
        }
    }
    return true;
}

+ (BOOL) checkAvailability: (NSString*)beginStringWished End:(NSString*)endStringWished Room:(Room*)room {
    
    NSDate *beginDateWished = [Utils parseTimeToDate:beginStringWished];
    NSDate *endDateWished   = [Utils parseTimeToDate:endStringWished];
    
    if(room.reservations.count != 0){
        for (Reservation *reservation in room.reservations) {
            
            //            [self logReservation:beginDateWished withEnd:endDateWished];
            //            [self logReservation:reservation.beginTime withEnd:reservation.endTime];
            
            // The wish is before the reservation
            if([reservation.beginTime timeIntervalSinceDate:beginDateWished]>0 &&
               [reservation.beginTime timeIntervalSinceDate:endDateWished]>=0){
                //NSLog(@"The wish is before the reservation");
            }
            
            // The wish is after the reservation
            else if([beginDateWished timeIntervalSinceDate:reservation.endTime]>=0 &&
                    [endDateWished timeIntervalSinceDate:reservation.endTime]>0){
                //NSLog(@"The wish is after the reservation");
            }
            
            // If for one reservation there is a conflict, the room is not available. Process stops.
            else {
                //NSLog(@"The wish is inside the reservation");
                return false;
            }
        }
    }
    return true;
}


+ (BOOL) checkAvailability: (NSString*)beginTimeWished withEnd:(NSString*)endTimeWished {
    
    NSDate *beginDateWished = [Utils parseTimeToDate:beginTimeWished];
    NSDate *endDateWished   = [Utils parseTimeToDate:endTimeWished];
    int count = 0;
    NSMutableArray * possibilities = [NSMutableArray new];
    
    NSArray *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
    if(listRooms.count != 0){
        for (Room *room in listRooms) {
            
            // If room available
            if([self checkAvailability:beginDateWished withEnd:endDateWished withRoom:room]){
                [possibilities addObject:room];
            } else {
                count++;
            }
        }
    }
    if(count == listRooms.count){
        return false;
    } else {
        for(Room *room in possibilities){
            NSLog(@"room %@ available", room.name);
        }
    }
    return true;
}

+ (int) getPossibleDurationForBeginTime:(NSString*)beginTime withRoom: (Room*) room {
    
    NSArray *sortedReservationArray = [Utils sortReservationsOfRoom:room];
    NSDate  *myWishDate             = [Utils parseTimeToDate:beginTime];
    int minutes   = 0;
    int halfHours = 0;
    
    // There must be at least one reservation
    if(sortedReservationArray.count != 0){
        
        // At this point, we don't know if there is one reservation or more
        // In both cases, it is possible to check the time before first reservation
        // And then to check the time after last reservation
        Reservation *firstReservation = [sortedReservationArray objectAtIndex:0];
        Reservation *lastReservation  = [sortedReservationArray objectAtIndex:sortedReservationArray.count-1];
        
        // Case : my wish is before the beginning of the reservation
        if([firstReservation.beginTime timeIntervalSinceDate:myWishDate] >=0){
            minutes = [self getMaxTimeBeforeFirstReservation:myWishDate withTime:firstReservation.beginTime];
            halfHours = floorf(minutes/30);
            return halfHours;
        }
        
        // Case : my wish is after the end of the last reservation
        else if([myWishDate timeIntervalSinceDate:lastReservation.endTime] >= 0){
            minutes = [self getMaxTimeAfterLastReservation:myWishDate];
            halfHours = floorf(minutes/30);
            return halfHours;
        }
        
        // If more than one reservation
        // Check the time between two reservations
        else if(sortedReservationArray.count>1){
            
            for(int i = 0 ; i < sortedReservationArray.count-1 ; i++){
                
                Reservation *reservation1 = [sortedReservationArray objectAtIndex:i];
                Reservation *reservation2 = [sortedReservationArray objectAtIndex:i+1];
                
                // Case between 2 reservations
                if([myWishDate timeIntervalSinceDate:reservation1.endTime] >= 0 && [myWishDate timeIntervalSinceDate: reservation2.beginTime] <= 0){
                    double duration = [reservation2.beginTime timeIntervalSinceDate:myWishDate];
                    halfHours = floorf(duration/1800);
                    return halfHours;
                }
            }
        }
    }
    
    // If no reservation
    // Set the difference between 21h and beginTime
    else {
        NSDate  *endDate = [Utils parseTimeToDate:@"21:00"];
        double duration  = [endDate timeIntervalSinceDate:myWishDate];
        halfHours = floorf(duration/1800);
    }
    
    return halfHours;
}

+ (double) getMaxTimeBeforeFirstReservation:(NSDate*)myWishDate withTime:(NSDate*) beginDate {
    double minutes = 0.0;
    if(myWishDate < [Utils parseTimeToDate:@"07:30"]){
        double duration = [beginDate  timeIntervalSinceDate:[Utils parseTimeToDate:@"07:30"]];
        minutes = floor(duration/60);
        return minutes;
    }
    else {
        double duration = [beginDate  timeIntervalSinceDate:myWishDate];
        double minutes = floor(duration/60);
        return minutes;
    }
}

+ (double) getMaxTimeAfterLastReservation:(NSDate*)myWishDate {
    double minutes = 0.0;
    if(myWishDate > [Utils parseTimeToDate:@"21:00"]){
        return minutes;
    }
    else {
        double duration = [[Utils parseTimeToDate:@"21:00"]  timeIntervalSinceDate:myWishDate];
        minutes = floor(duration/60);
        return minutes;
    }
    
}

+ (double) getMaxDurationForBeginTime:(NSString*)beginTime {
    NSArray *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
    double maxDurationTemp = 0;
    
    if(listRooms.count != 0){
        for (Room *room in listRooms) {
            double possibleDuration = [self getPossibleDurationForBeginTime:beginTime withRoom:room];
            if(possibleDuration > maxDurationTemp){
                maxDurationTemp = possibleDuration;
            }
        }
    }
    return maxDurationTemp;
}

+ (BOOL)getCurrentStateForRoom:(NSString*)idMapwize {
    Room   *room = [ModelDAO getRoomById:idMapwize];
    NSDate *currentDate     = [NSDate date];
    NSDate *minuteAfterDate = [currentDate dateByAddingTimeInterval:(60)];
    
    BOOL available = [self checkAvailability:currentDate withEnd:minuteAfterDate withRoom:room];
    
    //NSString *test1 = [Utils parseDateToTime:currentDate];
    //NSString *test2 = [Utils parseDateToTime:minuteAfterDate];
    //BOOL available2 = [self checkAvailability:test1 End:test2 Room:room];
    
    return available;
}

+ (BOOL)getStateForRoom:(NSString*)idMapwize time:(NSString*)time timeInterval:(int)interval {
    Room   *room              = [ModelDAO getRoomById:idMapwize];
    NSDate *chosenDate        = [Utils parseTimeToDate:time];
    NSDate *intervalAfterDate = [chosenDate dateByAddingTimeInterval:interval];
    
    BOOL available = [self checkAvailability:chosenDate withEnd:intervalAfterDate withRoom:room];
    
    return available;
}


@end
