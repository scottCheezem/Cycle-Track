//
//  FirstViewController.m
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

/*WISH LIST
 -get the stop start button working...
 -add button to follow point user location (also compas?)...some sort of system button?
 -show start and stop points in a path - add annotations - and figure 
 -turn down the sensetivity of the tracking a little...or make it dynamic based on distance from last point?
 -store a record : a copy of the array of points.
 -show a history table
 -show current speed in the second view and in the tracking label...
 
 */


#import "FirstViewController.h"


@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize cycleMap;
@synthesize trackingLabel;
@synthesize tracking;
@synthesize routeLine, routeLineView, currentPathWayPoints;
@synthesize locationManager;
@synthesize speed;
//bool shouldZoom;
- (void)viewDidLoad
{
    [super viewDidLoad];

    //set the font
    [trackingLabel setFont:[UIFont fontWithName:@"digital-7" size:20]];
    
    
    self.currentPathWayPoints = [[NSMutableArray alloc] init ];

    cycleMap.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];

    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    
    self.routeLine = [[MKPolyline alloc] init];

    shouldZoom = YES;
    
    if(self.locationManager.location == nil){
        NSLog(@"no location");
    }    
}


-(void)viewWillAppear:(BOOL)animated{
    //[self trackingToggled];
}
-(void)viewDidAppear:(BOOL)animated{
    //[self trackingToggled];
}

- (void)viewDidUnload
{
    [self setCycleMap:nil];
    [self setTrackingLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //NSLog(@"didupdateLocation");
    //trackingLabel.text = [NSString stringWithFormat:@"%f", newLocation.speed];
    
    if(oldLocation != nil){
        CLLocationDistance deltaX = [newLocation getDistanceFrom:oldLocation];
        NSTimeInterval sinceLast = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
        speed = deltaX/sinceLast;
        NSLog(@"%f m/s", speed);
        
    }
    
    
    
    
    if(tracking){
            fltDistanceTravelled +=[self getDistanceInMiles:newLocation fromLocation:oldLocation];
    }else{
        fltDistanceTravelled = 0;
    }
    trackingLabel.text = [NSString stringWithFormat:@"%f", fltDistanceTravelled];
    
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    NSLog(@"updating user location..");
//    NSLog(@"user location is now %f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    
    if(shouldZoom){
        //self.initalLocation = userLocation.location;
        MKCoordinateRegion region;
        region.center = cycleMap.userLocation.coordinate;
        
        //compute the region with something less arbitrary..
        region.span = MKCoordinateSpanMake(0.0001, 0.0001);
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
        shouldZoom = NO;
    }
    
    if(tracking){

        
        [self.currentPathWayPoints addObject:[[WayPoint alloc]initWayPointFromUserLocation:userLocation.coordinate]];
        
        NSLog(@"added a point : %d", [self.currentPathWayPoints count]);
        
        if(self.currentPathWayPoints.count >= 2){
            
            [self computePattern];
        }
        
    }
    
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    switch([error code])
    {
        case kCLErrorLocationUnknown: 
            NSLog(@"The location manager was unable to obtain a location value right now");
            break;
        case kCLErrorDenied: 
            NSLog(@"Access to the location service was denied by the user");
            break;
        case kCLErrorNetwork: 
            NSLog(@"The network was unavailable or a network error occurred.");
            break;
        case kCLErrorHeadingFailure:
             NSLog(@"The heading could not be determined.");
            break;
        default:
            NSLog(@"location manager failed");
            break;
            
    }
}


-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    
    MKOverlayView* overlayView = nil;
    
    //if(overlay == self.routeLine){
         //if(nil == self.routeLine){
            NSLog(@"about to init with poly line..it has %d points", self.routeLine.pointCount);
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor blueColor];
            self.routeLineView.strokeColor = [UIColor blueColor];
            self.routeLineView.lineWidth = 2;
        
        //}
        overlayView = self.routeLineView;
    //}
    
    return overlayView;
}

-(void)computePattern{
    NSLog(@"processing %d points", self.currentPathWayPoints.count);

    
    //int initCount = self.currentPathWayPoints.count;
    
    CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D)*self.currentPathWayPoints.count);
    
    int idx = 0;
    for(WayPoint *wp in self.currentPathWayPoints){
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([wp.lat doubleValue], [wp.lon doubleValue]);

        pointArr[idx] = coord;
        idx++;

    }
    
    /*for(int i = 0; i<idx ; i++){
        NSLog(@"point %d : %f, %f", i, pointArr[i].latitude, pointArr[i].longitude);
    }*/
    
    
    self.routeLine = [MKPolyline polylineWithCoordinates:pointArr count:idx];
    NSLog(@"route line has %d points", self.routeLine.pointCount);

    free(pointArr);
    if(self.routeLine != nil){
        //[self.cycleMap removeOverlay:self.routeLine];
        [self.cycleMap addOverlay:self.routeLine];        
    }

}

-(BOOL)trackingToggled{
    
    self.tracking = !self.tracking;

    if(tracking){
        trackingLabel.text = @"trackng";
        //setStartPoint
        
        
    }else{
        trackingLabel.text = @"";
        //setStopPoint
    }
    NSLog(@"tracking is %d", tracking);
    return tracking;
}



-(float)getDistanceInMiles:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    float lat1,lon1,lat2,lon2;
    
    lat1 = newLocation.coordinate.latitude  * M_PI / 180;
    lon1 = newLocation.coordinate.longitude * M_PI / 180;
    
    lat2 = oldLocation.coordinate.latitude  * M_PI / 180;   
    lon2 = oldLocation.coordinate.longitude * M_PI / 180;
    
    float R = 3963; // km
    float dLat = lat2-lat1;
    float dLon = lon2-lon1; 
    
    float a = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2); 
    float c = 2 * atan2(sqrt(a), sqrt(1-a)); 
    float d = R * c;
    
    NSLog(@"Miles-->%f",d);
    
    return d;
}




@end
