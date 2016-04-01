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

@property (nonatomic, retain) NSDate   * beginTime;
@property (nonatomic, retain) NSDate   * endTime;
@property (nonatomic, retain) Room     * room;

@end