//
//  cycleTrackAnnotation.m
//  Cycle Track
//
//  Created by user on 4/3/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import "cycleTrackAnnotation.h"

@implementation cycleTrackAnnotation
@synthesize wayPoint;
@synthesize coordinate;

-(CLLocationCoordinate2D)coordinate{
    coordinate.latitude = [self.wayPoint.lat doubleValue];
    coordinate.longitude = [self.wayPoint.lon doubleValue];
    
    return coordinate;
}
@end
