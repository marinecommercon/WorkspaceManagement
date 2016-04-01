//
//  Sensor.h
//  WorkspaceManagement
//
//  Created by Technique on 01/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Room.h"

@class Room;

@interface Sensor : NSManagedObject

@property (nonatomic, retain) NSString * idSensor;
@property (nonatomic, retain) NSDate   * eventDate;
@property (nonatomic, retain) NSString * eventValue;
@property (nonatomic, retain) Room     * room;

@end