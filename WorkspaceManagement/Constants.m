//
//  Constants.m
//  WorkspaceManagement
//
//  Created by Nicolas Buquet on 11/05/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *kReservationTypeDsi = @"dsi";
NSString *kReservationTypeAppInitial = @"app-initial";
NSString *kReservationTypeAppConfirmed = @"app-confirmed";
NSString *kReservationTypeBusyInitial = @"busy-initial";
NSString *kReservationTypeBusyConfirmed = @"busy-confirmed";
NSString *kReservationTypeBusyDsi = @"busy-dsi";
NSString *kReservationTypeFree = @"free";
NSString *kReservationTypeImpossible = @"impossible";
NSString *kReservationTypeNoReservation = @"noreservation";

NSString *kDsiCtrlReservationNotChanged = @"notChanged";
NSString *kDsiCtrlReservationChanged = @"changed";
NSString *kDsiCtrlReservationWhatever = @"Whatever";

NSString *kDAORoomEntity = @"Room";
NSString *kDAORoomName = @"name";
NSString *kDAORoomId = @"idMapwize";
NSString *kDAORoomMapStateGrey = @"grey";
NSString *kDAORoomMapStateGreenFree = @"green_free";
NSString *kDAORoomMapStateGreenBook_OK = @"green_book_ok";
NSString *kDAORoomMapStateGreenBook_KO = @"green_book_ko";
NSString *kDAORoomMapStateBlue = @"blue";
NSString *kDAORoomMapStateBlueRed = @"red";
NSString *kDAORoomMapStateBlueTest = @"test";

NSString *kDAOEquipmentEntity = @"Equipment";
NSString *kDAOEquipmentKey = @"key";
NSString *kDAOEquipmentFilterState = @"filterState";
NSString *kDAOEquipmentTypeRetro = @"retro";
NSString *kDAOEquipmentTypeScreen = @"screen";
NSString *kDAOEquipmentTypeTable = @"table";
NSString *kDAOEquipmentTypeDock = @"dock";


NSString *kDAOSensorEntity = @"Sensor";
NSString *kDAOSensorId = @"idSensor";

NSString *kDAOReservationEntity = @"Reservation";


NSString *kHourMinuteEndingWith00 = @"00";
NSString *kHourMinuteEndingWith30 = @"30";

NSString *kMapWizeApiKey = @"f1a08de88e9353ed5a9e97a0f89bdxdf";
NSString *kMapWizeAccessKey = @"h14aEHT8O6OvxoNo";

NSString *kDocapostSensorUrl = @"https://www.rec.docapost.io/mediation/v1/partner/get?idDevice=%@&startDate=%@&endDate=%@&count=1";
NSString *kDocapostCredentialUser = @"5caae365-bb88-42e2-a4a0-5a81cd071f3d";
NSString *kDocapostCredentialPassword = @"wXyHnxckgWYK";

