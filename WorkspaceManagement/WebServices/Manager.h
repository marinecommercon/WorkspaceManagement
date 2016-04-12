//
//  Manager.h
//  WorkspaceManagement
//
//  Created by Technique on 06/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSDownloader.h"
#import "Sensor.h"
#import "ModelDAO.h"

@protocol ManagerDelegate
- (void) finishCheckWithUpdate:(BOOL)updateNeeded;
@end

@interface Manager : NSObject <WSDownloaderDelegate>

@property (nonatomic, strong) WSDownloader *ws;
@property (nonatomic, weak) id <ManagerDelegate> delegate;
@property (nonatomic,strong)  NSArray *deviceList;

- (void) checkSensors:(NSArray*)deviceList;

@end