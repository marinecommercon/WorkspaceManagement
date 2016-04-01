//
//  Room.h
//  WorkspaceManagement
//
//  Created by Technique on 01/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Reservation.h"
#import "Sensor.h"

@class Reservation;
@class Sensor;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *idMapwize;
@property (nonatomic, retain) NSSet    *reservations;
@property (nonatomic, retain) NSSet    *sensors;

@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addReservationsObject:(Reservation *)value;
- (void)removeReservationsObject:(Reservation *)value;
- (void)addReservations:(NSSet *)values;
- (void)removeReservations:(NSSet *)values;

- (void)addSensorsObject:(Sensor *)value;
- (void)removeSensorsObject:(Sensor *)value;
- (void)addSensors:(NSSet *)values;
- (void)removeSensors:(NSSet *)values;

@end