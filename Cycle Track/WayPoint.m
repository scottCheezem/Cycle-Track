//
//  WayPoint.m
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import "WayPoint.h"



@implementation WayPoint

@synthesize timeStamp,lat,lon,isStop,isStart;


-(WayPoint*)initWayPointFromUserLocation:(CLLocationCoordinate2D)userPosition{
    
    self.timeStamp = [NSDate date];
    self.lat = [NSNumber numberWithDouble:userPosition.latitude];
    self.lon = [NSNumber numberWithDouble:userPosition.longitude];
    
    return self;
}


@end
