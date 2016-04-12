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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.borderWidth = 3;
    self.view.layer.borderColor = [[UIColor colorWithRed:20.0f/255.0f green:176.0f/255.0f blue:111.0f/255.0f alpha:1.0] CGColor];
    
    [ButtonExit addTarget:self
                 action:@selector(setButton)
       forControlEvents:UIControlEventTouchUpInside];
}

- (void)setButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setInfos:(Room*)room {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.layer.borderWidth = 3;
    self.view.layer.borderColor = [[UIColor colorWithRed:20.0f/255.0f green:176.0f/255.0f blue:111.0f/255.0f alpha:1.0] CGColor];
    
    [ButtonExit addTarget:self
                   action:@selector(setButton)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.PopupRoomNameTitleLabel setText:room.name];
    [self.PopupRoomCapacityLabel setText:[NSString stringWithFormat:@"Capacité %@ personnes",room.maxPeople]];
    
    if([room.equipments containsObject:[ModelDAO getEquipmentByKey:@"retro"]]){
        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOnRetro"] withLabel:@"Vidéo-projecteur"];
    }
    if([room.equipments containsObject:[ModelDAO getEquipmentByKey:@"screen"]]){
        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOnScreen"] withLabel:@"Ecran"];
    }
    if([room.equipments containsObject:[ModelDAO getEquipmentByKey:@"table"]]){
        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOnTable"] withLabel:@"Tableau"];
    }
    if([room.equipments containsObject:[ModelDAO getEquipmentByKey:@"dock"]]){
        [self setImage:[UIImage imageNamed:@"WSMImagesBtnOnDock"] withLabel:@"Dock"];
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

@end
