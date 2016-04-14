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

+ (NSManagedObjectContext *)getContext;

+ (void)saveContext;

+ (NSManagedObject *)getInstance:(NSString*) type;

+ (NSEntityDescription *) getEntityDescription:(NSString *)type;

+ (NSArray *)getObjects:(NSString *)type withPredicate:(NSPredicate *)predicate;

+ (NSManagedObject *)getObject:(NSString *)type withPredicate:(NSPredicate *)predicate;

+ (void)deleteObject:(NSManagedObject *)object;

+ (void)deleteAllObjects:(NSArray *)managedObjects;

@end

