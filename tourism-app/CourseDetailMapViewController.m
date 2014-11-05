//
//  CourseDetailMapViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "CourseDetailMapViewController.h"

@interface CourseDetailMapViewController ()

///ツールバーのボタン
@property UIButton *myButton;
@property (nonatomic, retain) CLLocationManager *locationManager;


@end

@implementation CourseDetailMapViewController

@synthesize course_name, course_map_model, myMapView, myToolBar;

#pragma mark - UIViewController lifecicle event methods

/**
 初回ロードされた時のみ呼び出される
 - viewの詳細設定については、メソッドを分けて記述すること
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    myMapView.delegate = self;
    self.locationManager.delegate = self;
    
    myMapView.showsUserLocation = YES;
    [myMapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    //iOS8以上とiOS7未満では位置情報の取得方法が変更されたため、両対応にするため処理を分けている
    //requestWhenInUseAuthorizationはiOS8にしかないメソッド
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        
        [self.locationManager startUpdatingLocation];
    }

}

#pragma mark - delegate

/**
 位置情報取得の設定がかわると呼び出される
 iOS8の場合、位置情報取得が可能であればここで位置情報を取得を開始する
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}


//戻るボタンのアクション
- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
