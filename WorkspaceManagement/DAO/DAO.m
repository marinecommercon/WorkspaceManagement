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

+ (NSManagedObjectContext *)getContext
{
    AppDelegate *appDelegate = UIApplication.sharedApplication.delegate;
    return appDelegate.managedObjectContext;
}

+ (void)saveContext
{
    NSError *saveError = nil;
    
    [[self getContext] save:&saveError];
    
    if( saveError )
        NSLog(@"CoreData Save ERROR: %@", saveError );
}

+ (NSManagedObject*)newInstance:(NSString *)type
{
    return [NSEntityDescription insertNewObjectForEntityForName:type
                                         inManagedObjectContext:[self getContext]];
}

+ (NSEntityDescription *)getEntityDescription:(NSString *)type
{
    return [NSEntityDescription entityForName:type
                       inManagedObjectContext:[self getContext]];
}


+ (NSArray *)getObjects:(NSString *)type withPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [self getEntityDescription:type];
    [request setEntity:entityDesc];
    
    if( predicate )
        [request setPredicate:predicate];
    
    NSError *error;
    NSArray *objects = [[self getContext] executeFetchRequest:request error:&error];
    
    // return an array if at least 1 object exists.
    if( !objects || objects.count == 0)
        return nil;
    
    return objects;
}

+ (NSManagedObject *)getObject:(NSString *)type withPredicate:(NSPredicate *)predicate
{
    NSArray *objects = [self getObjects:type withPredicate:predicate];
    
    if( !objects )
        return nil;
    
    return objects[0];
}

+ (NSArray *)getObjects:(NSString *)type withNot:(NSArray *)array
{
    NSMutableArray *completeArray = [NSMutableArray arrayWithArray:[self getObjects:type withPredicate:nil]];
    
    if(array)
    {
//        for (NSManagedObject *obj in array) {
//            if ([completeArray containsObject:obj]) {
//                [completeArray removeObject:obj];
//            }
//        }
        [completeArray removeObjectsInArray:array];
    }
    
    return [NSArray arrayWithArray:completeArray];
}

+ (void)deleteObject:(NSManagedObject *)object
{
    [[self getContext] deleteObject:object];
    [self saveContext];
}

+ (void)deleteAllObjects:(NSArray *)managedObjects
{
    for (NSManagedObject * mo in managedObjects)
        [[self getContext] deleteObject:mo];

    [self saveContext];
}

@end