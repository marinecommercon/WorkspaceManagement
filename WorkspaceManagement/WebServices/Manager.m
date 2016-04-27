//
//  Manager.m
//  WorkspaceManagement
//
//  Created by Technique on 06/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "Manager.h"

@implementation Manager
{
    int count;
    BOOL stopExecution;
    BOOL updateWasNeeded;
    NSString *startDate;
    NSString *endDate;
}


// This method is called by MapViewController.
// It calls WSDownloader, giving the date params for the url
// The webservice with fake devices is available from 23-31 march 2016

- (void) checkSensors:(NSArray*)deviceList
{
    self.ws          = [[WSDownloader alloc] init];
    self.ws.delegate = self;
    self.deviceList  = deviceList;

    NSDate *now              = [NSDate date];
    NSDate *sevenDaysAgo     = [now dateByAddingTimeInterval:-7*24*60*60];
    
    // Patch to query Hub between 23 and 31 of march while the hub doesn't deliver new data
    now = [NSDate dateWithTimeIntervalSince1970:1458691200]; // 20160323:000000
    sevenDaysAgo = [NSDate dateWithTimeIntervalSince1970:1459382400]; // 20160331:000000
    
    
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    [dformat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    startDate = [dformat  stringFromDate:sevenDaysAgo];
    endDate   = [dformat  stringFromDate:now];
    
    count = 0;
    updateWasNeeded = false;
    
    [self.ws startDownload:[deviceList objectAtIndex:count]
             withStartDate:startDate
                andEndDate:endDate];
}

// DOWNLOADER DELEGATE
// If the download fails & if the list of sensors is not finished it should try again

- (void)downloadFailed:(NSError *)error
{
    if(error.code == -1009)
    {
        NSLog(@"Lost Connection");
    }
    if(count < self.deviceList.count)
    {
        [self.ws startDownload:self.deviceList[count]
                 withStartDate:startDate
                    andEndDate:endDate];
    }
}

// If the download is successful then we will start to compare
// the result downloaded with its last value stored in database

- (void) didSuccessDownload:(NSData *)data
{
    [self startComparison:self.deviceList[count]
                 withData:data];
}

// If one of the sensor values changed since last update, then we'll inform MapViewController that it should update the map

- (void) startComparison:(NSString *)idSensor withData:(NSData *)data
{
    NSDictionary *results           = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *resultsDictionary = results[@"results"][0];
    NSString *eventDateString       = resultsDictionary[@"eventDate"];
    NSString *eventValue            = resultsDictionary[@"value"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *eventDate = [dateFormatter dateFromString:eventDateString];
    
    //  Check if the sensor exist in database
    
    Sensor *mySensor = [ModelDAO getSensorById:idSensor];
    
    if(mySensor != nil)
    {
        
        // Compare the value in database with the value downloaded
        // If not, update the value and the eventDate in database
        
        if([ModelDAO checkSensorWithId:idSensor
                             eventDate:eventDate
                            eventValue:eventValue])
        {
            updateWasNeeded = true;
        } 
    }
    
    // Start another download if the list of sensors is not completed
    count++;
    
    if(count < self.deviceList.count)
    {
        [self.ws startDownload:self.deviceList[count]
                 withStartDate:startDate
                    andEndDate:endDate];
    }
    
    // All sensors have been dowloaded
    else if (count == self.deviceList.count)
    {
        NSLog(@"Finished to Execute WebService");
        
        // Inform MapViewController that it should/shouldn't update the map
        [self.delegate finishCheckWithUpdate:updateWasNeeded];
    }
}


@end