//
//  cycleTrackAnnotation.h
//  Cycle Track
//
//  Created by user on 4/3/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import <MapKit/MKAnnotation.h>
#import "WayPoint.h"

@interface cycleTrackAnnotation : NSObject<MKAnnotation>{

    CLGeocoder *geoCoder;
    NSString *addressString;

    
}

@property(nonatomic, strong)WayPoint *wayPoint;
@property(nonatomic, readonly, copy)NSString *title;
@property(nonatomic, readonly, copy)NSString *subtitle;


-(CLLocationCoordinate2D)coordinate;
-(cycleTrackAnnotation*)initWithWayPoint:(WayPoint*)wp;

@end

