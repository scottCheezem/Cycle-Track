//
//  RouteDetailViewController.m
//  Cycle Track
//
//  Created by user on 4/8/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//


/* TODO!
     -methods to compute all the various values for a given route that we care about
     -put it in a nice table view with group seperation ...see settings app for table view style
     -at least one or several cells are graphs of the routestats...figure out which one matter the most
 
 */




#import "RouteDetailViewController.h"

@interface RouteDetailViewController ()

@end

@implementation RouteDetailViewController
@synthesize distanceCell;
@synthesize timeCell;
@synthesize maxSpeedCell;
@synthesize minSpeedCell;
@synthesize aveSpeedCell;

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
    
    [self setView:nil];
    [self setDistanceCell:nil];
    [self setTimeCell:nil];
    [self setMaxSpeedCell:nil];
    [self setMinSpeedCell:nil];
    [self setMaxSpeedCell:nil];
    [self setMinSpeedCell:nil];
    [self setAveSpeedCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
