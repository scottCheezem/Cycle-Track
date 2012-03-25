//
//  WayPoint.m
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import "WayPoint.h"

@implementation WayPoint

@synthesize timeStamp,lat,lon;


-(WayPoint*)initWayPointFromUserLocation:(CLLocationCoordinate2D)userPosition{
    
    WayPoint *wp = [[WayPoint alloc]init ];
    wp.timeStamp = [NSDate date];
    NSLog(@"new WP at %@", wp.timeStamp);
    wp.lat = [NSNumber numberWithDouble:userPosition.latitude];
    wp.lon = [NSNumber numberWithDouble:userPosition.longitude];
    
    
    return wp;
}


@end
