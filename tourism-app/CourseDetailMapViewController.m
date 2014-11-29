//
//  CourseDetailMapViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "CourseDetailMapViewController.h"
#import "CustomAnnotation.h"


@interface CourseDetailMapViewController ()

///ツールバーのボタン
@property UIButton *myButton;

@end

@implementation CourseDetailMapViewController

@synthesize locationManager;
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
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    myMapView.delegate = self;
    self.locationManager.delegate = self;
    
    myMapView.showsUserLocation = YES;
    [myMapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    
    //iOS8以上とiOS7未満では位置情報の取得方法が変更された
    //ここではiOS7未満での位置情報の取得開始
    [self.locationManager startUpdatingLocation];
    
    //ツールバーの詳細設定はtoolBarCustomメソッドで記述
    [self toolBarCustom];
    [self.myButton addTarget:self action:@selector(myButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    myNavigationItem.title = course_name;
    
    //ここからviewとmodelをつなぐ処理
    course_map_model = [[CourseModel alloc] init];
    
    
    //getStartAnnotationWithNameメソッドはコースのスタートのCustomAnnotationがはいった配列を返すメソッド
    NSMutableArray *start_pins =  [[course_map_model getStartAnnotationWithName:course_name] mutableCopy];
    
    for (int i = 0; i < [start_pins count]; i++) {
        ((CustomAnnotation*)[start_pins objectAtIndex:i]).title = @"スタート";
        [myMapView addAnnotation:[start_pins objectAtIndex:i]];
    }
    
    
    //getSpotWithNameメソッドはスポット位置のCustomAnnotationがはいった配列を返すメソッド
    NSMutableArray *spot_pins = [[course_map_model getSpotWithName:course_name] mutableCopy];
    
    for (int i = 0; i < [spot_pins count]; i++) {
        [myMapView addAnnotation:[spot_pins objectAtIndex:i]];
    }
    
    //getCourseLineWithNameメソッドはコース名を引数に、そのコースのMKPolylineインスタンスを返すメソッド
    [myMapView addOverlay:[course_map_model getCourseLineWithName:course_name]];
    
    //最寄り駅のピンを立てる処理
    CLLocationCoordinate2D stop_point = CLLocationCoordinate2DMake([course_map_model getDataWithName:course_name].nearest_stop_latitude,
                                                                   [course_map_model getDataWithName:course_name].nearest_stop_longitude);
    CustomAnnotation *spotAnnotation = [[CustomAnnotation alloc] initWithCoordinate:stop_point];
    spotAnnotation.title = [course_map_model getDataWithName:course_name].nearest_stop_name;
    if([[course_map_model getDataWithName:course_name].nearest_stop_type isEqualToString:@"buss"]){
        
        spotAnnotation.subtitle = @"最寄りのバス停";
    }else if ([[course_map_model getDataWithName:course_name].nearest_stop_type isEqualToString:@"shiden"]){
        
        spotAnnotation.subtitle = @"最寄りの電停";
    }else{
        
        spotAnnotation.subtitle = @"最寄りのJR駅";
    }
    spotAnnotation.frag = @"stop";
    [myMapView addAnnotation:spotAnnotation];
    
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
    [self updateUserTrackingModeBtn:MKUserTrackingModeNone];
}

/**
 位置情報サービスを停止するメソッド
 */
- (void)stopLocationService
{
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

#pragma mark - delegate

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
        annotationView.centerOffset = CGPointMake(20, -25); // アイコンの中心を設定する
        
        return annotationView;
    }else if([((CustomAnnotation*)annotation).frag isEqualToString:@"stop"]) {
        
        static NSString *identifier = @"stoptAnnotation";
        MKAnnotationView *annotationView = (MKAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        if([[course_map_model getDataWithName:course_name].nearest_stop_type isEqualToString:@"buss"]){
            annotationView.image = [UIImage imageNamed:@"buss.png"];
        }else if ([[course_map_model getDataWithName:course_name].nearest_stop_type isEqualToString:@"shiden"]){
            annotationView.image = [UIImage imageNamed:@"shiden.png"];
        }else{
            annotationView.image = [UIImage imageNamed:@"train.png"];
        }
        
        
        annotationView.canShowCallout = YES;
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
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    lineView.strokeColor = [UIColor redColor];
    lineView.lineWidth = 5.0;
    
    return lineView;
}

/**
 マップの表示が終わったときに呼出されるメソッド
 スタートピンのコールアウトを最初から出すのに使う
 */
- (void)mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views {
    
    for (int i = 0; i < [myMapView.annotations count]; i++) {
        if([((CustomAnnotation*)[myMapView.annotations objectAtIndex:i]).frag isEqualToString:@"start"])
            [myMapView selectAnnotation:[myMapView.annotations objectAtIndex:i] animated:YES];
    }
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

///戻るボタンのアクション
- (IBAction)myNavigatioBuckButtonAction:(id)sender {
    // locationManager(CLLocationManagerのインスタンス）のGPS計測を停止させる
    [self.locationManager stopUpdatingLocation];
    // MapViewの現在位置表示機能を停止させる。コレを忘れるとMapViewを開放してもGPSが使用しっぱなしになる
    [myMapView setShowsUserLocation:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end