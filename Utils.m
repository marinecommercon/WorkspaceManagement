//
//  Utils.m
//  WorkspaceManagement
//
//  Created by Lyess on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSDate*)parseTimeToDate:(NSString*)time {
    
    NSDate     *dateTemp;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger customHour   = [[time substringWithRange:NSMakeRange(0,2)]integerValue];
    NSInteger customMinute = [[time substringWithRange:NSMakeRange(3,2)]integerValue];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    
    [components setHour:customHour];
    [components setMinute:customMinute];
    dateTemp = [calendar dateFromComponents:components];
    
    return dateTemp;
}

+ (NSString*)parseDateToTime:(NSDate*)date {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH:mm"];
    NSString* dateString = [f stringFromDate:date];
    return dateString;
}

+ (NSArray*)sortReservationsOfRoom:(Room*)room {
    
    NSSet<Reservation *> *reservations = room.reservations;
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"beginTime"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedReservationArray = [reservations
                                       sortedArrayUsingDescriptors:sortDescriptors];
    return sortedReservationArray;
}

+ (NSDictionary*)generateHoursForCaroussel{
    NSDate   *date        = [NSDate date];
    NSString *centralTime = [self parseDateToTime:date];
    int       position    = 0;
    
    NSArray *schedules = @[@"07:30", @"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30", @"12:00",@"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30",@"21:00"];
    
    NSMutableArray *newSchedules = [[NSMutableArray alloc] init];
    [newSchedules addObject:schedules[0]];
    
    for(int i = 0 ; i<[schedules count]-1 ; i++){
        NSDate *begin = [self parseTimeToDate:schedules[i]];
        NSDate *end   = [self parseTimeToDate:schedules[i+1]];
        
        if([date timeIntervalSinceDate:begin] > 0 && [end timeIntervalSinceDate:date] > 0
           && !([centralTime isEqualToString:schedules[i]]) ){
            
            [newSchedules addObject:centralTime];
            position = i+1;
            
        }
        [newSchedules addObject:schedules[i+1]];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          newSchedules, @"hours",
                          @(position), @"position", nil];
    return dict;
}

@end