//
//  CourseMapViewController.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CourseModel.h"

@interface CourseMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    CourseModel *course_map_model;
    NSString *course_name; //コース詳細画面に受け渡すコース名
}

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UIToolbar *myToolBar;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic)NSString *course_name;
@property CourseModel *course_map_model;

- (void)stopLocationService;

@end
