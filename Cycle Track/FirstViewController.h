//
//  FirstViewController.h
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>
#import <CoreLocation/CoreLocation.h>
#import "WayPoint.h"

@interface FirstViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>{
    BOOL shouldZoom;
    float fltDistanceTravelled;
    
}
@property (weak, nonatomic) IBOutlet MKMapView *cycleMap;
@property (weak, nonatomic) IBOutlet UILabel *trackingLabel;

@property(nonatomic) BOOL tracking;

@property(nonatomic, strong)MKPolyline *routeLine;
@property(nonatomic, strong)MKPolylineView *routeLineView;

@property(nonatomic, retain)NSMutableArray *currentPathWayPoints;

@property(nonatomic, strong)CLLocationManager *locationManager;



@property(nonatomic)double speed;



-(BOOL)trackingToggled;
-(void)computePattern;
@end
