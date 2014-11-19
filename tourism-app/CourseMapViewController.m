//
//  CourseMapViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "CourseMapViewController.h"
#import "CustomAnnotation.h"

@interface CourseMapViewController ()

///ツールバーのボタン
@property UIButton *myButton;

@end

@implementation CourseMapViewController

@synthesize course_name;
@synthesize course_map_model;
@synthesize myMapView;
@synthesize myToolBar;
@synthesize locationManager;
@synthesize selectid;

#pragma mark - UIViewController lifecicle event methods

/**
 初回ロードされた時のみ呼び出される
 - 詳細設定については、メソッドを分けて記述すること
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    myMapView.delegate = self;
    self.locationManager.delegate = self;
    
    myMapView.showsUserLocation = YES;
    [myMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    //iOS8以上とiOS7未満では位置情報の取得方法が変更された
    //ここではiOS7未満での位置情報の取得開始
    [self.locationManager startUpdatingLocation];
    
    //ツールバーの詳細設定はtoolBarCustomメソッドで記述
    [self toolBarCustom];
    [self.myButton addTarget:self action:@selector(myButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    //ここからviewとmodelをつなぐ処理
    course_map_model = [[CourseModel alloc] init];
    
    //getStartAnnotationメソッドはスタート位置のCustomAnnotationがはいった配列を返すメソッド
    NSMutableArray *pins = [[course_map_model getStartAnnotation] mutableCopy];
    //どのアノテーションも選択されてないときのidを設定
    selectid = -1;
    
    for (int i = 0; i < [pins count]; i++) {
        [myMapView addAnnotation:[pins objectAtIndex:i]];
    }
    
    //getAllCourseLineメソッドは全コースのMKPolylineが入った配列を返すメソッド
    NSMutableArray *lines = [[course_map_model getAllCourseLine] mutableCopy];
    
    for(int i = 0; i < [lines count]; i++) {
        [myMapView addOverlay:[lines objectAtIndex:i]];
    }
}

/**
 メモリ不足時に呼び出される
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

/**
 toolBarCustomのviewの実装するメソッド
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
    
    //メモリ節約のため再利用可能なアノテーションビューがあれば、そのビューを取得し、必要ならばアノテーションの内容に合わせてデータの流し込みなどを行います。
    static NSString *identifier = @"PlaceAnnotation";
    MKAnnotationView *annotationView = (MKAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.image = [UIImage imageNamed:@"start_pin.png"];
    annotationView.bounds = CGRectMake(0, 0, 50, 50);
    annotationView.centerOffset = CGPointMake(20, -25); // アイコンの中心を設定する
    
    return annotationView;
}

/**
 アノテーションが選択されたときに呼出されるメソッド
 */
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    //コースラインを一旦すべて消す処理
    //特定のコースラインを消して再描画する処理は技術的にむずかしいため、すべてを再描画しなおす
    for(id<MKOverlay> overlay in [mapView overlays]) {
        [mapView removeOverlay:overlay];
    }
    
    //選択されたアノテーションを特定する処理
    for(int i = 0; i < [course_map_model->course_table_data count]; i++){
        Course *course = [course_map_model->course_table_data objectAtIndex:i];
        if ([course.course_name isEqualToString:view.annotation.title]) {
            selectid = i;
        }
    }
    
    //再描画
    NSMutableArray *lines = [[course_map_model getAllCourseLine] mutableCopy];
    
    for(int i = 0; i < [lines count]; i++) {
        [myMapView addOverlay:[lines objectAtIndex:i]];
    }
    
}

/**
 アノテーションが選択が外れたときに呼出されるメソッド
 */
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    for(id<MKOverlay> overlay in [mapView overlays]) {
        [mapView removeOverlay:overlay];
    }
    
    //どのアノテーションも選択されてないときのidを設定
    selectid = -1;
    
    NSMutableArray *lines = [[course_map_model getAllCourseLine] mutableCopy];
    
    for(int i = 0; i < [lines count]; i++) {
        [myMapView addOverlay:[lines objectAtIndex:i]];
    }
}

/**
 オーバーレイが追加されるときに呼出されるメソッド
 オーバーレイの詳細設定はここで行う
 
 @return オーバーレイの色や太さなどの詳細設定
 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
    //選択されたアノテーションとコースラインを結びつける
    //結びついたコースラインの色を変える処理
    int index = (int)[mapView.overlays indexOfObject:overlay];
    
    if (index == selectid){
        lineView.strokeColor=[UIColor blueColor];
        lineView.lineWidth = 7.0;
    }else{
        
        lineView.strokeColor = [UIColor redColor];
        lineView.lineWidth = 3.0;
    }
    
    return lineView;
}

#pragma mark - event

/**
 myButtonが押されたときに呼出されるメソッド
 */
- (void)myButtonTapped {
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
 　アノテーションボタンが押されたとき呼ばれるメソッド
 */
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    [self stopLocationService];
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

///戻るボタンのアクション
- (IBAction)myNavigationBuckButtonAction:(id)sender {
    [self stopLocationService];
    // MapViewの現在位置表示機能を停止させる。コレを忘れるとMapViewを開放してもGPSが使用しっぱなしになる
    [myMapView setShowsUserLocation:NO];

    [self.navigationController popViewControllerAnimated:YES];
}

@end