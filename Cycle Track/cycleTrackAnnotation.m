//
//  cycleTrackAnnotation.m
//  Cycle Track
//
//  Created by user on 4/3/12.
//  Copyright (c) 2012 433 E Tompkins St. All rights reserved.
//

#import "cycleTrackAnnotation.h"

@implementation cycleTrackAnnotation
@synthesize wayPoint;
@synthesize title;
@synthesize subtitle;

-(NSString*)title{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"EEE, M-d @ h:mm a"];
    
    if(wayPoint.isStart){
        
        return [NSString stringWithFormat:@"Started at %@", [dateFormat stringFromDate:wayPoint.timeStamp]];
        
    }else if(wayPoint.isStop){
        
        return [NSString stringWithFormat:@"Stopped at %@", [dateFormat stringFromDate:wayPoint.timeStamp]];
        
    }
    return @"";
    
}

-(NSString*)subtitle{
    
    
    return [NSString stringWithFormat:@"near %@", addressString];;
    
}

-(cycleTrackAnnotation*)initWithWayPoint:(WayPoint*)wp{

    self.wayPoint = wp;
    [self locationLookup];
    return self;
    
}

-(CLLocationCoordinate2D)coordinate{

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.wayPoint.lat doubleValue];
    coordinate.longitude = [self.wayPoint.lon doubleValue];
    
    return coordinate;
}


-(NSString *)locationLookup{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
            
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {

        //NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            //[self displayError:error];
            return;
        }
        //NSLog(@"Received placemarks: %@", placemarks);
        //[self displayPlacemarks:placemarks];
        CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            if(placeMark.addressDictionary){
                /*NSArray *keys = [placeMark.addressDictionary allKeys];
                NSLog(@"%@", keys);
                for(NSString *key in keys){
                    NSLog(@"%@ : %@", key,[placeMark.addressDictionary valueForKey:key]);
                }*/
                addressString = [placeMark.addressDictionary valueForKey:@"Name"];  
                //NSLog(@"found an address dictionary %@", [placeMark.addressDictionary valueForKey:@"Name"]);


            }        
    }];
    
    
    return addressString;
    
}



@end
