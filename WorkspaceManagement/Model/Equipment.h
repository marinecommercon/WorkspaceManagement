//
//  Equipment.h
//  WorkspaceManagement
//
//  Created by Technique on 11/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Room.h"

@class Room;

@interface Equipment : NSManagedObject

@property (nonatomic, retain) NSString   *key;
@property (nonatomic, retain) NSString   *name;
@property (nonatomic, retain) NSNumber   *filterState;
@property (nonatomic, retain) Room       *room;

@end
