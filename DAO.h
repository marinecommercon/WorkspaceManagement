//
//  DAO.h
//  WorkspaceManagement
//
//  Created by Lyess on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"
#import "Reservation.h"
#import "Utils.h"

@interface DAO : NSObject

// GENERIC METHODS

+ (NSManagedObjectContext *)getContext;

+ (void)saveContext;

+ (NSManagedObject *)getInstance:(NSString*) type;

+ (NSEntityDescription *) getEntityDescription:(NSString *)type;

+ (NSArray *)getObjects:(NSString *)type withPredicate:(NSPredicate *)predicate;

+ (NSManagedObject *)getObject:(NSString *)type withPredicate:(NSPredicate *)predicate;

+ (void)deleteObject:(NSManagedObject *)object;

+ (void)deleteAllObjects:(NSArray *)managedObjects;

// HANDLE PLANNING

+ (void)addRoomsForPlanning;

// GETTERS SETTERS

+ (Room*)getRoomById:(NSString*)idMapwize;

+ (void)addRoomWithName:(NSString*)name IdMapwize:(NSString*)idMapwize;

+ (void)addReservationWithBegin:(NSString*)begin forRoom:(Room*)room;

+ (NSArray*)getAllRoomsName;

// DELETIONS

+ (void)deletePlanning;

+ (void)deleteAllRooms;

+ (void)deleteAllReservations;

+ (void)deleteReservationWithBegin:(NSString*)begin;

+ (void)deleteReservationsFromRoom:(Room*)room;


// LOGS

+ (void)logDate:(NSDate*)date;

+ (void)logReservation:(NSDate*)beginDate withEnd:(NSDate*)endDate;

+ (void)logAllRooms;

+ (void)logAllReservations;

// LOGICAL METHODS

+ (BOOL)checkAvailability:(NSString*)beginTimeWished withEnd:(NSString*)endTimeWished;

+ (BOOL)checkAvailability:(NSDate*)beginDateWished withEnd:(NSDate*)endDateWished withRoom:(Room*)room;

+ (BOOL)checkAvailability:(NSString*)beginStringWished End:(NSString*)endStringWished Room:(Room*)room;

+ (int)getPossibleDurationForBeginTime:(NSString*)beginTime withRoom: (Room*)room;

+ (double)getMaxDurationForBeginTime:(NSString*)beginTime;

+ (BOOL)getCurrentStateForRoom:(NSString*)idMapwize;

+ (BOOL)getStateForRoom:(NSString*)idMapwize time:(NSString*)time timeInterval:(int)interval;

@end
