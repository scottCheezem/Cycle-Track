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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIFont *digitFont = [UIFont fontWithName:@"digital-7" size:80];
    [SpeedLabel setFont:digitFont];

    
    fc = [self.tabBarController.viewControllers objectAtIndex:0];
    
    SpeedLabel.text=[NSString stringWithFormat:@"%f", fc.speed];
}

- (void)viewDidUnload
{
    [self setTrackingToggleButton:nil];
    [self setSpeedLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)toggleTracking:(id)sender {
    FirstViewController *fc = [self.tabBarController.viewControllers objectAtIndex:0];

    NSLog(@"tracking is now %d", fc.tracking);
    [fc trackingToggled];
    [[self tabBarController]setSelectedIndex:0];

}




@end
