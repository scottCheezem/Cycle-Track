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

- (void)viewDidLoad
{
    [super viewDidLoad];

    cycleMap.delegate = self;
    
    
    
    //trackingLabel.text = (tracking) ? @"tracking" : @"";
    if(tracking){
        trackingLabel.text = @"trackng";
    }else{
        trackingLabel.text = @"";
    }
    
    
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
    }
    
}




@end
