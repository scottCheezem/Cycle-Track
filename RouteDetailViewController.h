//
//  RouteDetailViewController.h
//  Cycle Track
//
//  Created by user on 4/8/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WayPoint.h"

//@interface RouteDetailViewController : UIViewController
@interface RouteDetailViewController : UITableViewController

@property (weak, nonatomic) NSArray* routePoints;

@property (weak, nonatomic) IBOutlet UITableViewCell *distanceCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *timeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *maxSpeedCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *minSpeedCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *aveSpeedCell;




@end
