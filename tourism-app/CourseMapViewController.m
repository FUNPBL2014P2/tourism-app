//
//  CourseMapViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "CourseMapViewController.h"

@interface CourseMapViewController ()

///ツールバーのボタン
@property UIButton *myButton;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation CourseMapViewController

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
    _locationManager.delegate = self;
    
    myMapView.showsUserLocation = YES;
    [myMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    _locationManager = [[CLLocationManager alloc] init];
    
    //iOS8以上とiOS7未満では位置情報の取得方法が変更されたため、両対応にするため処理を分けている
    //requestWhenInUseAuthorizationはiOS8にしかないメソッド
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [_locationManager requestWhenInUseAuthorization];
    } else {
        
        [_locationManager startUpdatingLocation];
    }
    
    //ツールバーの詳細設定はtoolBarCustomメソッドで記述
    [self toolBarCustom];
    [_myButton addTarget:self action:@selector(myButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    //ここからviewとmodelをつなぐ処理
    course_map_model = [[CourseModel alloc] init];
    
    //getStartAnnotationメソッドはスタート位置のCustomAnnotationがはいった配列を返すメソッド
    for (int i = 0; i < [[course_map_model getStartAnnotation] count]; i++)
        [myMapView addAnnotation:[[course_map_model getStartAnnotation] objectAtIndex:i]];
    
    //getAllCourseLineメソッドは全コースのMKPolylineが入った配列を返すメソッド
    for(int i = 0; i < [[course_map_model getAllCourseLine] count]; i++)
        [myMapView addOverlay:[[course_map_model getAllCourseLine] objectAtIndex:i]];
    
}

/**
 メモリ不足時に呼び出される
 */
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
    _myButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,33,33)];
    _myButton.imageView.transform = CGAffineTransformMakeScale(0.23, 0.23);
    _myButton.adjustsImageWhenHighlighted = NO;
    
    //アニメーションをかけるための設定
    _myButton.imageView.clipsToBounds = NO;
    _myButton.imageView.contentMode = UIViewContentModeCenter;
    
    //UIBarButtonItemではボタンを画像にする設定に限界があるため
    //より細かい設定のできるUIButtonをCustomViewとして設定することで、UIBarButtonItemを実装している
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc]initWithCustomView:_myButton];
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
        [_locationManager startUpdatingLocation];
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
    
    //メモリ節約のため再利用可能なアノテーションビューがあれば、そのビューを取得し、必要ならばアノテーションの内容に合わせてデータの流し込みなどを行います。
    static NSString *identifier = @"PlaceAnnotation";
    MKAnnotationView *annotationView = (MKAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.image = [UIImage imageNamed:@"start_pin.png"];
    annotationView.bounds = CGRectMake(0, 0, 60, 60);
    annotationView.centerOffset = CGPointMake(22, -32); // アイコンの中心を設定する
    return annotationView;
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
            _myButton.imageView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            break;
        case MKUserTrackingModeFollowWithHeading:
            mode = MKUserTrackingModeNone;
            _myButton.imageView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            break;
    }
    
    _myButton.imageView.transform = CGAffineTransformMakeScale(0.23, 0.23);
    [UIView commitAnimations];
    
    [self updateUserTrackingModeBtn:mode];
    [self.myMapView setUserTrackingMode:mode animated:YES];
    
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
    
    [_myButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal]; // アイコン
    [_myButton setBackgroundImage:[UIImage imageNamed:background] forState:UIControlStateNormal]; // 背景
}

/**
 　アノテーションボタンが押されたとき呼ばれるメソッド
 */
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    // locationManager(CLLocationManagerのインスタンス）のGPS計測を停止させる
    [_locationManager stopUpdatingLocation];
    // MapViewの現在位置表示機能を停止させる。コレを忘れるとMapViewを開放してもGPSが使用しっぱなしになる
    [myMapView setShowsUserLocation:NO];
    course_name = view.annotation.title;
    [self performSegueWithIdentifier:@"MapToDetail" sender:self];
}

/**
 Segueが実行されると、実行直前に自動的に呼び出される
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    CourseMapViewController *nextViewController = (CourseMapViewController*)[segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"MapToDetail"]){
        nextViewController.course_name = course_name;
    }
}

//戻るボタンのアクション
- (IBAction)dismissSelf:(id)sender {
    
    // locationManager(CLLocationManagerのインスタンス）のGPS計測を停止させる
    [_locationManager stopUpdatingLocation];
    // MapViewの現在位置表示機能を停止させる。コレを忘れるとMapViewを開放してもGPSが使用しっぱなしになる
    [myMapView setShowsUserLocation:NO];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
