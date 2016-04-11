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
#import "Equipment.h"

@class Reservation;
@class Sensor;
@class Equipment;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSString  *name;
@property (nonatomic, retain) NSString  *idMapwize;
@property (nonatomic, retain) NSNumber  *maxPeople;
@property (nonatomic, retain) NSString  *type;
@property (nonatomic, retain) NSSet     *reservations;
@property (nonatomic, retain) NSSet     *sensors;
@property (nonatomic, retain) NSSet     *equipments;

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

- (void)addEquipmentsObject:(Equipment *)value;
- (void)removeEquipmentsObject:(Equipment *)value;
- (void)addEquipments:(NSSet *)values;
- (void)removeEquipments:(NSSet *)values;

@end
