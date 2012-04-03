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
//#import "SecondViewController.h"
#import "WayPoint.h"
#import "LocationController.h"
#import "cycleTrackAnnotation.h"

@interface FirstViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>{
    BOOL shouldZoom;
    float fltDistanceTravelled;
    //SecondViewController *sc;
    LocationController *locationController;
    NSMutableArray *annotations;
    double speed;
    
}
@property (weak, nonatomic) IBOutlet MKMapView *cycleMap;
@property (weak, nonatomic) IBOutlet UILabel *trackingLabel;
@property (weak, nonatomic) IBOutlet UILabel *disLabel;

@property(nonatomic) BOOL tracking;

@property(nonatomic, strong)MKPolyline *routeLine;
@property(nonatomic, strong)MKPolylineView *routeLineView;

@property(nonatomic, retain)NSMutableArray *currentPathWayPoints;

@property(nonatomic, retain)NSMutableArray *annotations;




-(BOOL)trackingToggled;
-(void)computePattern;
@end
