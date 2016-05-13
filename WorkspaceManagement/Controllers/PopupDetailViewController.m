//
//  PopupDetailViewController.m
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "PopupDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MapViewController.h"
#import "Constants.h"

@interface PopupDetailViewController ()

@end

@implementation PopupDetailViewController

@synthesize ButtonExit;
@synthesize PopupRoomBookButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PopupRoomBookButton.layer.cornerRadius = 5;
    PopupRoomBookButton.clipsToBounds = YES;
    
    // Do any additional setup after loading the view.
    self.view.layer.borderWidth = 3;
    
    //    [ButtonExit addTarget:self
    //                   action:@selector(setButton)
    //         forControlEvents:UIControlEventTouchUpInside];
    
    //    [PopupRoomBookButton addTarget:self
    //                            action:@selector(buttonReservation)
    //                  forControlEvents:UIControlEventTouchUpInside];
    
    self.PopupRoomNameTitleLabel.text = self.room.name;
    self.PopupRoomCapacityLabel.text = [NSString stringWithFormat:@"Capacité %@ personnes",self.room.maxPeople];
    self.PopupRoomDescriptionLabel.text = self.room.infoRoom;
    
    [self setImages:self.room];
    [self setStateInfos:self.room];
}

- (IBAction)closePopup
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionRepeat| UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.alpha = 0.0;
                     }
                     completion:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)bookRoom
{
    NSLog(@"Reservation");
    
    MapViewController *mapCtrl = (MapViewController *)((UINavigationController *)self.presentingViewController).topViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReservationViewController *viewController = (ReservationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ReservationViewController"];
    
    viewController.room = self.room;
    viewController.beginTime = mapCtrl.reservationBeginTime;
    viewController.sliderInitialValue = mapCtrl.sliderValue;
    
    [self presentViewController:viewController animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)geolocButton:(id)sender {
//    [self.delegate didClickOnGeoloc:self.room];
//}

//- (void)setInfos:(Room *)room
//{
////    [super viewDidLoad];
//    
//    self.room = room;
//    
//    // Do any additional setup after loading the view.
//    self.view.layer.borderWidth = 3;
//    
//    [ButtonExit addTarget:self
//                   action:@selector(setButton)
//         forControlEvents:UIControlEventTouchUpInside];
//    
//    [PopupRoomBookButton addTarget:self
//                            action:@selector(buttonReservation)
//                  forControlEvents:UIControlEventTouchUpInside];
//    
//    self.PopupRoomNameTitleLabel.text = room.name;
//    self.PopupRoomCapacityLabel.text = [NSString stringWithFormat:@"Capacité %@ personnes",room.maxPeople];
//    self.PopupRoomDescriptionLabel.text = room.infoRoom;
//    
//    [self setImages:room];
//    [self setStateInfos:room];
//}

- (void)setImages:(Room *)room
{
//    if([room.equipments containsObject:[ModelDAO equipmentWithKey:@"retro"]]){
//        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOffRetro"] withLabel:@"Vidéo-projecteur"];
//    }
//    if([room.equipments containsObject:[ModelDAO equipmentWithKey:@"screen"]]){
//        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOffScreen"] withLabel:@"Écran"];
//    }
//    if([room.equipments containsObject:[ModelDAO equipmentWithKey:@"table"]]){
//        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOffTable"] withLabel:@"Tableau"];
//    }
//    if([room.equipments containsObject:[ModelDAO equipmentWithKey:@"dock"]]){
//        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOffDock"] withLabel:@"Dock"];
//    }
    
    NSString *keyLabel = @"label";
    NSString *keyImage = @"image";
    
    NSDictionary *imageAndLabelForEquipment = @{kDAOEquipmentTypeRetro:  @{keyImage: @"WSMImagesBtnOffRetro",  keyLabel: @"Vidéo-projecteur"},
                                                kDAOEquipmentTypeScreen: @{keyImage: @"WSMImagesBtnOffScreen", keyLabel: @"Écran"},
                                                kDAOEquipmentTypeTable:  @{keyImage: @"WSMImagesBtnOffTable",  keyLabel: @"Tableau"},
                                                kDAOEquipmentTypeDock:   @{keyImage: @"WSMImagesBtnOffDock",   keyLabel: @"Dock"}};
    
    NSMutableArray *slots = [NSMutableArray arrayWithObjects:
                             @{keyLabel: self.Popup1ItemsLabel, keyImage: self.Popup1ItemsImage},
                             @{keyLabel: self.Popup2ItemsLabel, keyImage: self.Popup2ItemsImage},
                             @{keyLabel: self.Popup3ItemsLabel, keyImage: self.Popup3ItemsImage},
                             @{keyLabel: self.Popup4ItemsLabel, keyImage: self.Popup4ItemsImage},
                             nil];
    
    for( NSString *equipmentKey in imageAndLabelForEquipment )
        if( [room.equipments containsObject:[ModelDAO equipmentWithKey:equipmentKey]] )
        {
            UILabel *label     = slots.firstObject[keyLabel];
            UIImageView *image = slots.firstObject[keyImage];
            
            label.text = imageAndLabelForEquipment[equipmentKey][keyLabel];
            image.image = [UIImage imageNamed:imageAndLabelForEquipment[equipmentKey][keyImage]];
            
            [slots removeObjectAtIndex:0];
        }

    for( NSDictionary *emptySlots in slots )
    {
        UILabel *label     = emptySlots[keyLabel];
        UIImageView *image = emptySlots[keyImage];
        
        label.hidden = YES;
        image.hidden = YES;
    }
}

//- (void)setImage:(UIImage*)image withLabel:(NSString*)text
//{
////    if([self.Popup1ItemsLabel.text isEqualToString:@""] )
////    {
////        self.Popup1ItemsLabel.text = text;
////        self.Popup1ItemsImage.image = image;
////    }
////    else if( [self.Popup2ItemsLabel.text isEqualToString:@""] )
////    {
////        [self.Popup2ItemsLabel setText:text];
////        [self.Popup2ItemsImage setImage:image];
////    }
////    else if([self.Popup3ItemsLabel.text isEqualToString:@""]){
////        [self.Popup3ItemsLabel setText:text];
////        [self.Popup3ItemsImage setImage:image];
////    }
////    else if([self.Popup4ItemsLabel.text isEqualToString:@""]){
////        [self.Popup4ItemsLabel setText:text];
////        [self.Popup4ItemsImage setImage:image];
////    }
//    
//    NSArray *labelsAndImages = @[ @{@"label": self.Popup1ItemsLabel, @"image": self.Popup1ItemsImage},
//                         @{@"label": self.Popup2ItemsLabel, @"image": self.Popup2ItemsImage},
//                         @{@"label": self.Popup3ItemsLabel, @"image": self.Popup3ItemsImage},
//                         @{@"label": self.Popup4ItemsLabel, @"image": self.Popup4ItemsImage},
//                        ];
//    
//    for( NSDictionary *labelImage in labelsAndImages )
//        if( [((UILabel *)labelImage[@"label"]).text isEqualToString:@""] )
//        {
//            ((UILabel *)labelImage[@"label"]).text = text;
//            ((UIImageView *)labelImage[@"image"]).image = image;
//        }
//}

- (void)setStateInfos:(Room *)room
{
//    if([room.mapState isEqualToString:@"green_free"]){
//        [self.PopupImagesGeoloc setImage:[UIImage imageNamed:@"WSMImagesGeolocGreen"]];
//        self.view.layer.borderColor = [[UIColor bnpGreen] CGColor];
//        [self.PopupRoomBookButton setHidden:true];
//        [self.PopupRoomStateLabel setHidden:false];
//        
//        [self.PopupRoomStateLabel setText:@"Salle en accès libre"];
//    }
//    else if([room.mapState isEqualToString:@"green_book_ok"]){
//        [self.PopupImagesGeoloc setImage:[UIImage imageNamed:@"WSMImagesGeolocGreen"]];
//        self.view.layer.borderColor = [[UIColor bnpGreen] CGColor];
//        [self.PopupRoomBookButton setHidden:false];
//        [self.PopupRoomStateLabel setHidden:true];
//    }
//    else if([room.mapState isEqualToString:@"green_book_ko"]){
//        [self.PopupImagesGeoloc setImage:[UIImage imageNamed:@"WSMImagesGeolocGreen"]];
//        self.view.layer.borderColor = [[UIColor bnpGreen] CGColor];
//        [self.PopupRoomBookButton setHidden:true];
//        [self.PopupRoomStateLabel setHidden:false];
//        
//        [self.PopupRoomStateLabel setText:@"Réservation indisponible"];
//    }
//    else if([room.mapState isEqualToString:@"blue"]){
//        [self.PopupImagesGeoloc setImage:[UIImage imageNamed:@"WSMImagesGeolocBlue"]];
//        self.view.layer.borderColor = [[UIColor bnpBlue] CGColor];
//        [self.PopupRoomBookButton setHidden:true];
//        [self.PopupRoomStateLabel setHidden:false];
//        
//        [self.PopupRoomStateLabel setText:@"Votre réservation"];
//    }
//    else if([room.mapState isEqualToString:@"red"]){
//        [self.PopupImagesGeoloc setImage:[UIImage imageNamed:@"WSMImagesGeolocRed"]];
//        self.view.layer.borderColor = [[UIColor bnpRed] CGColor];
//        [self.PopupRoomBookButton setHidden:true];
//        [self.PopupRoomStateLabel setHidden:false];
//        
//        [self.PopupRoomStateLabel setText:@"Salle occupée"];
//    }
    
    NSString *keyImage            = @"imageName";
    NSString *keyBorderColor      = @"borderColor";
    NSString *keyBookButtonHidden = @"bookButtonHidden";
    NSString *keyRoomStateHidden  = @"roomStateHidden";
    NSString *keyRoomStateText    = @"roomStateText";
    
    NSDictionary *infoDict = @{kDAORoomMapStateGreenFree: @{
                                       keyImage:            @"WSMImagesGeolocGreen",
                                       keyBorderColor:      UIColor.bnpGreen,
                                       keyBookButtonHidden: @(YES),
                                       keyRoomStateHidden:  @(NO),
                                       keyRoomStateText:    @"Salle en accès libre"},
                               
                               kDAORoomMapStateGreenBook_OK: @{
                                       keyImage:            @"WSMImagesGeolocGreen",
                                       keyBorderColor:      UIColor.bnpGreen,
                                       keyBookButtonHidden: @(NO),
                                       keyRoomStateHidden:  @(YES),
                                       keyRoomStateText:    @""},
                               
                               kDAORoomMapStateGreenBook_KO: @{
                                       keyImage:            @"WSMImagesGeolocGreen",
                                       keyBorderColor:      UIColor.bnpGreen,
                                       keyBookButtonHidden: @(YES),
                                       keyRoomStateHidden:  @(NO),
                                       keyRoomStateText:    @"Réservation indisponible"},
                               
                               kDAORoomMapStateBlue: @{
                                       keyImage:            @"WSMImagesGeolocBlue",
                                       keyBorderColor:      UIColor.bnpBlue,
                                       keyBookButtonHidden: @(YES),
                                       keyRoomStateHidden:  @(NO),
                                       keyRoomStateText:    @"Votre réservation"},
                               
                               kDAORoomMapStateRed: @{
                                       keyImage:            @"WSMImagesGeolocRed",
                                       keyBorderColor:      UIColor.bnpRed,
                                       keyBookButtonHidden: @(YES),
                                       keyRoomStateHidden:  @(NO),
                                       keyRoomStateText:    @"Salle occupée"}
//                               ,
//                               
//                               kDAORoomMapStateGrey: @{
//                                       keyImage:            @"WSMImagesGeolocRed",
//                                       keyBorderColor:      UIColor.bnpGrey,
//                                       keyBookButtonHidden: @(YES),
//                                       keyRoomStateHidden:  @(NO),
//                                       keyRoomStateText:    @"Réservation indisponible"}
                               };
    
    NSDictionary *roomInfo = infoDict[room.mapState];
    
    if( !roomInfo )
        return;
    
    self.PopupImagesGeoloc.image    = [UIImage imageNamed:roomInfo[keyImage]];
    self.view.layer.borderColor     = ((UIColor *)roomInfo[keyBorderColor]).CGColor;
    self.PopupRoomBookButton.hidden = ((NSNumber *)roomInfo[keyBookButtonHidden]).boolValue;
    self.PopupRoomStateLabel.hidden = ((NSNumber *)roomInfo[keyRoomStateHidden]).boolValue;
    self.PopupRoomStateLabel.text   = roomInfo[keyRoomStateText];
}


@end
