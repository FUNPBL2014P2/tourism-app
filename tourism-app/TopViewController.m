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
    
    // iPadかどうか判断する
    if(![modelname hasPrefix:@"iPad"]){
        //iPad以外
        
        //Windowスクリーンのサイズを取得
        CGRect r = [[UIScreen mainScreen] bounds];
        
        if(r.size.height == 480){
            //iPhone4, iPhone4s
            
            [imageView setImage:[UIImage imageNamed:@"top_3to2.png"]];
            
            //ボタンの作成
            UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.size.height - ((bounds.size.width / 2) / 288 * 104), bounds.size.width / 2, (bounds.size.width / 2) / 288 * 104)];
            UIButton *tableButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x + (bounds.size.width / 2), bounds.size.height - ((bounds.size.width / 2) / 288 * 104), bounds.size.width / 2, (bounds.size.width / 2) / 288 * 104)];
            [mapButton setImage:[UIImage imageNamed:@"map_btn_3to2.png"] forState:UIControlStateNormal];
            [tableButton setImage:[UIImage imageNamed:@"course_btn_3to2.png"] forState:UIControlStateNormal];
            
            mapButton.exclusiveTouch = YES;
            tableButton.exclusiveTouch = YES;
            
            [self.view addSubview:mapButton];
            [self.view addSubview:tableButton];
            
            //ボタンが押された時のアクションメソッドを設定
            [mapButton addTarget:self action:@selector(mapButtonAction:) forControlEvents: UIControlEventTouchUpInside];
            [tableButton addTarget:self action:@selector(tableButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        }else if(r.size.height == 568 || r.size.height == 667 || r.size.height == 736){
            //iPhone5, iPhone5c, iPhone5s
            //iPhone6
            //iPhone6 Plus
            
            [imageView setImage:[UIImage imageNamed:@"top_16to9.png"]];
            
            //ボタンの作成
            UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.size.height - ((bounds.size.width / 2) / 356 * 198), bounds.size.width / 2, (bounds.size.width / 2) / 356 * 198)];
            UIButton *tableButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x + (bounds.size.width / 2), bounds.size.height - ((bounds.size.width / 2) / 356 * 198), bounds.size.width / 2, (bounds.size.width / 2) / 356 * 198)];
            [mapButton setImage:[UIImage imageNamed:@"map_btn_16to9.png"] forState:UIControlStateNormal];
            [tableButton setImage:[UIImage imageNamed:@"course_btn_16to9.png"] forState:UIControlStateNormal];
            
            mapButton.exclusiveTouch = YES;
            tableButton.exclusiveTouch = YES;
            
            [self.view addSubview:mapButton];
            [self.view addSubview:tableButton];
            
            //ボタンが押された時のアクションメソッドを設定
            [mapButton addTarget:self action:@selector(mapButtonAction:) forControlEvents: UIControlEventTouchUpInside];
            [tableButton addTarget:self action:@selector(tableButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        }
    }else{
        //iPad系
        
        [imageView setImage:[UIImage imageNamed:@"top_4to3.png"]];
        
        //ボタンの作成
        UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.size.height - ((bounds.size.width / 2) / 486 * 197), bounds.size.width / 2, (bounds.size.width / 2) / 486 * 197)];
        UIButton *tableButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x + (bounds.size.width / 2), bounds.size.height - ((bounds.size.width / 2) / 486 * 197), bounds.size.width / 2, (bounds.size.width / 2) / 486 * 197)];
        [mapButton setImage:[UIImage imageNamed:@"map_btn_4to3.png"] forState:UIControlStateNormal];
        [tableButton setImage:[UIImage imageNamed:@"course_btn_4to3.png"] forState:UIControlStateNormal];
        
        mapButton.exclusiveTouch = YES;
        tableButton.exclusiveTouch = YES;
        
        [self.view addSubview:mapButton];
        [self.view addSubview:tableButton];
        
        //ボタンが押された時のアクションメソッドを設定
        [mapButton addTarget:self action:@selector(mapButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        [tableButton addTarget:self action:@selector(tableButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    //UIImageViewのインスタンスをビューに追加
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}

///マップボタンが押された時の処理
-(void)mapButtonAction:(UIButton*)button{
    [self performSegueWithIdentifier:@"course_map" sender:self];
}

///コース一覧ボタンが押された時の処理
-(void)tableButtonAction:(UIButton*)button{
    [self performSegueWithIdentifier:@"course_table" sender:self];
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
