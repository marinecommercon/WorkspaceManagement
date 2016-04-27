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

#pragma mark GET

+ (Room *)getRoomById:(NSString *)idMapwize;

+ (Equipment *)getEquipmentByKey:(NSString *)key;

+ (Sensor *)getSensorById:(NSString *)idSensor;

+ (NSArray *)getAllSensorsId;

+ (Reservation *)getReservationForBegin:(NSString *)beginTime
                                   room:(Room *)room;

#pragma mark ADD

+ (void)addReservation:(NSString *)begin
                   end:(NSString *)end
                  room:(Room *)room
                author:(NSString *)author
               subject:(NSString *)subject
                  type:(NSString *)type;

#pragma mark UPDATE SENSORS

+ (BOOL)checkSensorWithId:(NSString *)idSensor
                eventDate:(NSDate *)eventDate
               eventValue:(NSString *)eventValue;

#pragma mark SET DATABASE

+ (void)resetDatabase:(BOOL)needReset;

+ (void)setSensorsWithReset:(BOOL)needReset;

+ (void)setRoomsWithReset:(BOOL)needReset;

+ (void)setEquipmentWithReset:(BOOL)needReset;

+ (void)setRoomSensor;

+ (void)setRoomEquipment;

#pragma mark DELETE

+ (void)deleteAllRooms;

+ (void)deleteAllReservations;

+ (void)deleteAllEquipments;

+ (void)deleteAllSensors;

+ (void)deleteReservationsFromRoom:(Room *)room;

@end
