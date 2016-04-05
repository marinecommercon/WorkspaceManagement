//
//  DAO.m
//  WorkspaceManagement
//
//  Created by Lyess on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "DAO.h"
#import "AppDelegate.h"

@implementation DAO


+ (NSManagedObjectContext *)getContext {
    id delegate = [[UIApplication sharedApplication]delegate];
    return [delegate managedObjectContext];
}

+ (void) saveContext {
    NSError *saveError = nil;
    [[self getContext] save:&saveError];
}

+ (NSManagedObject*) getInstance:(NSString*) type {
    return [NSEntityDescription insertNewObjectForEntityForName:type inManagedObjectContext:[self getContext]];
}

+ (NSEntityDescription *) getEntityDescription:(NSString *)type {
    return [NSEntityDescription entityForName:type inManagedObjectContext:[self getContext]];
}


+ (NSArray *)getObjects:(NSString *)type withPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [self getEntityDescription:type];
    [request setEntity:entityDesc];
    
    if(predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error;
    NSArray *objects = [[self getContext] executeFetchRequest:request error:&error];
    
    if([objects count] == 0) {
        return nil;
    }
    return objects;
}

+ (NSManagedObject *)getObject:(NSString *)type withPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [self getEntityDescription:type];
    [request setEntity:entityDesc];
    
    if(predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error;
    NSArray *objects = [[self getContext] executeFetchRequest:request error:&error];
    
    if([objects count] == 0) {
        return nil;
    }
    return [objects objectAtIndex:0];
}

+ (NSArray *)getObjects:(NSString *)type withNot:(NSArray *)array {
    
    NSMutableArray *completeArray = [NSMutableArray arrayWithArray:[self getObjects:type withPredicate:nil]];
    
    if(array) {
        for (NSManagedObject *obj in array) {
            if ([completeArray containsObject:obj]) {
                [completeArray removeObject:obj];
            }
        }
    }
    
    return [NSArray arrayWithArray:completeArray];
}

+ (void)deleteObject:(NSManagedObject *)object {
    [[self getContext] deleteObject:object];
    [self saveContext];
}

+ (void)deleteAllObjects:(NSArray *)managedObjects {
    for (NSManagedObject * mo in managedObjects) {
        [[self getContext] deleteObject:mo];
    }
    [self saveContext];
}

/*
 * * * * * * * * * * * * * * * * * * * *
 * * * * *  HANDLE PLANNING * * * * * *
 * * * * * * * * * * * * * * * * * * * *
 */

+ (void)addRoomsForPlanning{
    [self addRoomWithName:@"Espace partagé"          IdMapwize:@"56d5cb01ac5a950b003c89ad"];
    [self addRoomWithName:@"Espace de concentration" IdMapwize:@"56d5ca7fac5a950b003c89a7"];
    [self addRoomWithName:@"Salle de réunion"        IdMapwize:@"56d5ca6dac5a950b003c89a5"];
    [self addRoomWithName:@"Café de l'Innovation"    IdMapwize:@"56d5ca45ac5a950b003c89a3"];
    [self addRoomWithName:@"La fabrique à solutions" IdMapwize:@"56d5ca97ac5a950b003c89a9"];
    [self addRoomWithName:@"Salle pitch"             IdMapwize:@"56d5cae2ac5a950b003c89ab"];
}

/*
 * * * * * * * * * * * * * * * * * * * *
 * * * * * * GETTERS SETTERS * * * * * *
 * * * * * * * * * * * * * * * * * * * *
 */

+ (Room*)getRoomById: (NSString*) idMapwize {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idMapwize == %@", idMapwize];
    NSManagedObject * mo = [self getObject:@"Room" withPredicate:predicate];
    
    if ([[[mo entity]name] isEqualToString:@"Room"]) {
        Room *roomTemp = (Room*)mo;
        return roomTemp;
    }
    else{
        NSLog(@"Room with id %@ not found", idMapwize);
        return nil;
    }
}

+ (void)addRoomWithName:(NSString*)name IdMapwize:(NSString*)idMapwize {
    Room* roomTemp = (Room*)[self getInstance:@"Room"];
    [roomTemp setIdMapwize: idMapwize];
    [roomTemp setName:name];
    [self saveContext];
}

+ (void)addReservationWithBegin:(NSString*)begin forRoom:(Room*)room {
    Reservation* reservationTemp = (Reservation*)[self getInstance:@"Reservation"];
    NSDate *beginDate = [Utils parseTimeToDate:begin];
    NSDate *endDate   = [beginDate dateByAddingTimeInterval:(30*60)];
    [reservationTemp setBeginTime:beginDate];
    [reservationTemp setEndTime:endDate];
    [room addReservationsObject:reservationTemp];
    [self saveContext];
}

+ (NSArray*)getAllRoomsName {
    NSMutableArray *roomsName = [[NSMutableArray alloc] init];
    NSArray *rooms = [self getObjects:@"Room" withPredicate:nil];
    for (Room *room in rooms){
        [roomsName addObject:room.name];
    }
    return roomsName;
}

/*
 * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * DELETIONS * * * * * *
 * * * * * * * * * * * * * * * * * * * *
 */

+ (void) deletePlanning {
    [self deleteAllRooms];
    [self deleteAllReservations];
}

+ (void)deleteAllRooms {
    NSArray   *listRooms = [self getObjects:@"Room" withPredicate:nil];
    for (Room *room in listRooms) {
        [[self getContext] deleteObject:room];
        [self saveContext];
    }
}

+ (void)deleteAllReservations {
    NSArray   *listRooms = [self getObjects:@"Room" withPredicate:nil];
    for(Room *room in listRooms){
        [self deleteReservationsFromRoom:room];
    }
}

+ (void)deleteReservationWithBegin: (NSString*) begin {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"beginTime == %@", [Utils parseTimeToDate:begin]];
    NSManagedObject * objectTemp = [self getObject:@"Reservation" withPredicate:predicate];
    [self deleteObject:objectTemp];
    [self saveContext];
}

+ (void)deleteReservationsFromRoom: (Room*) room {
    NSSet *reservations = room.reservations;
    [room removeReservations:reservations];
    [self saveContext];
}



/*
 * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * LOGS * * * * * * * *
 * * * * * * * * * * * * * * * * * * * *
 */

+ (void) logDate: (NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSLog(@"Date saved is %@",[formatter stringFromDate:date]);
}

+ (void) logReservation: (NSDate*)beginDate withEnd:(NSDate*)endDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSLog(@"Reservation %@ - %@",[formatter stringFromDate:beginDate],[formatter stringFromDate:endDate]);
}

+ (void) logAllRooms {
    NSArray *rooms = [self getObjects:@"Room" withPredicate:nil];
    if(rooms.count != 0){
        for (Room *room in rooms) {
            NSLog(@"room with name : %@", room.name);
        }
    }
}

+ (void) logAllReservations {
    NSArray *rooms = [self getObjects:@"Room" withPredicate:nil];
    if(rooms.count != 0){
        for (Room *room in rooms) {
            if(room.reservations.count != 0){
                for (Reservation *reservation in room.reservations) {
                    [self logReservation:reservation.beginTime withEnd:reservation.endTime];
                }
            } else {            }
        }
    }
}

/*
 * * * * * * * * * * * * * * * * * * * *
 * * * * * * LOGICAL METHODS * * * * * *
 * * * * * * * * * * * * * * * * * * * *
 */

+ (BOOL) checkAvailability: (NSDate*)beginDateWished withEnd:(NSDate*)endDateWished withRoom:(Room*)room {
    
    if(room.reservations.count != 0){
        for (Reservation *reservation in room.reservations) {
            
            //[self logReservation:beginDateWished withEnd:endDateWished];
            //[self logReservation:reservation.beginTime withEnd:reservation.endTime];
            
            // The wish is before the reservation
            if([reservation.beginTime timeIntervalSinceDate:beginDateWished]>0 &&
               [reservation.beginTime timeIntervalSinceDate:endDateWished]>=0){
                //NSLog(@"The wish is before the reservation");
            }
            
            // The wish is after the reservation
            else if([beginDateWished timeIntervalSinceDate:reservation.endTime]>=0 &&
                    [endDateWished timeIntervalSinceDate:reservation.endTime]>0){
                //NSLog(@"The wish is after the reservation");
            }
            
            // If for one reservation there is a conflict, the room is not available. Process stops.
            else {
                //NSLog(@"The wish is inside the reservation");
                return false;
            }
        }
    }
    return true;
}

+ (BOOL) checkAvailability: (NSString*)beginStringWished End:(NSString*)endStringWished Room:(Room*)room {
    
    NSDate *beginDateWished = [Utils parseTimeToDate:beginStringWished];
    NSDate *endDateWished   = [Utils parseTimeToDate:endStringWished];
    
    if(room.reservations.count != 0){
        for (Reservation *reservation in room.reservations) {
            
            //            [self logReservation:beginDateWished withEnd:endDateWished];
            //            [self logReservation:reservation.beginTime withEnd:reservation.endTime];
            
            // The wish is before the reservation
            if([reservation.beginTime timeIntervalSinceDate:beginDateWished]>0 &&
               [reservation.beginTime timeIntervalSinceDate:endDateWished]>=0){
                //NSLog(@"The wish is before the reservation");
            }
            
            // The wish is after the reservation
            else if([beginDateWished timeIntervalSinceDate:reservation.endTime]>=0 &&
                    [endDateWished timeIntervalSinceDate:reservation.endTime]>0){
                //NSLog(@"The wish is after the reservation");
            }
            
            // If for one reservation there is a conflict, the room is not available. Process stops.
            else {
                //NSLog(@"The wish is inside the reservation");
                return false;
            }
        }
    }
    return true;
}


+ (BOOL) checkAvailability: (NSString*)beginTimeWished withEnd:(NSString*)endTimeWished {
    
    NSDate *beginDateWished = [Utils parseTimeToDate:beginTimeWished];
    NSDate *endDateWished   = [Utils parseTimeToDate:endTimeWished];
    int count = 0;
    NSMutableArray * possibilities = [NSMutableArray new];
    
    NSArray *listRooms = [self getObjects:@"Room" withPredicate:nil];
    if(listRooms.count != 0){
        for (Room *room in listRooms) {
            
            // If room available
            if([self checkAvailability:beginDateWished withEnd:endDateWished withRoom:room]){
                [possibilities addObject:room];
            } else {
                count++;
            }
        }
    }
    if(count == listRooms.count){
        return false;
    } else {
        for(Room *room in possibilities){
            NSLog(@"room %@ available", room.name);
        }
    }
    return true;
}



+ (int) getPossibleDurationForBeginTime:(NSString*)beginTime withRoom: (Room*) room {
    
    NSArray *sortedReservationArray = [Utils sortReservationsOfRoom:room];
    NSDate  *myWishDate             = [Utils parseTimeToDate:beginTime];
    int minutes   = 0;
    int halfHours = 0;
    
    // There must be at least one reservation
    if(sortedReservationArray.count != 0){
        
        // At this point, we don't know if there is one reservation or more
        // In both cases, it is possible to check the time before first reservation
        // And then to check the time after last reservation
        Reservation *firstReservation = [sortedReservationArray objectAtIndex:0];
        Reservation *lastReservation  = [sortedReservationArray objectAtIndex:sortedReservationArray.count-1];
        
        // Case : my wish is before the beginning of the reservation
        if([firstReservation.beginTime timeIntervalSinceDate:myWishDate] >=0){
            minutes = [self getMaxTimeBeforeFirstReservation:myWishDate withTime:firstReservation.beginTime];
            halfHours = floorf(minutes/30);
            return halfHours;
        }
        
        // Case : my wish is after the end of the last reservation
        else if([myWishDate timeIntervalSinceDate:lastReservation.endTime] >= 0){
            minutes = [self getMaxTimeAfterLastReservation:myWishDate];
            halfHours = floorf(minutes/30);
            return halfHours;
        }
        
        // If more than one reservation
        // Check the time between two reservations
        else if(sortedReservationArray.count>1){
            
            for(int i = 0 ; i < sortedReservationArray.count-1 ; i++){
                
                Reservation *reservation1 = [sortedReservationArray objectAtIndex:i];
                Reservation *reservation2 = [sortedReservationArray objectAtIndex:i+1];
                
                // Case between 2 reservations
                if([myWishDate timeIntervalSinceDate:reservation1.endTime] >= 0 && [myWishDate timeIntervalSinceDate: reservation2.beginTime] <= 0){
                    double duration = [reservation2.beginTime timeIntervalSinceDate:myWishDate];
                    halfHours = floorf(duration/1800);
                    return halfHours;
                }
            }
        }
    }
    
    // If no reservation
    // Set the difference between 21h and beginTime
    else {
        NSDate  *endDate = [Utils parseTimeToDate:@"21:00"];
        double duration  = [endDate timeIntervalSinceDate:myWishDate];
        halfHours = floorf(duration/1800);
    }
    
    return halfHours;
}

+ (double) getMaxTimeBeforeFirstReservation:(NSDate*)myWishDate withTime:(NSDate*) beginDate {
    double minutes = 0.0;
    if(myWishDate < [Utils parseTimeToDate:@"07:30"]){
        double duration = [beginDate  timeIntervalSinceDate:[Utils parseTimeToDate:@"07:30"]];
        minutes = floor(duration/60);
        return minutes;
    }
    else {
        double duration = [beginDate  timeIntervalSinceDate:myWishDate];
        double minutes = floor(duration/60);
        return minutes;
    }
}

+ (double) getMaxTimeAfterLastReservation:(NSDate*)myWishDate {
    double minutes = 0.0;
    if(myWishDate > [Utils parseTimeToDate:@"21:00"]){
        return minutes;
    }
    else {
        double duration = [[Utils parseTimeToDate:@"21:00"]  timeIntervalSinceDate:myWishDate];
        minutes = floor(duration/60);
        return minutes;
    }
    
}

+ (double) getMaxDurationForBeginTime:(NSString*)beginTime {
    NSArray *listRooms = [self getObjects:@"Room" withPredicate:nil];
    double maxDurationTemp = 0;
    
    if(listRooms.count != 0){
        for (Room *room in listRooms) {
            double possibleDuration = [self getPossibleDurationForBeginTime:beginTime withRoom:room];
            if(possibleDuration > maxDurationTemp){
                maxDurationTemp = possibleDuration;
            }
        }
    }
    return maxDurationTemp;
}

+ (BOOL)getCurrentStateForRoom:(NSString*)idMapwize {
    Room   *room = [self getRoomById:idMapwize];
    NSDate *currentDate     = [NSDate date];
    NSDate *minuteAfterDate = [currentDate dateByAddingTimeInterval:(60)];
    
    BOOL available = [self checkAvailability:currentDate withEnd:minuteAfterDate withRoom:room];
    
    //NSString *test1 = [Utils parseDateToTime:currentDate];
    //NSString *test2 = [Utils parseDateToTime:minuteAfterDate];
    //BOOL available2 = [self checkAvailability:test1 End:test2 Room:room];
    
    return available;
}

+ (BOOL)getStateForRoom:(NSString*)idMapwize time:(NSString*)time timeInterval:(int)interval {
    Room   *room              = [self getRoomById:idMapwize];
    NSDate *chosenDate        = [Utils parseTimeToDate:time];
    NSDate *intervalAfterDate = [chosenDate dateByAddingTimeInterval:interval];
    
    BOOL available = [self checkAvailability:chosenDate withEnd:intervalAfterDate withRoom:room];
    
    return available;
}

@end