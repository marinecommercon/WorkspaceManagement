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

+ (Sensor*)getSensorById:(NSString*)idSensor;

+ (NSArray*)getAllRoomsName;

// ADD

+ (void)addRoomWithName:(NSString*)name IdMapwize:(NSString*)idMapwize;

+ (void)addReservationWithBegin:(NSString*)begin forRoom:(Room*)room;

+ (void)addSensorWithId: (NSString*)idSensor eventDate:(NSDate*)eventDate eventValue:(NSString*) eventValue forRoom:(Room*)room;

// UPDATE

+ (void)updateSensorWithId: (NSString*)idSensor eventDate:(NSDate*)eventDate eventValue:(NSString*)eventValue;

// SET LOCAL JSON

+ (void)setSensorsWithReset:(BOOL)needReset;

+ (void)setRoomsWithReset:(BOOL)needReset;

+ (void)setRoomSensor;

// DELETE

+ (void)deletePlanning;

+ (void)deleteAllRooms;

+ (void)deleteAllReservations;

+ (void)deleteAllSensors;

+ (void)deleteReservationWithBegin:(NSString*)begin;

+ (void)deleteReservationsFromRoom:(Room*)room;

@end
