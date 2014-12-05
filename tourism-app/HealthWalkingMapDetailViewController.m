//
//  HealthWalkingMapDetailViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "HealthWalkingMapDetailViewController.h"

@interface HealthWalkingMapDetailViewController ()

@end

@implementation HealthWalkingMapDetailViewController

@synthesize course_name;

CourseModel *course_model;
Course *course;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //CourseModelのインスタンス生成
    course_model = [[CourseModel alloc]init];
    //course_name(コース一覧画面で選択されたコース名)のコース情報が格納されたCourseインスタンスを取得
    course = [course_model getDataWithName:course_name];
    
    //健康ウォーキングマップ(Web)に接続する
    NSString* urlString = course.course_url;
    NSURL* walkingmapURL = [NSURL URLWithString: urlString];
    NSURLRequest* myRequest = [NSURLRequest requestWithURL: walkingmapURL];
    [self.myWebView loadRequest:myRequest];
    
    self.myWebView.scalesPageToFit = YES;
    self.myWebView.delegate = self;
    
    //コース一覧画面で選択されたコース名
    NSLog(@"%@", course_name);
}

- (void)viewWillAppear:(BOOL)animated{
    //ローディング表示を止める処理
    //[SVProgressHUD dismiss];
}

/**
 * Webページのロード時にインジケータを動かす
 */
- (void)webViewDidStartLoad:(UIWebView*)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/**
 * Webページのロード完了時にインジケータを非表示にする
 */
- (void)webViewDidFinishLoad:(UIWebView*)webView {
    //ローディング表示を止める処理
    [SVProgressHUD dismiss];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

///戻るボタンのアクション
- (IBAction)myNavigationBuckButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
