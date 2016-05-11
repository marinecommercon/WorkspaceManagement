//
//  ModelDAO.m
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ModelDAO.h"
#import "Constants.h"

@implementation ModelDAO


#pragma mark GET

// TODO : all get<Entity>By<Property> should be move to its class.

+ (NSManagedObject *)_getObjectOfType:(NSString *)type withProperty:(NSString *)property equalsTo:(NSString*)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", property, value];
    NSManagedObject * mo = [DAO getObject:type withPredicate:predicate];
    
    if( [mo.entity.name isEqualToString:type] )
        return mo;
    else
    {
        NSLog(@"%@ with (%@ == %@) not found", type, property, value);
        return nil;
    }
}

+ (Room *)roomWithId:(NSString*)idMapwize
{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idMapwize == %@", idMapwize];
//    NSManagedObject * mo = [DAO getObject:@"Room" withPredicate:predicate];
//    
//    if( [mo.entity.name isEqualToString:@"Room"] )
//        return (Room*)mo;
//    else
//    {
//        NSLog(@"Room with id %@ not found", idMapwize);
//        return nil;
//    }
    
    return (Room *)[self _getObjectOfType:kDAORoomEntity withProperty:kDAORoomId equalsTo:idMapwize];
}

// This method is used by the PopupDetailViewController and the FilterViewController
// It returns the equipment from database by its keyword (retro, screen, table or dock)

+ (Equipment *)equipmentWithKey:(NSString *)key
{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@", key];
//    NSManagedObject * mo = [DAO getObject:@"Equipment" withPredicate:predicate];
//    
//    if( [mo.entity.name isEqualToString:@"Equipment"] )
//       return (Equipment*)mo;
//    else
//    {
//        NSLog(@"Equipment with key %@ not found", key);
//        return nil;
//    }
    
    return (Equipment *)[self _getObjectOfType:kDAOEquipmentEntity withProperty:kDAOEquipmentKey equalsTo:key];
}

+ (Sensor *)sensorWithId:(NSString *)idSensor
{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idSensor == %@", idSensor];
//    NSManagedObject * mo = [DAO getObject:@"Sensor" withPredicate:predicate];
//    
//    if ([[[mo entity]name] isEqualToString:@"Sensor"]) {
//        Sensor *sensorTemp = (Sensor*)mo;
//        return sensorTemp;
//    }
//    else{
//        NSLog(@"Sensor with id %@ not found", idSensor);
//        return nil;
//    }
    
    return (Sensor *)[self _getObjectOfType:kDAOSensorEntity withProperty:kDAOSensorId equalsTo:idSensor];
}

// This method is used for the webservice

+ (NSArray*)allSensorsId
{
//    NSMutableArray *sensorsId = [[NSMutableArray alloc] init];
//    NSArray *sensors = [DAO getObjects:@"Sensor" withPredicate:nil];
//    for (Sensor *sensor in sensors){
//        [sensorsId addObject:sensor.idSensor];
//    }
//    return sensorsId;
    
    return [[DAO getObjects:kDAOSensorEntity withPredicate:nil] valueForKey:kDAOSensorId];
}

// DSIViewController :  When the cell shows a reservation, this method let it know the corresponding type of a reservation, if existing

// Type for reservation made by the user in the app but not confirmed : app-initial
// Type for reservation made by the user in the app and confirmed : app-confirmed
// Type for a reservation made through the DSI view : dsi

+ (Reservation *)reservationForBegin:(NSString *)beginTime
                                room:(Room *)room
{
    NSArray *sortedReservationArray = [Utils sortReservationsOfRoom:room.reservations];
    NSDate  *beginDate              = [Utils parseTimeToDate:beginTime];
    NSDate  *endDate                = [beginDate dateByAddingTimeInterval:(30*60)];;
    
    // There must be at least one reservation
    if( sortedReservationArray.count != 0 )
    {
        for(Reservation *reservation in sortedReservationArray)
        {
            NSDate *resaBegin = [Utils parseTimeToDate:reservation.beginTime];
            NSDate *resaEnd   = [Utils parseTimeToDate:reservation.endTime];
            
            // Case : my wish is before the beginning of the reservation
            if( [beginDate timeIntervalSinceDate:resaBegin] >= 0 && [resaEnd timeIntervalSinceDate:endDate] >= 0 )
                return reservation;
        }
    }
    
    return nil;
}


#pragma mark ADD

// DSIViewController : add reservations for the selected cells
// Reservation ViewController : add the reservation made by user

+ (Reservation *)addReservation:(NSString *)begin
                            end:(NSString *)end
                           room:(Room *)room
                         author:(NSString *)author
                        subject:(NSString *)subject
                           type:(NSString *)type
{
    Reservation* reservationTemp = (Reservation*)[DAO newInstance:kDAOReservationEntity];
    
    reservationTemp.beginTime   = begin;
    reservationTemp.endTime     = end;
    reservationTemp.type        = type;
    reservationTemp.author      = author;
    reservationTemp.subject     = subject;
    
    [room addReservationsObject:reservationTemp];
    
    [DAO saveContext];
    
    return reservationTemp;
}

#pragma mark UPDATE SENSOR
// This method will check if the value of sensor downloaded is the same
// than the value previously stored in database.
// It returns true if the map should be updated

+ (BOOL)checkSensorWithId:(NSString *)idSensor
                eventDate:(NSDate *)eventDate
               eventValue:(NSString *)eventValue
{
    Sensor* sensorTemp = [self sensorWithId:idSensor];
    BOOL updateWasNeeded = false;
    
    if( ![sensorTemp.eventValue isEqualToString:eventValue] )
    {
        sensorTemp.eventDate = eventDate;
        sensorTemp.eventValue = eventValue;
        
        [DAO saveContext];
        updateWasNeeded = true;
    }

    return updateWasNeeded;
}

#pragma mark SET DATABASE

// When calling resetDatabase, for each entity :
// If [needReset == true  && some entities in DB]  => delete + read Json
// If [needReset == true  && no entities in DB]  => read Json only
// If [needReset == false && some entities in DB] => do nothing
// If [needReset == false && no entities in DB] => read Json only

+ (void)resetDatabase:(BOOL)needReset
{
    // First  : it will set rooms
    // Second : it will set sensors
    // Third  : it will set equipments
    // Fourth : it will set room-sensors pairs
    // Fifth  : it will set room-sensors pairs
    
    [self setRoomsWithReset:needReset];
    [self setSensorsWithReset:needReset];
    [self setEquipmentWithReset:needReset];
    [self setRoomSensor];
    [self setRoomEquipment];
}

+ (void)setRoomsWithReset:(BOOL)needReset
{
    if( needReset )
        [self deleteAllRooms];

    NSArray *listRooms = [DAO getObjects:kDAORoomEntity withPredicate:nil];
    
    if( listRooms.count == 0 )
    {
        NSMutableArray *rooms = [Utils jsonWithPath:@"rooms"];
        
        for(NSDictionary *dico in rooms)
        {
            Room *room = (Room *)[DAO newInstance:kDAORoomEntity];
            
            room.name      = dico[kDAORoomName];
            room.idMapwize = dico[kDAORoomId];
            room.maxPeople = dico[@"maxPeople"];
            room.type      = dico[@"type"];
            room.infoRoom  = dico[@"infoRoom"];
            room.mapState  = dico[@"mapState"];
        }

        [DAO saveContext];
    }
}

+ (void)setSensorsWithReset:(BOOL)needReset
{
    if( needReset )
        [self deleteAllSensors];
    
    NSArray *listSensors = [DAO getObjects:kDAOSensorEntity withPredicate:nil];
    
    if( listSensors.count == 0 )
    {
        NSMutableArray *sensors = [Utils jsonWithPath:@"sensors"];
        
        for(NSDictionary *dico in sensors)
        {
            Sensor* sensor = (Sensor*)[DAO newInstance:kDAOSensorEntity];
            
            sensor.idSensor     = dico[kDAOSensorId];
            sensor.eventDate    = NSDate.date;
            sensor.eventValue   = dico[@"eventValue"];
        }
        
        [DAO saveContext];
    }
}

+ (void)setEquipmentWithReset:(BOOL)needReset
{
    if( needReset )
       [self deleteAllEquipments];
 
    NSArray *listEquipments = [DAO getObjects:kDAOEquipmentEntity withPredicate:nil];
    
    if( listEquipments.count == 0 )
    {
        NSMutableArray *equipments = [Utils jsonWithPath:@"equipments"];
        
        for(NSDictionary *dico in equipments)
        {
            Equipment* equipment = (Equipment*)[DAO newInstance:kDAOEquipmentEntity];
            
            equipment.key           = dico[kDAOEquipmentKey];
            equipment.name          = dico[@"name"];
            equipment.filterState   = dico[kDAOEquipmentFilterState];
        }
        
        [DAO saveContext];
    }
}

+ (void)setRoomSensor
{
    NSMutableArray *roomSensors = [Utils jsonWithPath:@"roomsensor"];
    
//    id lastRoomId;
//    Room *currentRoom = nil;
//    NSDictionary  *pair;
    
    for( NSDictionary *pair in roomSensors )
    {
        Room *room     = [self roomWithId:pair[@"idRoom"]];
        Sensor *sensor = [self sensorWithId:pair[kDAOSensorId]];
        [room addSensorsObject:sensor];
        
////        pair = [roomSensor objectAtIndex:i];
//        
//        id valueRoom   = pair[@"idRoom"];
//        id valueSensor = pair[@"idSensor"];
//        
//        if( ![valueRoom isEqual:lastRoomId] )
////        {
////            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idMapwize == %@", valueRoom];
////            currentRoom = (Room*)[DAO getObject:@"Room" withPredicate:predicate];
////        }
//            currentRoom = [self roomWithId:valueRoom];
//
////        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idSensor == %@", valueSensor];
////        Sensor *sensor = (Sensor *)[DAO getObject:@"Sensor" withPredicate:predicate];
//        Sensor *sensor = [self sensorWithId:valueSensor];
//        
//        [currentRoom addSensorsObject:sensor];
//        
//        lastRoomId = valueRoom;
    }
    
    [DAO saveContext];
}

+ (void)setRoomEquipment
{
    NSMutableArray *roomEquipments = [Utils jsonWithPath:@"roomequipment"];
    
//    id lastRoomId;
//    Room *currentRoom = nil;
//    NSDictionary  *pair;
    
    for( NSDictionary  *pair in roomEquipments )
    {
        Room *room     = [self roomWithId:pair[@"idRoom"]];
        Equipment *equipment = [self equipmentWithKey:pair[kDAOEquipmentKey]];
        [room addEquipmentsObject:equipment];

//        //        pair = [roomEquipment objectAtIndex:i];
//        id valueRoom      = pair[@"idRoom"];
//        id valueEquipment = pair[@"key"];
//        
//        if( ![valueRoom isEqual:lastRoomId] )
////        {
////            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idMapwize == %@", valueRoom];
////            currentRoom = (Room*)[DAO getObject:@"Room" withPredicate:predicate];
////        }
//        currentRoom = [self roomWithId:valueRoom];
//
////        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@", valueEquipment];
////        Equipment *equipment = (Equipment *)[DAO getObject:@"Equipment" withPredicate:predicate];
//        Equipment *equipment = [self equipmentWithKey:valueEquipment];
//        
//        [currentRoom addEquipmentsObject:equipment];
//        
//        lastRoomId = valueRoom;
//        NSLog(@"room %@: equipment #%d", room.idMapwize, room.equipments.count);
    }
    
    [DAO saveContext];
}

#pragma mark DELETE

+ (void)_deleteAllObjectsForEntity:(NSString *)entityName
{
    NSManagedObjectContext *context = [DAO getContext];
    NSArray *listObjects = [DAO getObjects:entityName withPredicate:nil];
    
    for( NSManagedObject *o in listObjects)
        [context deleteObject:o];
    
    [DAO saveContext];
}

+ (void)deleteAllRooms
{
//    NSManagedObjectContext *context = [DAO getContext];
//    NSArray *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
//    
//    for( Room *room in listRooms)
//        [context deleteObject:room];
//
//    [DAO saveContext];
    
    [self _deleteAllObjectsForEntity:kDAORoomEntity];
}

+ (void)deleteAllReservations
{
//    NSArray *listRooms = [DAO getObjects:@"Room" withPredicate:nil];
//    
//    for( Room *room in listRooms)
//        [self deleteReservationsFromRoom:room];
//    
//    // No need to call saveContext because deleteReservationsFromRoom does it.
    
    [self _deleteAllObjectsForEntity:kDAOReservationEntity];
}


+ (void)deleteAllSensors
{
//    NSManagedObjectContext *context = [DAO getContext];
//    NSArray *listSensors = [DAO getObjects:@"Sensor" withPredicate:nil];
//    
//    for( Sensor *sensor in listSensors)
//        [context deleteObject:sensor];
//    
//    [DAO saveContext];

    [self _deleteAllObjectsForEntity:kDAOSensorEntity];
}

+ (void)deleteAllEquipments
{
//    NSManagedObjectContext *context = [DAO getContext];
//    NSArray   *listEquipments = [DAO getObjects:@"Equipment" withPredicate:nil];
//    
//    for (Equipment *equipment in listEquipments)
//        [context deleteObject:equipment];
//    
//    [DAO saveContext];
    
    [self _deleteAllObjectsForEntity:kDAOEquipmentEntity];
}

// In DSI ViewController : Before saving modifications for a room, delete all reservations
// Then add, line by line, each reservation
+ (void)deleteReservationsFromRoom:(Room *)room
{
//    [room removeReservations:room.reservations];
    room.reservations = nil;
    [DAO saveContext];
}

@end
