//
//  CourseMapView+Alert.m
//  tourism-app
//
//  Created by FUNAICT201311 on 2014/11/12.
//  Copyright (c) 2014年 myname. All rights reserved.
//
#import "CourseMapView+Alert.h"

@implementation CourseMapViewController(Alert)

/**
 位置情報取得の設定がかわると呼び出される
 iOS8の場合、位置情報取得が可能であればここで位置情報を取得を開始する
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    //位置情報取得許可の状態によって、アラートの出し方を条件分けしている
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        // 位置情報測位の許可状態が「常に許可」または「使用中のみ」の場合、
        // 測位を開始する（iOS バージョンが 8 以上の場合のみ該当する）
        // ※iOS8 以上の場合、位置情報測位が許可されていない状態で
        // startUpdatingLocation メソッドを呼び出しても、何も行われない。
        [self.locationManager startUpdatingLocation];
        
        if([CLLocationManager locationServicesEnabled]){
            [self updateUserTrackingModeBtn:MKUserTrackingModeFollow];
            [self.myMapView setUserTrackingMode:MKUserTrackingModeFollow];
        }
    } else if (status == kCLAuthorizationStatusRestricted) {
        
        [self.myMapView setUserTrackingMode:MKUserTrackingModeNone];
        [self updateUserTrackingModeBtn:MKUserTrackingModeNone];
        
        if (![UIAlertController class]) {
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"エラー"
                                      message:@"位置情報の取得に失敗しました。"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    } else if (status == kCLAuthorizationStatusDenied){
        
        [self.myMapView setUserTrackingMode:MKUserTrackingModeNone];
        [self updateUserTrackingModeBtn:MKUserTrackingModeNone];
        
        //iOS8とそれ以前ではアラートに使うクラスが違うため、条件分岐を用いている
        if ([UIAlertController class]) {
            
            UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"はこウォークで位置情報を取得するには位置情報サービスをオンにしてください。"
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *setAction =
            [UIAlertAction actionWithTitle:@"設定"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action){
                                       
                                       NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                       [[UIApplication sharedApplication] openURL:url];
                                   }];
            
            UIAlertAction *cancelAction =
            [UIAlertAction actionWithTitle:@"キャンセル"
                                     style:UIAlertActionStyleCancel
                                   handler:nil];
            [alertController addAction:setAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"位置情報の取得に失敗しました。"
                                      message:nil
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        
        [self.myMapView setUserTrackingMode:MKUserTrackingModeNone];
        [self updateUserTrackingModeBtn:MKUserTrackingModeNone];
        
        if (![UIAlertController class]) {
            
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:@"位置情報の取得に失敗しました。"
                                       message:nil
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [alertView show];
        }
    }
}

/**
 UIAlertViewのボタンが押されたときに呼ばれるデリゲートメソッド
 二回アラートを出すために実装している
 */
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{
            //１番目のボタンが押されたときの処理を記述する
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"iOSの設定 > プライバシー > 位置情報サービスから、このアプリの位置情報の利用を許可してください"
                                      message:nil
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
            break;
    }
    
}

/**
 ユーザの設定以外で位置情報がとれないときアラートをだすメソッド
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error) {
        
        [self.myMapView setUserTrackingMode:MKUserTrackingModeNone];
        [self updateUserTrackingModeBtn:MKUserTrackingModeNone];
        
        if ([error code] != kCLErrorDenied){
            
            if ([UIAlertController class]) {
                
                UIAlertController *alertController =
                [UIAlertController alertControllerWithTitle:@"位置情報の取得に失敗しました。"
                                                    message:nil
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction =
                [UIAlertAction actionWithTitle:@"OK"
                                         style:UIAlertActionStyleCancel
                                       handler:nil];
                [alertController addAction:okAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            } else {
                
                UIAlertView *alertView =
                [[UIAlertView alloc] initWithTitle:@"位置情報の取得に失敗しました。"
                                           message:nil
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
                [alertView show];
            }
        }
    }
}

@end
