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

+ (NSDictionary*)generateHoursForCaroussel:(NSString*)currentTime {
    NSDate   *date     = [NSDate date];
    //NSDate   *date     = [self aleaDate];
    //NSDate   *date       = [self testDate:currentTime];
    NSString *newTime    = [self parseDateToTime:date];
    int       position   = 0;
    
    if([newTime isEqualToString:currentTime]){
        return nil;
    }
    else {
        NSArray *schedules = @[@"07:30", @"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30", @"12:00",@"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30",@"21:00"];
        
        NSMutableArray *newSchedules = [[NSMutableArray alloc] init];
        [newSchedules addObject:schedules[0]];
        
        int i = 0;
        while(i<[schedules count]-1){
            NSDate *begin = [self parseTimeToDate:schedules[i]];
            NSDate *end   = [self parseTimeToDate:schedules[i+1]];
            
            // If current time is between two schedules (>=)
            if([date timeIntervalSinceDate:begin] > 0 && [end timeIntervalSinceDate:date] >= 0){
                
                // If current time inside two schedules (>)
                if(![newTime isEqualToString:schedules[i]] && ![newTime isEqualToString:schedules[i+1]]){
                    [newSchedules addObject:newTime];
                    [newSchedules addObject:schedules[i+1]];
                    position = i+1;
                }
                
                // If current time is one schedule (=)
                else {
                    [newSchedules addObject:schedules[i+1]];
                    position = i+1;
                }
            }
            // If current time is not inside two schedules
            else {
                [newSchedules addObject:schedules[i+1]];
            }
            i++;
        }
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              newSchedules, @"hours",
                              @(position), @"position", nil];
        return dict;
    }
}

+ (NSMutableArray *)jsonWithPath:(NSString *)name {
    NSError* error;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

+ (NSDate *)aleaDate {
    NSDate   *date         = [NSDate date];
    NSString *time         = [self parseDateToTime:date];
    NSString *hour         = [time substringWithRange:NSMakeRange(0,2)];
    int lowerBound = 10;
    int upperBound = 60;
    int aleaMinute = lowerBound + arc4random() % (upperBound - lowerBound);
    NSDate   *aleaDate     = [self parseTimeToDate:[NSString stringWithFormat:@"%@:%d",hour,aleaMinute]];
    
    return aleaDate;
}

+ (NSDate *)testDate:(NSString*)currentTime {
    NSString *newTime;
    NSString *time = @"14:28";
    
    // Init time
    if(currentTime == nil){
        newTime = time;
    }
    
    // If already init, get the next minute
    else {
        NSString  *hour         = [currentTime substringWithRange:NSMakeRange(0,2)];
        NSString  *minute       = [currentTime substringWithRange:NSMakeRange(3,2)];
        
        if(![[minute substringWithRange:NSMakeRange(0,1)] isEqualToString:@"0"]){
            NSInteger nextMinute    = [minute integerValue]+1;
            newTime = [NSString stringWithFormat:@"%@:%ld",hour,(long)nextMinute];
        }
        else {
            NSInteger nextMinute    = [minute integerValue]+1;
            if(nextMinute==10){
                newTime = [NSString stringWithFormat:@"%@:%ld",hour,(long)nextMinute];
            }
            else{
                newTime = [NSString stringWithFormat:@"%@:0%ld",hour,(long)nextMinute];
            }
        }
    }
    
    NSDate   *testDate = [self parseTimeToDate:newTime];
    return testDate;
}

+ (UIColor*)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end