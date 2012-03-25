//
//  FirstViewController.m
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize cycleMap;
@synthesize trackingLabel;
@synthesize tracking;
@synthesize routeLine, routeLineView, currentPathWayPoints;
@synthesize locationManager;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentPathWayPoints = [[NSMutableArray alloc] init ];

    cycleMap.delegate = self;
    locationManager.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    self.tracking = true;
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [self trackingToggled];
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



-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"updating user location..");
    NSLog(@"user location is now %f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    if(TRUE){
        //self.initalLocation = userLocation.location;
        MKCoordinateRegion region;
        region.center = cycleMap.userLocation.coordinate;
        
        //compute the region with something less arbitrary..
        region.span = MKCoordinateSpanMake(0.1, 0.1);
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
    }
    
    if(tracking){
        NSLog(@"tracking enabled");
        WayPoint *wp = [[WayPoint alloc]initWayPointFromUserLocation:userLocation.coordinate];
        [self.currentPathWayPoints addObject:wp];
        NSLog(@"added a point : %d", self.currentPathWayPoints.count);

        
        
    }
    
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    
    MKOverlayView* overlayView = nil;
    
    //if(overlay == self.routeLine){
    // if(nil == self.routeLine){
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
    
    
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D)*self.currentPathWayPoints.count);
    
    
    for(int idx = 0; idx<=self.currentPathWayPoints.count ; idx++){
        WayPoint *wp = [self.currentPathWayPoints objectAtIndex:idx];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([wp.lat doubleValue], [wp.lon doubleValue]);
        MKMapPoint point = MKMapPointForCoordinate(coord);
        pointArr[idx] = point;

    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArr count:self.currentPathWayPoints.count];
    free(pointArr);
}

-(void)trackingToggled{

    if(tracking){
        trackingLabel.text = @"trackng";
    }else{
        trackingLabel.text = @"";
    }
    NSLog(@"tracking is %d", tracking);
    
}


@end
