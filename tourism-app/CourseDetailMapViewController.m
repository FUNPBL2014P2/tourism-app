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

@synthesize course_name, course_map_model, myMapView, myToolBar, myNavigationItem;

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
    [myMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self updateUserTrackingModeBtn:MKUserTrackingModeNone];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    //iOS8以上とiOS7未満では位置情報の取得方法が変更されたため、両対応にするため処理を分けている
    //requestWhenInUseAuthorizationはiOS8にしかないメソッド
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        
        [self.locationManager startUpdatingLocation];
    }
    
    //ツールバーの詳細設定はtoolBarCustomメソッドで記述
    [self toolBarCustom];
    [self.myButton addTarget:self action:@selector(myButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    myNavigationItem.title = course_name;
    
    //ここからviewとmodelをつなぐ処理
    course_map_model = [[CourseModel alloc] init];
    
    //getSpotWithNameメソッドはスポット位置のCustomAnnotationがはいった配列を返すメソッド
    NSMutableArray *spot_pins = [[course_map_model getSpotWithName:course_name] mutableCopy];
    
    for (int i = 0; i < [spot_pins count]; i++) {
        [myMapView addAnnotation:[spot_pins objectAtIndex:i]];
    }
    
    //getStartAnnotationWithNameメソッドはコースのスタートのCustomAnnotationがはいった配列を返すメソッド
    NSMutableArray *start_pins =  [[course_map_model getStartAnnotationWithName:course_name] mutableCopy];
    
    for (int i = 0; i < [start_pins count]; i++) {
        NSLog(@"%@",[start_pins objectAtIndex:i]);
        [myMapView addAnnotation:[start_pins objectAtIndex:i]];
    }

    
    //getCourseLineWithNameメソッドはスポット位置のCustomAnnotationがはいった配列を返すメソッド
    [myMapView addOverlay:[course_map_model getCourseLineWithName:course_name]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View

/**
 toolBarCustomのviewの実装
 */
- (void)toolBarCustom {
    
    //UIButtonのiconのみにアニメーションをかけるため、iconとbackgroundを分けて大きさを設定している
    //transformでiconの大きさを設定することができる
    self.myButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,33,33)];
    self.myButton.imageView.transform = CGAffineTransformMakeScale(0.23, 0.23);
    self.myButton.adjustsImageWhenHighlighted = NO;
    
    //アニメーションをかけるための設定
    self.myButton.imageView.clipsToBounds = NO;
    self.myButton.imageView.contentMode = UIViewContentModeCenter;
    
    //UIBarButtonItemではボタンを画像にする設定に限界があるため
    //より細かい設定のできるUIButtonをCustomViewとして設定することで、UIBarButtonItemを実装している
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.myButton];
    NSArray *barButtons = [NSArray arrayWithObjects:customBarItem, nil];
    [myToolBar setItems:barButtons];
    [self updateUserTrackingModeBtn:MKUserTrackingModeFollow];
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

/**
 マップをスワイプしたとき、ボタンの画像を変える処理
 */
- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    [self updateUserTrackingModeBtn:mode];
}

/**
 アノテーションが追加されるときに呼出されるメソッド
 アノテーションの詳細設定はここで行う
 
 @return アノテーションの見た目や大きさなどの詳細設定
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    
    //現在地にもアノテーションが適応されるため、それをさける処理
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if([((CustomAnnotation*)annotation).frag isEqualToString:@"spot"]) {
        
        //メモリ節約のため再利用可能なアノテーションビューがあれば、そのビューを取得し、必要ならばアノテーションの内容に合わせてデータの流し込みなどを行います。
        //またスタートピンとスポットピンでは再利用するアノテーションが違うので、identifierをそれぞれ別に用意しています。
        static NSString *identifier = @"spotAnnotation";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.annotation = annotation;
        return annotationView;

    }else if([((CustomAnnotation*)annotation).frag isEqualToString:@"start"]) {
        
        static NSString *identifier = @"startAnnotation";
        MKAnnotationView *annotationView = (MKAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"start_pin.png"];
        annotationView.bounds = CGRectMake(0, 0, 50, 50);
        annotationView.centerOffset = CGPointMake(18, -25); // アイコンの中心を設定する
        return annotationView;
    }
    return nil;
}

/**
 オーバーレイが追加されるときに呼出されるメソッド
 オーバーレイの詳細設定はここで行う
 
 @return オーバーレイの色や太さなどの詳細設定
 */
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineView *lineView = [[MKPolylineView alloc] initWithOverlay:overlay];
    lineView.strokeColor = [UIColor redColor];
    lineView.lineWidth = 5.0;
    return lineView;
}

#pragma mark - event

/**
 myButtonが押されたときに呼出されるメソッド
 */
- (void)myButtonTapped{
    
    //アニメーションの設定
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelay:0];
    [UIView setAnimationRepeatCount:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    MKUserTrackingMode mode;
    
    //transformに小さいサイズから大きいサイズを設定することで
    //アニメーションによりボタンに動きを与える
    //またスイッチ文で、MKUserTrackingModeを切り替え
    switch (myMapView.userTrackingMode) {
        case MKUserTrackingModeNone:
        default:
            mode = MKUserTrackingModeFollow;
            break;
        case MKUserTrackingModeFollow:
            mode = MKUserTrackingModeFollowWithHeading;
            self.myButton.imageView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            break;
        case MKUserTrackingModeFollowWithHeading:
            mode = MKUserTrackingModeNone;
            self.myButton.imageView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            break;
    }
    
    self.myButton.imageView.transform = CGAffineTransformMakeScale(0.23, 0.23);
    [UIView commitAnimations];
    
    [self updateUserTrackingModeBtn:mode];
    [myMapView setUserTrackingMode:mode animated:YES];
    
}

/**
 myButtonの画像を、MKUserTrackingModeにより切り替えるメソッド
 */
- (void)updateUserTrackingModeBtn:(MKUserTrackingMode)mode {
    
    NSString *icon = nil;
    NSString *background = nil;
    
    switch (mode) {
        case MKUserTrackingModeNone:
        default:
            icon = @"none_icon";
            background = nil;
            break;
        case MKUserTrackingModeFollow:
            icon = @"follow_icon.png";
            background = @"background.png";
            break;
        case MKUserTrackingModeFollowWithHeading:
            icon = @"followheading_icon.png";
            background = @"background.png";
            break;
    }
    
    [self.myButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal]; // アイコン
    [self.myButton setBackgroundImage:[UIImage imageNamed:background] forState:UIControlStateNormal]; // 背景
}

//戻るボタンのアクション
- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
