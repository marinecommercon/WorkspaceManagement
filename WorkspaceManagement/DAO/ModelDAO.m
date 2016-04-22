//
//  ModelDAO.m
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ModelDAO.h"

@implementation ModelDAO


#pragma mark GET

+ (Room*)getRoomById: (NSString*) idMapwize {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idMapwize == %@", idMapwize];
    NSManagedObject * mo = [DAO getObject:@"Room" withPredicate:predicate];
    
    if ([[[mo entity]name] isEqualToString:@"Room"]) {
        Room *roomTemp = (Room*)mo;
        return roomTemp;
    }
    else{
        NSLog(@"Room with id %@ not found", idMapwize);
        return nil;
    }
}

// This method is used by the PopupDetailViewController and the FilterViewController
// It returns the equipment from database by its keyword (retro, screen, table or dock)

+ (Equipment*)getEquipmentByKey:(NSString*)key {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@", key];
    NSManagedObject * mo = [DAO getObject:@"Equipment" withPredicate:predicate];
    
    if ([[[mo entity]name] isEqualToString:@"Equipment"]) {
        Equipment *equipmentTemp = (Equipment*)mo;
        return equipmentTemp;
    }
    else{
        NSLog(@"Equipment with key %@ not found", key);
        return nil;
    }
}

+ (Sensor*)getSensorById: (NSString*) idSensor {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idSensor == %@", idSensor];
    NSManagedObject * mo = [DAO getObject:@"Sensor" withPredicate:predicate];
    
    if ([[[mo entity]name] isEqualToString:@"Sensor"]) {
        Sensor *sensorTemp = (Sensor*)mo;
        return sensorTemp;
    }
    else{
        NSLog(@"Sensor with id %@ not found", idSensor);
        return nil;
    }
}

// This method is used for the webservice

+ (NSArray*)getAllSensorsId {
    NSMutableArray *sensorsId = [[NSMutableArray alloc] init];
    NSArray *sensors = [DAO getObjects:@"Sensor" withPredicate:nil];
    for (Sensor *sensor in sensors){
        [sensorsId addObject:sensor.idSensor];
    }
    return sensorsId;
}

// DSIViewController :  When the cell shows a reservation, this method let it know the corresponding type of a reservation, if existing

// Type for reservation made by the user in the app but not confirmed : app-initial
// Type for reservation made by the user in the app and confirmed : app-confirmed
// Type for a reservation made through the DSI view : dsi

+ (Reservation*)getReservationForBegin:(NSString*)beginTime room: (Room*)room {
    NSArray *sortedReservationArray = [Utils sortReservationsOfRoom:room.reservations];
    NSDate  *beginDate              = [Utils parseTimeToDate:beginTime];
    NSDate  *endDate                = [beginDate dateByAddingTimeInterval:(30*60)];;
    
    // There must be at least one reservation
    if(sortedReservationArray.count != 0){
        for(Reservation *reservation in sortedReservationArray){
            NSDate *resaBegin = [Utils parseTimeToDate:reservation.beginTime];
            NSDate *resaEnd   = [Utils parseTimeToDate:reservation.endTime];
            
            // Case : my wish is before the beginning of the reservation
            if([beginDate timeIntervalSinceDate:resaBegin] >=0 && [resaEnd timeIntervalSinceDate:endDate] >=0){
                return reservation;
            }
        }
    }
    return nil;
}


#pragma mark ADD

// DSIViewController : add reservations for the selected cells
// Reservation ViewController : add the reservation made by user

+ (void)addReservation:(NSString*)begin end:(NSString*)end room:(Room*)room author:(NSString*)author subject:(NSString*)subject type:(NSString*)type {
    Reservation* reservationTemp = (Reservation*)[DAO getInstance:@"Reservation"];
    [reservationTemp setBeginTime:begin];
    [reservationTemp setEndTime:end];
    [reservationTemp setType:type];
    [reservationTemp setAuthor:author];
    [reservationTemp setSubject:subject];
    [room addReservationsObject:reservationTemp];
    [DAO saveContext];
}

#pragma mark UPDATE SENSOR
// This method will check if the value of sensor downloaded is the same
// than the value previously stored in database.
// It returns true if the map should be updated

+ (BOOL)checkSensorWithId: (NSString*)idSensor eventDate:(NSDate*)eventDate eventValue:(NSString*)eventValue {
    
    Sensor* sensorTemp = [self getSensorById:idSensor];
    BOOL updateWasNeeded = false;
    
    if(![sensorTemp.eventValue isEqualToString:eventValue]){
        [sensorTemp setEventDate:eventDate];
        [sensorTemp setEventValue:eventValue];
        [DAO saveContext];
        updateWasNeeded = true;
    } else {
        updateWasNeeded = false;
    }
    return updateWasNeeded;
}

#pragma mark SET DATABASE

// When calling resetDatabase, for each entity :
// If [needReset == true  && some entities in DB]  => delete + read Json
// If [needReset == true  && no entities in DB]  => read Json only
// If [needReset == false && some entities in DB] => do nothing
// If [needReset == false && no entities in DB] => read Json only

+ (void)resetDatabase:(BOOL)needReset{
    
    // First  : it will set rooms
    // Second : it will set sensors
    // Third  : it will set equipments
    // Fourth : it will set room-sensors pairs
    // Fifth  : it will set room-sensors pairs
    [self setRoomsWithReset:needReset];
}

+(void)setRoomsWithReset:(BOOL)needReset{
    
    NSArray   *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
    if(needReset && [listRooms count] != 0){
        [self deleteAllRooms];
        NSMutableArray *rooms = [Utils jsonWithPath:@"rooms"];
        for(NSDictionary* dico in rooms){
            Room* room = (Room*)[DAO getInstance:@"Room"];
            [room setName:[dico valueForKey:@"name"]];
            [room setIdMapwize:[dico valueForKey:@"idMapwize"]];
            [room setMaxPeople:[dico valueForKey:@"maxPeople"]];
            [room setType:[dico valueForKey:@"type"]];
            [room setInfoRoom:[dico valueForKey:@"infoRoom"]];
            [room setMapState:[dico valueForKey:@"mapState"]];
            [DAO saveContext];
        }
        [self setSensorsWithReset:needReset];
    }
    
    if([listRooms count] == 0){
        NSMutableArray *rooms = [Utils jsonWithPath:@"rooms"];
        for(NSDictionary* dico in rooms){
            Room* room = (Room*)[DAO getInstance:@"Room"];
            [room setName:[dico valueForKey:@"name"]];
            [room setIdMapwize:[dico valueForKey:@"idMapwize"]];
            [room setMaxPeople:[dico valueForKey:@"maxPeople"]];
            [room setType:[dico valueForKey:@"type"]];
            [room setInfoRoom:[dico valueForKey:@"infoRoom"]];
            [room setMapState:[dico valueForKey:@"mapState"]];
            [DAO saveContext];
        }
        [self setSensorsWithReset:needReset];
    }
}

+(void)setSensorsWithReset:(BOOL)needReset{
    
    NSArray   *listSensors = [DAO getObjects:@"Sensor" withPredicate:nil];
    if(needReset && [listSensors count] != 0){
        [self deleteAllSensors];
        NSMutableArray *sensors = [Utils jsonWithPath:@"sensors"];
        for(NSDictionary* dico in sensors){
            Sensor* sensor = (Sensor*)[DAO getInstance:@"Sensor"];
            [sensor setIdSensor:[dico valueForKey:@"idSensor"]];
            [sensor setEventDate:[NSDate date]];
            [sensor setEventValue:[dico valueForKey:@"eventValue"]];
            [DAO saveContext];
        }
        [self setEquipmentWithReset:needReset];
    }
    
    if([listSensors count] == 0){
        NSMutableArray *sensors = [Utils jsonWithPath:@"sensors"];
        for(NSDictionary* dico in sensors){
            Sensor* sensor = (Sensor*)[DAO getInstance:@"Sensor"];
            [sensor setIdSensor:[dico valueForKey:@"idSensor"]];
            [sensor setEventDate:[NSDate date]];
            [sensor setEventValue:[dico valueForKey:@"eventValue"]];
            [DAO saveContext];
        }
        [self setEquipmentWithReset:needReset];
    }
}

+ (void)setEquipmentWithReset:(BOOL)needReset {
    
    NSArray   *listEquipments = [DAO getObjects:@"Equipment" withPredicate:nil];
    if(needReset && [listEquipments count] != 0){
        [self deleteAllEquipments];
        NSMutableArray *equipments = [Utils jsonWithPath:@"equipments"];
        for(NSDictionary* dico in equipments){
            Equipment* equipment = (Equipment*)[DAO getInstance:@"Equipment"];
            [equipment setKey:[dico valueForKey:@"key"]];
            [equipment setName:[dico valueForKey:@"name"]];
            [equipment setFilterState:[dico valueForKey:@"filterState"]];
            [DAO saveContext];
        }
        [self setRoomSensor];
    }
    
    if([listEquipments count] == 0){
        NSMutableArray *equipments = [Utils jsonWithPath:@"equipments"];
        for(NSDictionary* dico in equipments){
            Equipment* equipment = (Equipment*)[DAO getInstance:@"Equipment"];
            [equipment setKey:[dico valueForKey:@"key"]];
            [equipment setName:[dico valueForKey:@"name"]];
            [equipment setFilterState:[dico valueForKey:@"filterState"]];
            [DAO saveContext];
        }
        [self setRoomSensor];
    }
}

+ (void)setRoomSensor{
    NSMutableArray *roomSensor = [Utils jsonWithPath:@"roomsensor"];
    
    id lastRoomId;
    Room *currentRoom = nil;
    NSDictionary  *pair;
    
    for (int i = 0; i < [roomSensor count]; ++i) {
        pair = [roomSensor objectAtIndex:i];
        id valueRoom   = [pair objectForKey:@"idRoom"];
        id valueSensor = [pair objectForKey:@"idSensor"];
        
        if (![valueRoom isEqual:lastRoomId]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idMapwize == %@", valueRoom];
            currentRoom = (Room*)[DAO getObject:@"Room" withPredicate:predicate];
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idSensor == %@", valueSensor];
        Sensor *sensor = (Sensor *)[DAO getObject:@"Sensor" withPredicate:predicate];
        
        [currentRoom addSensorsObject:sensor];
        [DAO saveContext];
        lastRoomId = valueRoom;
    }
    [self setRoomEquipment];
}

+ (void)setRoomEquipment{
    NSMutableArray *roomEquipment = [Utils jsonWithPath:@"roomequipment"];
    
    id lastRoomId;
    Room *currentRoom = nil;
    NSDictionary  *pair;
    
    for (int i = 0; i < [roomEquipment count]; ++i) {
        pair = [roomEquipment objectAtIndex:i];
        id valueRoom      = [pair objectForKey:@"idRoom"];
        id valueEquipment = [pair objectForKey:@"key"];
        
        if (![valueRoom isEqual:lastRoomId]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idMapwize == %@", valueRoom];
            currentRoom = (Room*)[DAO getObject:@"Room" withPredicate:predicate];
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@", valueEquipment];
        Equipment *equipment = (Equipment *)[DAO getObject:@"Equipment" withPredicate:predicate];
        
        [currentRoom addEquipmentsObject:equipment];
        [DAO saveContext];
        lastRoomId = valueRoom;
    }
}

#pragma mark DELETE

+ (void)deleteAllRooms {
    NSArray   *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
    for (Room *room in listRooms) {
        [[DAO getContext] deleteObject:room];
        [DAO saveContext];
    }
}

+ (void)deleteAllReservations {
    NSArray   *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
    for(Room *room in listRooms){
        [self deleteReservationsFromRoom:room];
    }
}

+ (void)deleteAllSensors {
    NSArray   *listSensors = [DAO getObjects:@"Sensor" withPredicate:nil];
    for (Sensor *sensor in listSensors) {
        [[DAO getContext] deleteObject:sensor];
        [DAO saveContext];
    }
}

+ (void)deleteAllEquipments {
    NSArray   *listEquipments = [DAO getObjects:@"Equipment" withPredicate:nil];
    for (Equipment *equipment in listEquipments) {
        [[DAO getContext] deleteObject:equipment];
        [DAO saveContext];
    }
}

// In DSI ViewController : Before saving modifications for a room, delete all reservations
// Then add, line by line, each reservation
+ (void)deleteReservationsFromRoom: (Room*) room {
    NSSet *reservations = room.reservations;
    [room removeReservations:reservations];
    [DAO saveContext];
}

@end
