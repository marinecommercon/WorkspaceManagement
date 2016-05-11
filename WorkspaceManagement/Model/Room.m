//
//  Room.m
//  WorkspaceManagement
//
//  Created by Technique on 01/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "Room.h"

@implementation Room

@dynamic name;
@dynamic idMapwize;
@dynamic maxPeople;
@dynamic type;
@dynamic infoRoom;
@dynamic mapState;

@dynamic reservations;
@dynamic sensors;
@dynamic equipments;

- (NSString *)description
{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"ROOM %@", self.name];
    [str appendFormat:@"\n\tType: %@", self.type];
    [str appendFormat:@"\n\tInfo: %@", self.infoRoom];
    [str appendFormat:@"\n\tCapacity: %@", self.maxPeople];
    [str appendFormat:@"\n\tMapState: %@", self.mapState];
    [str appendString:@"\n\tSensors: "];
    for( Sensor *s in self.sensors )
        [str appendFormat:@"\t%@", s.idSensor];
    [str appendString:@"\n\tEquipments: "];
    for( Equipment *e in self.equipments )
        [str appendFormat:@"\t%@", e.name];
    return [NSString stringWithString:str];
}

@end
