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
bool shouldZoom;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentPathWayPoints = [[NSMutableArray alloc] init ];

    cycleMap.delegate = self;
    locationManager.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //self.routeLine = [[MKPolyline alloc] init];

    shouldZoom = YES;
    
    if(self.locationManager.location == nil){
        //NSLog(@"no location");
    }    
}


-(void)viewWillAppear:(BOOL)animated{
    //[self trackingToggled];
}
-(void)viewDidAppear:(BOOL)animated{
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
    //NSLog(@"updating user location..");
//    NSLog(@"user location is now %f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    
    if(shouldZoom){
        //self.initalLocation = userLocation.location;
        MKCoordinateRegion region;
        region.center = cycleMap.userLocation.coordinate;
        
        //compute the region with something less arbitrary..
        region.span = MKCoordinateSpanMake(0.01, 0.01);
        
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
        shouldZoom = NO;
    }
    
    if(tracking){
        //NSLog(@"tracking enabled");
        WayPoint *_wp = [[WayPoint alloc]initWayPointFromUserLocation:userLocation.coordinate];
        if(_wp != nil){
            [self.currentPathWayPoints addObject:_wp];
            NSLog(@"added a point : %d", [self.currentPathWayPoints count]);
        }
        if(self.currentPathWayPoints.count >= 2){
            [self computePattern];
        }
        
    }
    
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    
    MKOverlayView* overlayView = nil;
    
    //if(overlay == self.routeLine){
         //if(nil == self.routeLine){
             NSLog(@"about to init with poly line..");
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

    
    
    
    CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D)*self.currentPathWayPoints.count);
    //MKMapPoint* pointArr = malloc(sizeof(MKMapPoint)*self.currentPathWayPoints.count);
    
    int idx = 0;
    for(WayPoint *wp in self.currentPathWayPoints){
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([wp.lat doubleValue], [wp.lon doubleValue]);
        //NSLog(@"%d of %d - %f : %f", idx, self.currentPathWayPoints.count, [wp.lat doubleValue], [wp.lon doubleValue]);
        //MKMapPoint point = MKMapPointForCoordinate(coord);

        //pointArr[idx] = point;
        pointArr[idx] = coord;
        idx++;

    }
    for(int i = 0; i<idx ; i++){
        NSLog(@"point %d : %f, %f", i, pointArr[i].latitude, pointArr[i].longitude);
    }
    self.routeLine = [MKPolyline polylineWithCoordinates:pointArr count:idx-1];

    free(pointArr);
    if(self.routeLine != nil){
        NSLog(@"routeLine is not nil");
        //[self.cycleMap removeOverlay:self.routeLine];
        [self.cycleMap addOverlay:self.routeLine];        
    }

}

-(void)trackingToggled{
    
    
    
    self.tracking = !self.tracking;

    if(tracking){
        trackingLabel.text = @"trackng";
    }else{
        trackingLabel.text = @"";
    }
    //NSLog(@"tracking is %d", tracking);
    
}


@end
