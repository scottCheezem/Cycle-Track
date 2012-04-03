//
//  SecondViewController.m
//  Cycle Track
//
//  Created by Scott Cheezem on 3/24/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import "SecondViewController.h"


@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize trackingToggleButton;
@synthesize SpeedLabel;
@synthesize distLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIFont *digitFontBig = [UIFont fontWithName:@"digital-7" size:80];
    UIFont *digitFont = [UIFont fontWithName:@"digital-7" size:20];
    [SpeedLabel setFont:digitFontBig];
    [distLabel setFont:digitFont];

    

    //locationController = [LocationController sharedLocationController];
    //[LocationController sharedLocationController].delegate = self;
    
    
    
    fc = [self.tabBarController.viewControllers objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationControllerDidUpdate:) name:@"locationUpdate" object:nil];
    
    
    
    
    
    
}

- (void)viewDidUnload
{
    [self setTrackingToggleButton:nil];
    [self setSpeedLabel:nil];
    [self setDistLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    //SpeedLabel.text = [NSString stringWithFormat:@"%.3f",fc.speed];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)toggleTracking:(id)sender {
    //FirstViewController *fc = [self.tabBarController.viewControllers objectAtIndex:0];

    NSLog(@"tracking is now %d", fc.tracking);
    if([fc trackingToggled] == YES){
        [[self tabBarController]setSelectedIndex:0];
    }
}

-(void)locationControllerDidUpdate:(NSNotification *)note{
    //NSLog(@"got note from second view");
    CLLocation *newLocation = [[note userInfo] valueForKey:@"newLocation"];
    CLLocation *oldLocation = [[note userInfo] valueForKey:@"oldLocation"];
    
    
    CLLocationDistance deltaMeters = [newLocation distanceFromLocation:oldLocation];
    fltDistance +=deltaMeters;
    NSLog(@"sc:traveled %f", deltaMeters);
    NSTimeInterval deltaSeconds = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    float speed = deltaMeters/deltaSeconds;
    
    SpeedLabel.text=[NSString stringWithFormat:@"%.3f m/s",speed];
    distLabel.text =[NSString stringWithFormat:@"%.3f meters",fltDistance]; 
    NSLog(@"%f m/s", speed);
    
    
    
    //old code - find a new home for it
    
    /*if(tracking){
     fltDistanceTravelled +=[self getDistanceInMiles:newLocation fromLocation:oldLocation];
     }else{
     fltDistanceTravelled = 0;
     }
     trackingLabel.text = [NSString stringWithFormat:@"%f", fltDistanceTravelled];*/
    
    
}



@end
