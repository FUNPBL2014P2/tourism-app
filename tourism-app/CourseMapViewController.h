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
#import "SVProgressHUD.h"

@interface CourseMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CourseModel *course_map_model;
    NSString *course_name; //コース詳細画面に受け渡すコース名
}

- (IBAction)myNavigationBuckButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *myNaviItem;//ナビゲーションバーに画像を表示するためのオブジェクト

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic)NSString *course_name;
@property CourseModel *course_map_model;
@property int selectid;//どのアノテーションが選択されているかを示すid

//カテゴリでも参照可能なようにヘッダファイルに書いたメソッド
- (void)stopLocationService;
- (void)updateUserTrackingModeBtn:(MKUserTrackingMode)mode;

@end
