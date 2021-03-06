//
//  CourseDetailMapViewController.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CourseModel.h"
#import "SVProgressHUD.h"

@interface CourseDetailMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    CourseModel *course_map_model;
    NSString *course_name; //ウォーキングマップ画面に受け渡すコース名
    NSString *spot_name; //スポット詳細画面に受け渡すコース名
}

- (IBAction)myNavigatioBuckButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic)NSString *course_name;
@property (nonatomic)NSString *spot_name;
@property CourseModel *course_map_model;

- (void)stopLocationService;
- (void)updateUserTrackingModeBtn:(MKUserTrackingMode)mode;

@end
