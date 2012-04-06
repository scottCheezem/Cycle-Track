//
//  FirstViewController.m
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

/*WISH LIST
 X-get the stop start button working...(should it clear the routes on the map or should that be a seperate button?)
 -add button to follow point user location (also compas?)...some sort of system button?
 -show start and stop points in a path - add annotations - and figure 
 -turn down the sensetivity of the tracking a little...or make it dynamic based on distance from last point?
 -store a record : a copy of the array of points.
 -show a history table
 X-show current speed in the second view and in the tracking label...
 
 */


#import "FirstViewController.h"



@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize cycleMap;
@synthesize trackingLabel;
@synthesize disLabel;
@synthesize tracking;
@synthesize routeLine, routeLineView, currentPathWayPoints;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self initLabels];
        
    self.currentPathWayPoints = [[NSMutableArray alloc] init ];

    cycleMap.delegate = self;
    

    locationController = [LocationController sharedLocationController];
    
    self.routeLine = [[MKPolyline alloc] init];

    shouldZoom = YES;
      
}


- (void)viewDidUnload
{
    [self setCycleMap:nil];
    [self setTrackingLabel:nil];
    [self setDisLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)locationControllerDidUpdate:(NSNotification *)note{

    CLLocation *newLocation = [[note userInfo] valueForKey:@"newLocation"];
    CLLocation *oldLocation = [[note userInfo] valueForKey:@"oldLocation"];
    
    CLLocationDistance deltaMeters = [newLocation distanceFromLocation:oldLocation];
    NSTimeInterval deltaSeconds = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    
    //put in a check here to make sure we're still not warming up the gps
    //like if the deltaMeters > 500 && deltaSeconds < 3 or something...

    if(deltaMeters<50 && deltaMeters>=0){
        fltDistanceTravelled +=deltaMeters;
        speed = deltaMeters/deltaSeconds;
        
        trackingLabel.text = [NSString stringWithFormat:@"%.3f m/s", speed];
        disLabel.text = [NSString stringWithFormat:@"%.3f meters", fltDistanceTravelled];
    }
    
}




-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"updating user location..");
    
    //make this something seperate...
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

    

    //this should also be seperate...

    if(tracking){// && userLocation.coordinate.latitude ){
        [self addWayPoint:userLocation];
                
    }/*else{
        NSLog(@"you are at the north pole");
        NSLog(@"%f, %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    }*/
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    NSLog(@"adding pin to map %@", [annotation class]);
    
    

    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }else if([annotation isKindOfClass:[cycleTrackAnnotation class]]){
        
        NSLog(@"got an annotation");
        cycleTrackAnnotation *ct = (cycleTrackAnnotation*)annotation;
        MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        if(ct.wayPoint.isStart){
            pinAnnotation.pinColor = MKPinAnnotationColorGreen;
        }else if(ct.wayPoint.isStop){
            pinAnnotation.pinColor = MKPinAnnotationColorRed;
        }else{
            pinAnnotation.pinColor = MKPinAnnotationColorPurple;
        }


        
        return pinAnnotation;
    }
    return nil;
    
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
    

//    NSLog(@"about to init with poly line..it has %d points", self.routeLine.pointCount);
    self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
    self.routeLineView.fillColor = [UIColor blueColor];
    self.routeLineView.strokeColor = [UIColor blueColor];
    self.routeLineView.lineWidth = 2;


    overlayView = self.routeLineView;

    
    return overlayView;
}

-(void)computePattern{
    //NSLog(@"processing %d points", self.currentPathWayPoints.count);

    
    
    
    CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D)*self.currentPathWayPoints.count);
    
    int idx = 0;
    for(WayPoint *wp in self.currentPathWayPoints){
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([wp.lat doubleValue], [wp.lon doubleValue]);

        pointArr[idx] = coord;
        idx++;

    }
    
    self.routeLine = [MKPolyline polylineWithCoordinates:pointArr count:idx];
//    NSLog(@"route line has %d points", self.routeLine.pointCount);

    

    
    free(pointArr);
    
    //make this a refresh routeline type thing...
    if(self.routeLine != nil){
        //[self.cycleMap removeOverlay:self.routeLine];
        [self.cycleMap addOverlay:self.routeLine];        
    }
    
    

}

-(BOOL)trackingToggled{
    
    self.tracking = !self.tracking;

    if(tracking){
        [self startTracking];

    }else{
        [self stopTracking];
    }
    NSLog(@"tracking is %d", tracking);
    return tracking;
}




-(void)initLabels{
    
    
    UIFont *digiFont = [UIFont fontWithName:@"digital-7" size:20];
    
    [trackingLabel setFont:digiFont];
    [disLabel setFont:digiFont];

    
}


-(void)startTracking{
    NSLog(@"trackig has started");
    //locationController startUpdating.
    [[LocationController sharedLocationController].locationManager startUpdatingLocation];
    
    
    //register for locationUpdates;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationControllerDidUpdate:) name:@"locationUpdate" object:nil];
    
    //init a new route.
    //set the first way point to a start point
    
    //pass the first point to populate an annotation...
    
    //start pushing new way points on to the current path.
    
    
}

-(void)stopTracking{
    NSLog(@"tracking has stopped");
    [[NSNotificationCenter defaultCenter]removeObserver:self];    
    //locationCOntroller stopupdating.
    
    [[LocationController sharedLocationController].locationManager stopUpdatingLocation];
    
    //deregister for updates.
    
    //grab the last point in the current path and set it to a stop point.
    if(self.currentPathWayPoints.count > 0){
        WayPoint *_wp = [self.currentPathWayPoints objectAtIndex:self.currentPathWayPoints.count-1];
        _wp.isStop = YES;
        cycleTrackAnnotation *stop = [[cycleTrackAnnotation alloc]init];
        stop.wayPoint = _wp;
        [self.cycleMap addAnnotation:stop];
    }
    
    NSArray *lastPath = [[NSArray alloc]initWithArray:self.currentPathWayPoints];
    [pathHistory addObject:lastPath];
    [self.currentPathWayPoints removeAllObjects];
    
    
    
    
}

-(void)addWayPoint:(MKUserLocation *)userLocation{
    NSLog(@"adding a waypoint, %@", userLocation.location.timestamp);
    
    WayPoint *_wp = [[WayPoint alloc] initWayPointFromUserLocation:userLocation.coordinate];
    
    if(self.currentPathWayPoints.count == 0){
        _wp.isStart = YES;
        
        NSLog(@"found a start point");
        
        cycleTrackAnnotation *startAnnote = [[cycleTrackAnnotation alloc]init];
        startAnnote.wayPoint = _wp;
        
        [self.cycleMap addAnnotation:startAnnote];

        
    }
    
    
    [self.currentPathWayPoints addObject:_wp];
    
    //NSLog(@"added a point : %d", [self.currentPathWayPoints count]);
    
    if(self.currentPathWayPoints.count >= 2){
        
        [self computePattern];
    }

}



@end
