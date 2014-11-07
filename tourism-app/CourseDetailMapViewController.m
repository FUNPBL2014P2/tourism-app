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

@synthesize course_name;
@synthesize spot_name;
@synthesize course_map_model;
@synthesize myMapView;
@synthesize myToolBar;
@synthesize myNavigationItem;

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
    [self updateUserTrackingModeBtn:MKUserTrackingModeNone];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    //iOS8以上とiOS7未満では位置情報の取得方法が変更されたため、両対応にするため処理を分けている
    //requestWhenInUseAuthorizationはiOS8にしかないメソッド
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }else{
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
    
    CLLocationCoordinate2D center;
    center.latitude = ((CustomAnnotation *)[start_pins objectAtIndex:0]).coordinate.latitude; // 経度
    center.longitude = ((CustomAnnotation *)[start_pins objectAtIndex:0]).coordinate.longitude; // 緯度
    [myMapView setCenterCoordinate:center animated:NO];
    
    // 縮尺を指定
    MKCoordinateRegion region = myMapView.region;
    region.center = center;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [myMapView setRegion:region animated:NO];
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
    
    [self.myButton setImage:[UIImage imageNamed:@"none_icon.png"] forState:UIControlStateNormal];
    
    //UIBarButtonItemではボタンを画像にする設定に限界があるため
    //より細かい設定のできるUIButtonをCustomViewとして設定することで、UIBarButtonItemを実装している
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.myButton];
    UIBarButtonItem *healthBarItem= [[UIBarButtonItem alloc] initWithTitle:@"健康ウォーキングマップを見る"
                                                                     style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onTapTest:)];
    
    // 固定間隔のスペーサーを作成する
    UIBarButtonItem *fixedSpacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
   
    UIBarButtonItem *fixedSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil ];
  
    NSArray *barButtons = [NSArray arrayWithObjects:customBarItem,fixedSpacer1 ,healthBarItem ,fixedSpacer2 ,nil];
    [myToolBar setItems:barButtons];
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

/**
 healthBarItemを押したときに呼ばれるメソッド
 */
- (void)onTapTest:(id)inSender {
[self performSegueWithIdentifier:@"MapToHealth" sender:self];
}

/**
 　アノテーションボタンが押されたとき呼ばれるメソッド
 */
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // locationManager(CLLocationManagerのインスタンス）のGPS計測を停止させる
    [self.locationManager stopUpdatingLocation];
    // MapViewの現在位置表示機能を停止させる。コレを忘れるとMapViewを開放してもGPSが使用しっぱなしになる
    [myMapView setShowsUserLocation:NO];
    spot_name = view.annotation.title;
    [self performSegueWithIdentifier:@"MapToSpot" sender:self];
}

/**
 Segueが実行されると、実行直前に自動的に呼び出される
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CourseDetailMapViewController *nextViewController = (CourseDetailMapViewController*)[segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"MapToHealth"]){
        nextViewController.course_name = course_name;
    }else if ([[segue identifier] isEqualToString:@"MapToSpot"]){
        nextViewController.course_name = course_name;
        nextViewController.spot_name = spot_name;
    }
    
    NSLog(@"%@", course_name);
    NSLog(@"%@", spot_name);
}

//戻るボタンのアクション
- (IBAction)dismissSelf:(id)sender {
    // locationManager(CLLocationManagerのインスタンス）のGPS計測を停止させる
    [self.locationManager stopUpdatingLocation];
    // MapViewの現在位置表示機能を停止させる。コレを忘れるとMapViewを開放してもGPSが使用しっぱなしになる
    [myMapView setShowsUserLocation:NO];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end