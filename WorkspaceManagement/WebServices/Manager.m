//
//  Manager.m
//  WorkspaceManagement
//
//  Created by Technique on 06/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "Manager.h"

@implementation Manager {
    int count;
    BOOL stopExecution;
    BOOL updateWasNeeded;
    NSString *startDate;
    NSString *endDate;
}

- (void) checkSensors:(NSArray*)deviceList {
    
    self.ws          = [[WSDownloader alloc]init];
    self.ws.delegate = self;
    self.deviceList  = deviceList;
    
    NSDate *now              = [NSDate date];
    NSDate *sevenDaysAgo     = [now dateByAddingTimeInterval:-14*24*60*60];
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    [dformat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    startDate = [dformat  stringFromDate:sevenDaysAgo];
    endDate   = [dformat  stringFromDate:now];
    
    count = 0;
    updateWasNeeded = false;
    
    [self.ws startDownload:[deviceList objectAtIndex:count] withStartDate:startDate andEndDate:endDate];
}

// DOWNLOADER DELEGATE
- (void)downloadFailed:(NSError *)error
{
    if(error.code == -1009){
        NSLog(@"Lost Connection");
    }
    if(count < [self.deviceList count]){
        [self.ws startDownload:[self.deviceList objectAtIndex:count] withStartDate:startDate andEndDate:endDate];
    }
}

- (void) didSuccessDownload:(NSData *)data
{
    [self startComparison:[self.deviceList objectAtIndex:count] withData:data];
}



- (void) startComparison:(NSString *)idSensor withData:(NSData *)data {
    
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *resultsDictionary = [[results objectForKey:@"results"] objectAtIndex:0];
    NSString *eventDateString = [resultsDictionary objectForKey:@"eventDate"];
    NSString *eventValue      = [resultsDictionary objectForKey:@"value"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *eventDate = [dateFormatter dateFromString:eventDateString];
    
    // The object should be in database, if not check idHub vs idJson
    Sensor *mySensor = [ModelDAO getSensorById:idSensor];
    if(mySensor != nil){
        if([ModelDAO checkSensorWithId:idSensor eventDate:eventDate eventValue:eventValue]){
            updateWasNeeded = true;
        } 
    }
    
    // Compare until the end of the list
    count++;
    if(count < [self.deviceList count]){
        [self.ws startDownload:[self.deviceList objectAtIndex:count] withStartDate:startDate andEndDate:endDate];
    } else if (count == [self.deviceList count]){
        NSLog(@"Finished to Execute WebService");
        [self.delegate finishCheckWithUpdate:updateWasNeeded];
    }
}


@end