//
//  LocationController.m
//  Cycle Track
//
//  Created by user on 3/30/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

//
//  LocationController.m
//
//  Created by Jinru on 12/19/09.
//  Copyright 2009 Arizona State University. All rights reserved.
//

#import "LocationController.h"

//static LocationController* sharedCLDelegate = nil;

@implementation LocationController
@synthesize locationManager, location, delegate;

-(id)init{
    self = [super init];
    if(self != nil){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
    
}

/*-(void)notify{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdate" object:nil];
    NSLog(@"sending notification");    
    
}*/

/*-(void)locationControllerDidUpdate:(NSNotification *)note{
    NSLog(@"recieved notification in fc");
    
}*/

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //return the new and old locations in dictionary form, send out notifucation...I guess???
    NSLog(@"updatingin location singleton");
    
    NSMutableDictionary *locationDict = [[NSMutableDictionary alloc] init];
    [locationDict setValue:newLocation forKey:@"newLocation"];
    //[locationDict setValue:oldLocation forKey:@"oldLocation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdate" object:locationDict];// userInfo:locationDict];
    
    
}

#pragma mark - Singleton implementation in ARC
+ (LocationController *)sharedLocationController
{
    static LocationController *sharedLocationControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedLocationControllerInstance = [[self alloc] init];
    });
    return sharedLocationControllerInstance;
}







@end
