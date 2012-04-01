//
//  SecondViewController.h
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"
#import "FirstViewController.h"

@interface SecondViewController : UIViewController{
    LocationController *locationController;
    FirstViewController *fc;
    
}
@property (weak, nonatomic) IBOutlet UIButton *trackingToggleButton;
@property (weak, nonatomic) IBOutlet UILabel *SpeedLabel;

@end
