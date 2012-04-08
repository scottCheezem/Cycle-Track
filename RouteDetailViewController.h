//
//  RouteDetailViewController.h
//  Cycle Track
//
//  Created by user on 4/8/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteDetailViewController : UIViewController;


@property (weak, nonatomic) IBOutlet UILabel *routeDetailTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeDetailDistanceLaebel;
@property (weak, nonatomic) IBOutlet UILabel *routeDetailAveSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeDetailMaxSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeDetailMinSpeedLabel;



@end
