//
//  WayPoint.h
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WayPoint : NSObject


@property(nonatomic, retain) NSDate *timeStamp;
@property(nonatomic, retain) NSNumber *lat;
@property(nonatomic, retain) NSNumber *lon;
@property(nonatomic) BOOL isStart;
@property(nonatomic) BOOL isStop;

-(WayPoint *)initWayPointFromUserLocation: (CLLocationCoordinate2D)userPosition;
@end
