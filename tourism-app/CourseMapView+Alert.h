//
//  CourseMapView+Alert.h
//  tourism-app
//
//  Created by FUNAICT201311 on 2014/11/12.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseMapViewController.h"

@interface CourseMapViewController(Alert)

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

@end
