//
//  TopViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "TopViewController.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 機種の取得
    NSString *modelname = [ [ UIDevice currentDevice] model];
    //display size
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    // UIImageViewの初期化
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    //[imageView setImage:[UIImage imageNamed:@"start5.png"]];
    
    // iPadかどうか判断する
    if(![modelname hasPrefix:@"iPad"]){
        // iPad以外
        // Windowスクリーンのサイズを取得
        CGRect r = [[UIScreen mainScreen] bounds];
        if(r.size.height == 480){
            //iPhone4, iPhone4s
            [imageView setImage:[UIImage imageNamed:@"3:2"]];
        }else if(r.size.height == 667){
            //iPhone6
        }else if(r.size.height == 736){
            //iPhone6 Plus
        }else if(r.size.height == 568){
            //iPhone5, iPhone5c, iPhone5s
        }
    }else{
        //iPad系
        NSLog(@"iPad");
    }
    
    // UIImageViewのインスタンスをビューに追加
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}

/**
 Unwind Segueのアクションメソッド
 この画面に遷移することを可能にする
 */
- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue {
    NSLog(@"First view return action invoked.");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
