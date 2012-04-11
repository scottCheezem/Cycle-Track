//
//  FirstViewController.m
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

/*WISH LIST
 X-get the stop start button working...(should it clear the routes on the map or should that be a seperate button?)
 X-add button to follow point user location (also compas?)...some sort of system button?
 X-show start and stop points in a path - add annotations - and figure 
 X-turn down the sensetivity of the tracking a little...or make it dynamic based on distance from last point?
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
    
    //self.navigationController.navigationBarHidden=YES;
    
    [self initLabels];
        
    self.currentPathWayPoints = [[NSMutableArray alloc] init ];

    self.cycleMap.delegate = self;
    
    self.routeLine = [[MKPolyline alloc] init];

    shouldZoom = YES;
    
    MKUserTrackingBarButtonItem *trackUserButton = [[MKUserTrackingBarButtonItem alloc]initWithMapView:self.cycleMap];
    self.navigationItem.rightBarButtonItem = trackUserButton;
    
      
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
    
    if((tracking && deltaMeters > 0) || (tracking && self.currentPathWayPoints.count == 0)){
        [self addWayPoint:newLocation.coordinate];
    }

    
}




-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
       
    NSLog(@"updating in map");
    
    //make this something seperate ?...
    if(shouldZoom){
        //self.initalLocation = userLocation.location;
        MKCoordinateRegion region;
        region.center = cycleMap.userLocation.coordinate;
        
        //compute the region with something less arbitrary?..
        region.span = MKCoordinateSpanMake(0.0001, 0.0001);
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
        shouldZoom = NO;
    }
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //NSLog(@"adding pin to map %@", [annotation class]);
    
    

    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }else if([annotation isKindOfClass:[cycleTrackAnnotation class]]){
        
        
        cycleTrackAnnotation *ct = (cycleTrackAnnotation*)annotation;
        MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        pinAnnotation.canShowCallout = YES;
        pinAnnotation.animatesDrop = YES;
        
        if(ct.wayPoint.isStart){
            pinAnnotation.pinColor = MKPinAnnotationColorGreen;
        }else if(ct.wayPoint.isStop){
            pinAnnotation.pinColor = MKPinAnnotationColorRed;
            
            UIButton *routeDetailsButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [routeDetailsButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            pinAnnotation.rightCalloutAccessoryView = routeDetailsButton;
            
        }else{
            pinAnnotation.pinColor = MKPinAnnotationColorPurple;
        }


        
        return pinAnnotation;
    }
    return nil;
    
}

-(void)showDetails:(id)sender{
    NSLog(@"the sender was %@", sender);
    //rc = [[RouteDetailViewController alloc]initWithNibName:@"" bundle:nil];
    
    [self performSegueWithIdentifier:@"RouteDetailSegue" sender:sender];
    //rc.routeDetailDistanceLaebel.text = [NSString stringWithFormat:@"%f.3", fltDistanceTravelled];
    //[self.navigationController pushViewController:rc animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"going to segue");
    
    
    if([[segue identifier] isEqualToString:@"RouteDetailSegue"]){
        NSLog(@"hey were going to the right place");
    }
    
    
    
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    NSLog(@"routeLine has %d points", self.routeLine.pointCount);
    

    MKOverlayView* overlayView = nil;
    
    self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
    self.routeLineView.tag = self.routeLine.pointCount-1;
    
    self.routeLineView.fillColor = [UIColor blueColor];
    self.routeLineView.strokeColor = [UIColor blueColor];
    self.routeLineView.lineWidth = 2;

    overlayView = self.routeLineView;
    NSLog(@"mapview has %d routes", self.cycleMap.overlays.count);
    for(int i = 0 ; i<self.cycleMap.overlays.count; i++){
        NSLog(@"%@", [self.cycleMap.overlays objectAtIndex:i]);
    }
    
    return overlayView;
}

-(void)computePattern{
    
    CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D)*self.currentPathWayPoints.count);
    
    int idx = 0;
    for(WayPoint *wp in self.currentPathWayPoints){
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([wp.lat doubleValue], [wp.lon doubleValue]);

        pointArr[idx] = coord;
        idx++;

    }
    
    
    
    self.routeLine = [MKPolyline polylineWithCoordinates:pointArr count:idx];
    
    free(pointArr);
    
    //make this a refresh routeline type thing...
    //this will cuase problems later one when/if we want to show multiple routes at once...
    if(self.routeLine != nil){
        [self.cycleMap removeOverlay:[self.cycleMap.overlays objectAtIndex:0]];
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
    //NSLog(@"tracking is %d", tracking);
    return tracking;
}




-(void)initLabels{
    
    
    UIFont *digiFont = [UIFont fontWithName:@"digital-7" size:20];
    
    [trackingLabel setFont:digiFont];
    [disLabel setFont:digiFont];
    self.trackingLabel.text = @"";
    self.disLabel.text = @"";

    
}


-(void)startTracking{

    [[LocationController sharedLocationController].locationManager startUpdatingLocation];

    
    //register for locationUpdates from the locationController;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationControllerDidUpdate:) name:@"locationUpdate" object:nil];
    
}

-(void)stopTracking{
    
    
    [[LocationController sharedLocationController].locationManager stopUpdatingLocation];
    

    
    [[NSNotificationCenter defaultCenter]removeObserver:self];    
    
    
    //grab the last point in the current path and set it to a stop point.
    if(self.currentPathWayPoints.count > 0){
        WayPoint *_wp = [self.currentPathWayPoints objectAtIndex:self.currentPathWayPoints.count-1];
        _wp.isStop = YES;
        cycleTrackAnnotation *stop = [[cycleTrackAnnotation alloc]initWithWayPoint:_wp];
        [self.cycleMap addAnnotation:stop];
    }
    
    NSArray *lastPath = [[NSArray alloc]initWithArray:self.currentPathWayPoints];
    [pathHistory addObject:lastPath];
    [self.currentPathWayPoints removeAllObjects];
    
        self.cycleMap = nil;
    NSLog(@"tracking has stopped");
    
}


-(void)addWayPoint:(CLLocationCoordinate2D)userLocation{
    //NSLog(@"adding waypoint");
    WayPoint *_wp = [[WayPoint alloc] initWayPointFromUserLocation:userLocation];
    
    
    if(self.currentPathWayPoints.count == 0){
        _wp.isStart = YES;
        
        cycleTrackAnnotation *startAnnote = [[cycleTrackAnnotation alloc]initWithWayPoint:_wp];
        
        [self.cycleMap addAnnotation:startAnnote];
        
    }
    
    [self.currentPathWayPoints addObject:_wp];
    
    if(self.currentPathWayPoints.count >= 2){
        
        [self computePattern];
    }
}




@end
