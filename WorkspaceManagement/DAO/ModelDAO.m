//
//  ModelDAO.m
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ModelDAO.h"

@implementation ModelDAO

// GET

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

+ (NSArray*)getAllRoomsName {
    NSMutableArray *roomsName = [[NSMutableArray alloc] init];
    NSArray *rooms = [DAO getObjects:@"Room" withPredicate:nil];
    for (Room *room in rooms){
        [roomsName addObject:room.name];
    }
    return roomsName;
}

+ (NSArray*)getAllSensorsId {
    NSMutableArray *sensorsId = [[NSMutableArray alloc] init];
    NSArray *sensors = [DAO getObjects:@"Sensor" withPredicate:nil];
    for (Sensor *sensor in sensors){
        [sensorsId addObject:sensor.idSensor];
    }
    return sensorsId;
}

// ADD

+ (void)addRoomWithName:(NSString*)name IdMapwize:(NSString*)idMapwize {
    Room* roomTemp = (Room*)[DAO getInstance:@"Room"];
    [roomTemp setIdMapwize: idMapwize];
    [roomTemp setName:name];
    [DAO saveContext];
}

+ (void)addReservationWithBegin:(NSString*)begin forRoom:(Room*)room {
    Reservation* reservationTemp = (Reservation*)[DAO getInstance:@"Reservation"];
    NSDate *beginDate = [Utils parseTimeToDate:begin];
    NSDate *endDate   = [beginDate dateByAddingTimeInterval:(30*60)];
    [reservationTemp setBeginTime:beginDate];
    [reservationTemp setEndTime:endDate];
    [room addReservationsObject:reservationTemp];
    [DAO saveContext];
}

+ (void)addSensorWithId: (NSString*)idSensor eventDate:(NSDate*)eventDate eventValue:(NSString*) eventValue forRoom:(Room*)room {
    Sensor* sensorTemp = (Sensor*)[DAO getInstance:@"Sensor"];
    [sensorTemp setIdSensor:idSensor];
    [sensorTemp setEventDate:eventDate];
    [sensorTemp setEventValue:eventValue];
    [room addSensorsObject:sensorTemp];
    [DAO saveContext];
}

// UPDATE

+ (BOOL)checkSensorWithId: (NSString*)idSensor eventDate:(NSDate*)eventDate eventValue:(NSString*)eventValue {
    
    Sensor* sensorTemp = [self getSensorById:idSensor];
    BOOL updateWasNeeded = false;
    
    if(![sensorTemp.eventValue isEqualToString:eventValue]){
        [sensorTemp setEventDate:eventDate];
        [sensorTemp setEventValue:eventValue];
        [DAO saveContext];
        updateWasNeeded = true;
        //NSLog(@"Update sensor %@", sensorTemp.idSensor);
    } else {
        
        //NSLog(@"No need to update sensor %@", sensorTemp.idSensor);
        updateWasNeeded = false;
        // Fake to test changes on Map
        
//        if([eventValue isEqualToString:@"1"]){
//            [sensorTemp setEventDate:eventDate];
//            [sensorTemp setEventValue:@"0"];
//            [DAO saveContext];
//            updateWasNeeded = true;
//        }
//        else {
//            [sensorTemp setEventDate:eventDate];
//            [sensorTemp setEventValue:@"1"];
//            [DAO saveContext];
//            updateWasNeeded = true;
//        }
    }
    return updateWasNeeded;
}

// SET LOCAL JSON

+ (void)loadDatabase:(BOOL)needReset{
    
    // Rooms creation -> Sensors creation -> Pairs
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

// DELETE

+ (void)deletePlanning {
    [self deleteAllRooms];
    [self deleteAllReservations];
}

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

+ (void)deleteReservationWithBegin: (NSString*) begin {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"beginTime == %@", [Utils parseTimeToDate:begin]];
    NSManagedObject * objectTemp = [DAO getObject:@"Reservation" withPredicate:predicate];
    [DAO deleteObject:objectTemp];
    [DAO saveContext];
}

+ (void)deleteReservationsFromRoom: (Room*) room {
    NSSet *reservations = room.reservations;
    [room removeReservations:reservations];
    [DAO saveContext];
}

@end
