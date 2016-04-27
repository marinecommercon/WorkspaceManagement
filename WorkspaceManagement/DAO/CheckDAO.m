//
//  CheckDAO.m
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "CheckDAO.h"

@implementation CheckDAO

+ (BOOL)checkAvailabilityBegin:(NSString *)begin withEnd:(NSString *)end forRoom:(Room *)room {
    
    NSDate *wishBegin = [Utils parseTimeToDate:begin];
    NSDate *wishEnd   = [Utils parseTimeToDate:end];
    
    if(room.reservations.count != 0)
    {
        for (Reservation *reservation in room.reservations)
        {
            NSDate *resaBegin = [Utils parseTimeToDate:reservation.beginTime];
            NSDate *resaEnd   = [Utils parseTimeToDate:reservation.endTime];
            
            // The wish is before or after the reservation
            // wishEnd 8h30 before/= resaBegin 8h
            // wishBegin 8h after/= resaEnd 8h30
            if( [resaBegin timeIntervalSinceDate:wishEnd] >= 0 || [wishBegin timeIntervalSinceDate:resaEnd] >= 0 )
            {
                // nothing
            }
            
            // If for one reservation the wish is inside, the room is not available. Process stops.
            else
            {
                //NSLog(@"The wish is inside the reservation");
                return false;
            }
        }
    }
    
    return true;
}

+ (NSString *)checkReservationTypeIfExist:(NSString *)begin withEnd:(NSString *)end forRoom:(Room *)room
{
    NSArray *sortedReservationArray = [Utils sortReservationsOfRoom:room.reservations];
    NSDate *wishBegin = [Utils parseTimeToDate:begin];
    NSDate *wishEnd   = [Utils parseTimeToDate:end];
    
    if(sortedReservationArray.count != 0)
    {
        for (Reservation *reservation in sortedReservationArray)
        {
            NSDate *resaBegin = [Utils parseTimeToDate:reservation.beginTime];
            NSDate *resaEnd   = [Utils parseTimeToDate:reservation.endTime];
            
            // The wish is before or after the reservation
            // wishEnd 8h30 before/= resaBegin 8h
            // wishBegin 8h after/= resaEnd 8h30
            if( [resaBegin timeIntervalSinceDate:wishEnd] >= 0 || [wishBegin timeIntervalSinceDate:resaEnd] >=0 )
            {
                // nothing
            }
            
            // If for one reservation the wish is inside, the room is not available. Process stops.
            else
            {
                //NSLog(@"The wish is inside the reservation");
                return reservation.type;
            }
        }
    }
    
    return @"noreservation";
}

+ (BOOL)checkAvailability:(NSString *)begin withEnd:(NSString *)end
{
    int count = 0;
    NSMutableArray * possibilities = [NSMutableArray array];
    
    NSArray *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
    
    if(listRooms.count != 0)
    {
        for (Room *room in listRooms)
        {
            // If room available
            if( [self checkAvailabilityBegin:begin
                                     withEnd:end
                                     forRoom:room] )
            {
                [possibilities addObject:room];
            }
            else
            {
                count++;
            }
        }
    }
    
    if( count == listRooms.count )
    {
        return false;
    }
    else
    {
        for(Room *room in possibilities)
            NSLog(@"room %@ available", room.name);
    }
    
    return true;
}

+ (NSString *)checkCurrentReservationType:(NSString *)currentTime room:(Room *)room
{
    NSString *limitTime = @"21:00";
    NSDate *limitDate   = [Utils parseTimeToDate:limitTime];
    
    NSDate *currentDate = [Utils parseTimeToDate:currentTime];
    
    if( [currentDate timeIntervalSinceDate:limitDate] >= 0 )
        return @"impossible";
    
    NSDate *dateOneMinuteMore   = [currentDate dateByAddingTimeInterval:60];
    NSString *timeOneMinuteMore = [Utils parseDateToTime:dateOneMinuteMore];

    return [self checkReservationTypeIfExist:currentTime
                                     withEnd:timeOneMinuteMore
                                     forRoom:room];
}

+ (NSString *)checkReservationType:(NSString *)nextHalfHour duration:(int)sliderValue room:(Room *)room
{
    NSString *limitUpTime   = @"21:00";
    NSString *limitDownTime = @"07:30";
    NSDate   *limitUpDate   = [Utils parseTimeToDate:limitUpTime];
    NSDate   *limitDownDate = [Utils parseTimeToDate:limitDownTime];
    
    NSDate   *nextHalfHourDate = [Utils parseTimeToDate:nextHalfHour];
    
    if( [limitDownDate timeIntervalSinceDate:nextHalfHourDate] > 0 )
    {
        nextHalfHour = @"07:30";
        nextHalfHourDate = limitDownDate;
    }

    NSDate   *dateDeltaMore = [nextHalfHourDate dateByAddingTimeInterval:(sliderValue*30*60)];
    
    if( [dateDeltaMore timeIntervalSinceDate:limitUpDate] > 0 )
        return @"impossible";
    
    NSString *timeDeltaMore = [Utils parseDateToTime:dateDeltaMore];

    return [self checkReservationTypeIfExist:nextHalfHour
                                     withEnd:timeDeltaMore
                                     forRoom:room];
}

+ (NSString *)checkReservationType:(NSString *)nextHalfHour room:(Room *)room
{
    NSString *limitUpTime   = @"21:00";
    NSDate   *limitUpDate   = [Utils parseTimeToDate:limitUpTime];
    
    NSDate *nextHalfHourDate = [Utils parseTimeToDate:nextHalfHour];
    if( [nextHalfHourDate timeIntervalSinceDate:limitUpDate] >= 0 )
        return @"impossible";
    
    NSDate   *dateThirtyMinuteMore = [nextHalfHourDate dateByAddingTimeInterval:30*60];
    NSString *timeThirtyMinuteMore = [Utils parseDateToTime:dateThirtyMinuteMore];

    return [self checkReservationTypeIfExist:nextHalfHour
                                     withEnd:timeThirtyMinuteMore
                                     forRoom:room];
}

+ (int)getMaxDuration:(NSString *)beginTime room:(Room *)room
{
    NSArray *sortedReservationArray = [Utils sortReservationsOfRoom:room.reservations];
    NSDate  *myWishDate             = [Utils parseTimeToDate:beginTime];
    int minutes   = 0;
    int halfHours = 0;
    
    // There must be at least one reservation
    if( sortedReservationArray.count != 0 )
    {
        
        // At this point, we don't know if there is one reservation or more
        // In both cases, it is possible to check the time before first reservation
        // And then to check the time after last reservation
        Reservation *firstReservation = sortedReservationArray[0];
        Reservation *lastReservation  = sortedReservationArray[sortedReservationArray.count-1];
        
        NSDate *resaBegin = [Utils parseTimeToDate:firstReservation.beginTime];
        NSDate *resaEnd   = [Utils parseTimeToDate:lastReservation.endTime];
        
        // Case : my wish is before the beginning of the reservation
        if( [resaBegin timeIntervalSinceDate:myWishDate] >=0 )
        {
            minutes = [self getMaxTimeBeforeFirstReservation:myWishDate withTime:resaBegin];
            halfHours = floorf(minutes/30);
            return halfHours;
        }
        
        // Case : my wish is after the end of the last reservation
        else if( [myWishDate timeIntervalSinceDate:resaEnd] >= 0 )
        {
            minutes = [self getMaxTimeAfterLastReservation:myWishDate];
            halfHours = floorf(minutes/30);
            return halfHours;
        }
        
        // If more than one reservation
        // Check the time between two reservations
        else if( sortedReservationArray.count > 1 )
        {
            for(int i = 0 ; i < sortedReservationArray.count-1 ; i++)
            {
                Reservation *reservation1 = sortedReservationArray[i];
                Reservation *reservation2 = sortedReservationArray[i+1];
                NSDate *resa1End   = [Utils parseTimeToDate:reservation1.endTime];
                NSDate *resa2Begin = [Utils parseTimeToDate:reservation2.beginTime];
                
                // Case between 2 reservations
                if( [myWishDate timeIntervalSinceDate:resa1End] >= 0 && [myWishDate timeIntervalSinceDate: resa2Begin] <= 0 )
                {
                    double duration = [resa2Begin timeIntervalSinceDate:myWishDate];
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

+ (double)getMaxTimeBeforeFirstReservation:(NSDate *)myWishDate withTime:(NSDate *)beginDate
{
    if( myWishDate < [Utils parseTimeToDate:@"07:30"] )
        myWishDate = [Utils parseTimeToDate:@"07:30"];
    
   return floor([beginDate timeIntervalSinceDate:myWishDate]/60);
}

+ (double)getMaxTimeAfterLastReservation:(NSDate *)myWishDate
{
    if(myWishDate > [Utils parseTimeToDate:@"21:00"])
        return 0.0;
    else
        return floor([[Utils parseTimeToDate:@"21:00"] timeIntervalSinceDate:myWishDate]/60);
}

+ (double)getMaxDurationForBeginTime:(NSString *)beginTime
{
    NSArray *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
    
    if( !listRooms )
        listRooms = [NSArray array];
    
    double maxDurationTemp = 0;
    
    for (Room *room in listRooms)
    {
        double possibleDuration = [self getMaxDuration:beginTime
                                                  room:room];
        if(possibleDuration > maxDurationTemp)
            maxDurationTemp = possibleDuration;
    }
    
    return maxDurationTemp;
}

+ (BOOL)getStateForRoom:(NSString *)idMapwize time:(NSString *)time timeInterval:(int)interval
{
    Room   *room                = [ModelDAO getRoomById:idMapwize];
    NSDate *chosenDate          = [Utils parseTimeToDate:time];
    NSDate *dateAfterInterval   = [chosenDate dateByAddingTimeInterval:interval];
    
    NSString *chosenTime        = [Utils parseDateToTime:chosenDate];
    NSString *timeAfterInterval = [Utils parseDateToTime:dateAfterInterval];
    
    return [self checkAvailabilityBegin:chosenTime
                                withEnd:timeAfterInterval
                                forRoom:room];
}

+ (BOOL)roomHasSensorOn:(Room *)room
{
    NSSet *sensors = room.sensors;
    
    // If at least one sensor has eventValue = 1 return true
    for(Sensor *sensor in sensors)
        if( [sensor.eventValue isEqualToString:@"1"] )
            return true;
    
    return false;
}

@end
