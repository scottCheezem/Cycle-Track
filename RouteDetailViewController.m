//
//  RouteDetailViewController.m
//  Cycle Track
//
//  Created by user on 4/8/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import "RouteDetailViewController.h"

@interface RouteDetailViewController ()

@end

@implementation RouteDetailViewController
@synthesize routeDetailTimeLabel;
@synthesize routeDetailDistanceLaebel;
@synthesize routeDetailAveSpeedLabel;
@synthesize routeDetailMaxSpeedLabel;
@synthesize routeDetailMinSpeedLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"in the route detail");
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setRouteDetailTimeLabel:nil];
    [self setRouteDetailDistanceLaebel:nil];
    [self setRouteDetailAveSpeedLabel:nil];
    [self setRouteDetailMaxSpeedLabel:nil];
    [self setRouteDetailMinSpeedLabel:nil];
    [self setView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
