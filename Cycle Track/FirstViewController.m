//
//  FirstViewController.m
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

/*WISH LIST
 -get the stop start button working...(should it clear the routes on the map or should that be a seperate button?)
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
@synthesize disLabel;
@synthesize tracking;
@synthesize routeLine, routeLineView, currentPathWayPoints;
@synthesize annotations;
//@synthesize locationManager;
//@synthesize locationController;
//@synthesize speed;
//bool shouldZoom;
- (void)viewDidLoad
{
    [super viewDidLoad];

    //LocationController* locationController = [LocationController sharedLocationController];

    //set the font
    UIFont *digiFont = [UIFont fontWithName:@"digital-7" size:20];

    [trackingLabel setFont:digiFont];
    [disLabel setFont:digiFont];
    
    self.currentPathWayPoints = [[NSMutableArray alloc] init ];

    cycleMap.delegate = self;
    

    locationController = [LocationController sharedLocationController];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationControllerDidUpdate:) name:@"locationUpdate" object:nil];
    
    
    [[LocationController sharedLocationController].locationManager startUpdatingLocation];
    
    self.routeLine = [[MKPolyline alloc] init];

    shouldZoom = YES;
    
    if(locationController.locationManager.location == nil){
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
    fltDistanceTravelled +=deltaMeters;
    NSLog(@"fc:traveled %f", deltaMeters);
    NSTimeInterval deltaSeconds = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    speed = deltaMeters/deltaSeconds;
    
    trackingLabel.text = [NSString stringWithFormat:@"%.3f m/s", speed];
    disLabel.text = [NSString stringWithFormat:@"%.3f meters", fltDistanceTravelled];
    
    
}




-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"updating user location..");
    
    
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

        
        
        //[self.currentPathWayPoints addObject:[[WayPoint alloc]initWayPointFromUserLocation:userLocation.coordinate]];
        WayPoint *_wp = [[WayPoint alloc] initWayPointFromUserLocation:userLocation.coordinate];

        
        
        if(self.currentPathWayPoints.count == 0){
            _wp.isStart = YES;
            
        }
        
        [self.currentPathWayPoints addObject:_wp];
        
        NSLog(@"added a point : %d", [self.currentPathWayPoints count]);
        
        if(self.currentPathWayPoints.count >= 2){
            
            [self computePattern];
        }
        
    }
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    
    
    NSLog(@"placeing annotations");
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    
    
    
    
    //[annotation title
    
    else{// if([annotation isKindOfClass:[BusStopAnnotation class]]){
        MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"stop"];
        
        pinAnnotation.canShowCallout = YES;
        
        
        
        /*UIButton *stopDetailsButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinAnnotation.rightCalloutAccessoryView = stopDetailsButton;*/
        
        //the image is throwing the centering off...FIX IT (in the image?)!
        //busStopAnnotation.image = [UIImage imageNamed:@"bus.png"];
        
        return pinAnnotation;
    }
    
    /*else if ([annotation isKindOfClass:[BusVehicleAnnotation class]]){
     
     }*/
    
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
        
        if(wp.isStart){
            NSLog(@"found a start point");
           //make an annotation gree pin, title = starting point with time?
            cycleTrackAnnotation *startAnnote = [[cycleTrackAnnotation alloc]init];
            startAnnote.wayPoint = wp;
            //[annotations addObject:startAnnote];
            [self.cycleMap addAnnotation:startAnnote];
            
            
        }else if(wp.isStop){
            
        }
        
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
        //setStartPoint...taken care of in locationDidUpdate
        
        
        
    }else{
        trackingLabel.text = @"";
        
        //setStopPoint...
    }
    NSLog(@"tracking is %d", tracking);
    return tracking;
}






@end
