//
//  PopupDetailViewController.m
//  WorkspaceManagement
//
//  Created by Technique on 05/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "PopupDetailViewController.h"

@interface PopupDetailViewController ()

@end

@implementation PopupDetailViewController

@synthesize ButtonExit;
@synthesize PopupRoomBookButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonReservation
{
    [self.delegate didClickOnReservation:self.room];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)geolocButton:(id)sender {
    [self.delegate didClickOnGeoloc:self.room];
}

- (void) setInfos:(Room*)room {
    [super viewDidLoad];
    
    self.room = room;
    
    // Do any additional setup after loading the view.
    self.view.layer.borderWidth = 3;
    
    [ButtonExit addTarget:self
                   action:@selector(setButton)
         forControlEvents:UIControlEventTouchUpInside];
    
    [PopupRoomBookButton addTarget:self
                            action:@selector(buttonReservation)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.PopupRoomNameTitleLabel setText:room.name];
    [self.PopupRoomCapacityLabel setText:[NSString stringWithFormat:@"Capacité %@ personnes",room.maxPeople]];
    [self.PopupRoomDescriptionLabel setText:room.infoRoom];
    
    [self setImages:room];
    [self setStateInfos:room];
    
}

- (void) setImages:(Room*)room {
    if([room.equipments containsObject:[ModelDAO getEquipmentByKey:@"retro"]]){
        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOffRetro"] withLabel:@"Vidéo-projecteur"];
    }
    if([room.equipments containsObject:[ModelDAO getEquipmentByKey:@"screen"]]){
        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOffScreen"] withLabel:@"Ecran"];
    }
    if([room.equipments containsObject:[ModelDAO getEquipmentByKey:@"table"]]){
        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOffTable"] withLabel:@"Tableau"];
    }
    if([room.equipments containsObject:[ModelDAO getEquipmentByKey:@"dock"]]){
        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOffDock"] withLabel:@"Dock"];
    }
}

- (void) setImage:(UIImage*)image withLabel:(NSString*)text {
    if([self.Popup1ItemsLabel.text isEqualToString:@""]){
        [self.Popup1ItemsLabel setText:text];
        [self.Popup1ItemsImage setImage:image];
    }
    else if([self.Popup2ItemsLabel.text isEqualToString:@""]){
        [self.Popup2ItemsLabel setText:text];
        [self.Popup2ItemsImage setImage:image];
    }
    else if([self.Popup3ItemsLabel.text isEqualToString:@""]){
        [self.Popup3ItemsLabel setText:text];
        [self.Popup3ItemsImage setImage:image];
    }
    else if([self.Popup4ItemsLabel.text isEqualToString:@""]){
        [self.Popup4ItemsLabel setText:text];
        [self.Popup4ItemsImage setImage:image];
    }
}

- (void) setStateInfos:(Room*)room {
    if([room.mapState isEqualToString:@"green_free"]){
        [self.geolocButton setBackgroundImage:[UIImage imageNamed:@"WSMImagesGeolocGreen"] forState:UIControlStateNormal];
        self.view.layer.borderColor = [[UIColor bnpGreen] CGColor];
        [self.PopupRoomBookButton setHidden:true];
        [self.PopupRoomStateLabel setHidden:false];
        [self.PopupRoomStateLabel setText:@"Salle en accès libre"];
    }
    else if([room.mapState isEqualToString:@"green_book_ok"]){
        [self.geolocButton setBackgroundImage:[UIImage imageNamed:@"WSMImagesGeolocGreen"] forState:UIControlStateNormal];
        self.view.layer.borderColor = [[UIColor bnpGreen] CGColor];
        [self.PopupRoomBookButton setHidden:false];
        [self.PopupRoomStateLabel setHidden:true];
    }
    else if([room.mapState isEqualToString:@"green_book_ko"]){
        [self.geolocButton setBackgroundImage:[UIImage imageNamed:@"WSMImagesGeolocGreen"] forState:UIControlStateNormal];
        self.view.layer.borderColor = [[UIColor bnpGreen] CGColor];
        [self.PopupRoomBookButton setHidden:true];
        [self.PopupRoomStateLabel setHidden:false];
        [self.PopupRoomStateLabel setText:@"Réservation indisponible"];
    }
    else if([room.mapState isEqualToString:@"blue"]){
        [self.geolocButton setBackgroundImage:[UIImage imageNamed:@"WSMImagesGeolocBlue"] forState:UIControlStateNormal];
        self.view.layer.borderColor = [[UIColor bnpBlue] CGColor];
        [self.PopupRoomBookButton setHidden:true];
        [self.PopupRoomStateLabel setHidden:false];
        [self.PopupRoomStateLabel setText:@"Votre réservation"];
    }
    else if([room.mapState isEqualToString:@"red"]){
        [self.geolocButton setBackgroundImage:[UIImage imageNamed:@"WSMImagesGeolocRed"] forState:UIControlStateNormal];
        self.view.layer.borderColor = [[UIColor bnpRed] CGColor];
        [self.PopupRoomBookButton setHidden:true];
        [self.PopupRoomStateLabel setHidden:false];
        [self.PopupRoomStateLabel setText:@"Salle occupée"];
    }
}


@end
