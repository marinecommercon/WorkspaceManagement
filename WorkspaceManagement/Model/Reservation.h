//
//  Reservation.h
//  WorkspaceManagement
//
//  Created by Technique on 01/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Room.h"

@class Room;

@interface Reservation : NSManagedObject

@property (nonatomic, retain) NSString *beginTime;
@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) Room     *room;

@end