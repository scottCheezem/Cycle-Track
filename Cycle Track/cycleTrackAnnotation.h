//
//  cycleTrackAnnotation.h
//  Cycle Track
//
//  Created by user on 4/3/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WayPoint.h"

@interface cycleTrackAnnotation : NSObject<MKAnnotation>{

    WayPoint *wp;
    CLLocationCoordinate2D coordinate;
    
}

@property(nonatomic, strong)WayPoint *wayPoint;
@property(nonatomic, readonly)CLLocationCoordinate2D coordinate;

-(CLLocationCoordinate2D)coordinate;

@end

