//
//  ModelDAO.h
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAO.h"
#import "Room.h"
#import "Reservation.h"
#import "Sensor.h"

@interface ModelDAO : NSObject

// GET

+ (Room*)getRoomById:(NSString*)idMapwize;

+ (Equipment*)getEquipmentByKey:(NSString*)key;

+ (Sensor*)getSensorById:(NSString*)idSensor;

+ (NSArray*)getAllRoomsName;

+ (NSArray*)getAllSensorsId;

+ (NSString*)getReservationType:(NSString*)beginTime;

+ (Reservation*)getCorrespondingReservation:(NSString*)beginTime room: (Room*)room;

// ADD

+ (void)addRoomWithName:(NSString*)name IdMapwize:(NSString*)idMapwize;

+ (void)addReservation:(NSString*)begin end:(NSString*)end room:(Room*)room type:(NSString*)type;

+ (void)addReservationApp:(NSString*)begin end:(NSString*)end room:(Room*)room author:(NSString*)author subject:(NSString*)subject;

+ (void)addSensorWithId: (NSString*)idSensor eventDate:(NSDate*)eventDate eventValue:(NSString*) eventValue forRoom:(Room*)room;

// UPDATE

+ (BOOL)checkSensorWithId: (NSString*)idSensor eventDate:(NSDate*)eventDate eventValue:(NSString*)eventValue;

// SET LOCAL JSON

+ (void)loadDatabase:(BOOL)needReset;

+ (void)setSensorsWithReset:(BOOL)needReset;

+ (void)setRoomsWithReset:(BOOL)needReset;

+ (void)setEquipmentWithReset:(BOOL)needReset;

+ (void)setRoomSensor;

+ (void)setRoomEquipment;

// DELETE

+ (void)deletePlanning;

+ (void)deleteAllRooms;

+ (void)deleteAllReservations;

+ (void)deleteAllEquipments;

+ (void)deleteAllSensors;

+ (void)deleteReservationWithBegin:(NSString*)begin;

+ (void)deleteReservationsFromRoom:(Room*)room;

@end
