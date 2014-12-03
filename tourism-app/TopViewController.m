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
            UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.size.height - ((bounds.size.width / 3) / 178 * 109), bounds.size.width / 3, (bounds.size.width / 3) / 178 * 109)];
            UIButton *tableButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x + (bounds.size.width / 3), bounds.size.height - ((bounds.size.width / 3) / 178 * 109), bounds.size.width / 3, (bounds.size.width / 3) / 178 * 109)];
            UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x + (2 * bounds.size.width / 3), bounds.size.height - ((bounds.size.width / 3) / 178 * 109), bounds.size.width / 3, (bounds.size.width / 3) / 178 * 109)];
            [mapButton setImage:[UIImage imageNamed:@"map_btn_3to2.png"] forState:UIControlStateNormal];
            [tableButton setImage:[UIImage imageNamed:@"course_btn_3to2.png"] forState:UIControlStateNormal];
            [infoButton setImage:[UIImage imageNamed:@"info_btn_3to2.png"] forState:UIControlStateNormal];
            
            mapButton.exclusiveTouch = YES;
            tableButton.exclusiveTouch = YES;
            infoButton.exclusiveTouch = YES;
            
            [self.view addSubview:mapButton];
            [self.view addSubview:tableButton];
            [self.view addSubview:infoButton];
            
            //ボタンを指で押したときに呼ばれるアクションメソッドの設定
            [mapButton addTarget:self action:@selector(mapButtonTouchDownAction:) forControlEvents: UIControlEventTouchDown];
            [tableButton addTarget:self action:@selector(tableButtonTouchDownAction:) forControlEvents: UIControlEventTouchDown];
            [infoButton addTarget:self action:@selector(infoButtonTouchDownAction:) forControlEvents: UIControlEventTouchDown];
            
            //ボタンを指で押して離すときに呼ばれるアクションメソッドの設定
            [mapButton addTarget:self action:@selector(mapButtonTouchUpAction:) forControlEvents: UIControlEventTouchUpInside];
            [tableButton addTarget:self action:@selector(tableButtonTouchUpAction:) forControlEvents: UIControlEventTouchUpInside];
            [infoButton addTarget:self action:@selector(infoButtonTouchUpAction:) forControlEvents: UIControlEventTouchUpInside];
            
            //ボタンをコントロール境界外から境界内へのドラッグしたときに呼ばれるアクションメソッドの設定
            [mapButton addTarget:self action:@selector(mapButtonTouchDragEnterAction:) forControlEvents: UIControlEventTouchDragEnter];
            [tableButton addTarget:self action:@selector(tableButtonTouchDragEnterAction:) forControlEvents: UIControlEventTouchDragEnter];
            [infoButton addTarget:self action:@selector(infoButtonTouchDragEnterAction:) forControlEvents: UIControlEventTouchDragEnter];

            //ボタンをコントロール境界内から境界外へのドラッグしたときに呼ばれるアクションメソッドの設定
            [mapButton addTarget:self action:@selector(mapButtonTouchDragExitAction:) forControlEvents: UIControlEventTouchDragExit];
            [tableButton addTarget:self action:@selector(tableButtonTouchDragExitAction:) forControlEvents: UIControlEventTouchDragExit];
            [infoButton addTarget:self action:@selector(infoButtonTouchDragExitAction:) forControlEvents: UIControlEventTouchDragExit];
        }else if(r.size.height == 568 || r.size.height == 667 || r.size.height == 736){
            //iPhone5, iPhone5c, iPhone5s
            //iPhone6
            //iPhone6 Plus
            
            [imageView setImage:[UIImage imageNamed:@"top_16to9.png"]];
            
            //ボタンの作成
            UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.size.height - ((bounds.size.width / 3) / 256 * 235), bounds.size.width / 3, (bounds.size.width / 3) / 256 * 235)];
            UIButton *tableButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x + (bounds.size.width / 3), bounds.size.height - ((bounds.size.width / 3) / 256 * 235), bounds.size.width / 3, (bounds.size.width / 3) / 256 * 235)];
            UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x + (2 * bounds.size.width / 3), bounds.size.height - ((bounds.size.width / 3) / 256 * 235), bounds.size.width / 3, (bounds.size.width / 3) / 256 * 235)];
            [mapButton setImage:[UIImage imageNamed:@"map_btn_16to9.png"] forState:UIControlStateNormal];
            [tableButton setImage:[UIImage imageNamed:@"course_btn_16to9.png"] forState:UIControlStateNormal];
            [infoButton setImage:[UIImage imageNamed:@"info_btn_16to9.png"] forState:UIControlStateNormal];
            
            mapButton.exclusiveTouch = YES;
            tableButton.exclusiveTouch = YES;
            infoButton.exclusiveTouch = YES;
            
            [self.view addSubview:mapButton];
            [self.view addSubview:tableButton];
            [self.view addSubview:infoButton];
            
            //ボタンを指で押したときに呼ばれるアクションメソッドの設定
            [mapButton addTarget:self action:@selector(mapButtonTouchDownAction:) forControlEvents: UIControlEventTouchDown];
            [tableButton addTarget:self action:@selector(tableButtonTouchDownAction:) forControlEvents: UIControlEventTouchDown];
            [infoButton addTarget:self action:@selector(infoButtonTouchDownAction:) forControlEvents: UIControlEventTouchDown];
            
            //ボタンを指で押して離すときに呼ばれるアクションメソッドの設定
            [mapButton addTarget:self action:@selector(mapButtonTouchUpAction:) forControlEvents: UIControlEventTouchUpInside];
            [tableButton addTarget:self action:@selector(tableButtonTouchUpAction:) forControlEvents: UIControlEventTouchUpInside];
            [infoButton addTarget:self action:@selector(infoButtonTouchUpAction:) forControlEvents: UIControlEventTouchUpInside];
            
            //ボタンをコントロール境界外から境界内へのドラッグしたときに呼ばれるアクションメソッドの設定
            [mapButton addTarget:self action:@selector(mapButtonTouchDragEnterAction:) forControlEvents: UIControlEventTouchDragEnter];
            [tableButton addTarget:self action:@selector(tableButtonTouchDragEnterAction:) forControlEvents: UIControlEventTouchDragEnter];
            [infoButton addTarget:self action:@selector(infoButtonTouchDragEnterAction:) forControlEvents: UIControlEventTouchDragEnter];
            
            //ボタンをコントロール境界内から境界外へのドラッグしたときに呼ばれるアクションメソッドの設定
            [mapButton addTarget:self action:@selector(mapButtonTouchDragExitAction:) forControlEvents: UIControlEventTouchDragExit];
            [tableButton addTarget:self action:@selector(tableButtonTouchDragExitAction:) forControlEvents: UIControlEventTouchDragExit];
            [infoButton addTarget:self action:@selector(infoButtonTouchDragExitAction:) forControlEvents: UIControlEventTouchDragExit];
        }
    }else{
        //iPad系
        
        [imageView setImage:[UIImage imageNamed:@"top_4to3.png"]];
        
        //ボタンの作成
        UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.size.height - ((bounds.size.width / 3) / 325 * 200), bounds.size.width / 3, (bounds.size.width / 3) / 325 * 200)];
        UIButton *tableButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x + (bounds.size.width / 3), bounds.size.height - ((bounds.size.width / 3) / 325 * 200), bounds.size.width / 3, (bounds.size.width / 3) / 325 * 200)];
        UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(bounds.origin.x + (2 * bounds.size.width / 3), bounds.size.height - ((bounds.size.width / 3) / 325 * 200), bounds.size.width / 3, (bounds.size.width / 3) / 325 * 200)];
        [mapButton setImage:[UIImage imageNamed:@"map_btn_4to3.png"] forState:UIControlStateNormal];
        [tableButton setImage:[UIImage imageNamed:@"course_btn_4to3.png"] forState:UIControlStateNormal];
        [infoButton setImage:[UIImage imageNamed:@"info_btn_4to3.png"] forState:UIControlStateNormal];
        
        mapButton.exclusiveTouch = YES;
        tableButton.exclusiveTouch = YES;
        infoButton.exclusiveTouch = YES;
        
        [self.view addSubview:mapButton];
        [self.view addSubview:tableButton];
        [self.view addSubview:infoButton];
        
        //ボタンを指で押したときに呼ばれるアクションメソッドの設定
        [mapButton addTarget:self action:@selector(mapButtonTouchDownAction:) forControlEvents: UIControlEventTouchDown];
        [tableButton addTarget:self action:@selector(tableButtonTouchDownAction:) forControlEvents: UIControlEventTouchDown];
        [infoButton addTarget:self action:@selector(infoButtonTouchDownAction:) forControlEvents: UIControlEventTouchDown];
        
        //ボタンを指で押して離すときに呼ばれるアクションメソッドの設定
        [mapButton addTarget:self action:@selector(mapButtonTouchUpAction:) forControlEvents: UIControlEventTouchUpInside];
        [tableButton addTarget:self action:@selector(tableButtonTouchUpAction:) forControlEvents: UIControlEventTouchUpInside];
        [infoButton addTarget:self action:@selector(infoButtonTouchUpAction:) forControlEvents: UIControlEventTouchUpInside];
        
        //ボタンをコントロール境界外から境界内へのドラッグしたときに呼ばれるアクションメソッドの設定
        [mapButton addTarget:self action:@selector(mapButtonTouchDragEnterAction:) forControlEvents: UIControlEventTouchDragEnter];
        [tableButton addTarget:self action:@selector(tableButtonTouchDragEnterAction:) forControlEvents: UIControlEventTouchDragEnter];
        [infoButton addTarget:self action:@selector(infoButtonTouchDragEnterAction:) forControlEvents: UIControlEventTouchDragEnter];
        
        //ボタンをコントロール境界内から境界外へのドラッグしたときに呼ばれるアクションメソッドの設定
        [mapButton addTarget:self action:@selector(mapButtonTouchDragExitAction:) forControlEvents: UIControlEventTouchDragExit];
        [tableButton addTarget:self action:@selector(tableButtonTouchDragExitAction:) forControlEvents: UIControlEventTouchDragExit];
        [infoButton addTarget:self action:@selector(infoButtonTouchDragExitAction:) forControlEvents: UIControlEventTouchDragExit];
    }
    
    //UIImageViewのインスタンスをビューに追加
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}

///マップボタンを指で押したときに呼ばれる処理
- (void)mapButtonTouchDownAction:(UIButton *)button{
    //ローディング表示処理
    [SVProgressHUD showWithStatus:@"読み込み中"];
}

///コース一覧ボタンを指で押したときに呼ばれる処理
- (void)tableButtonTouchDownAction:(UIButton *)button{
    //ローディング表示処理
    [SVProgressHUD showWithStatus:@"読み込み中"];
}

///infoボタンを指で押したときに呼ばれる処理
- (void)infoButtonTouchDownAction:(UIButton *)button{
    //ローディング表示処理
    [SVProgressHUD showWithStatus:@"読み込み中"];
}

///マップボタンを指で押して離したときの処理
- (void)mapButtonTouchUpAction:(UIButton *)button{
    [self performSegueWithIdentifier:@"course_map" sender:self];
}

///コース一覧ボタンを指で押して離したときの処理
- (void)tableButtonTouchUpAction:(UIButton *)button{
    [self performSegueWithIdentifier:@"course_table" sender:self];
}

///infoボタンを指で押して離したときの処理
- (void)infoButtonTouchUpAction:(UIButton *)button{
    [self performSegueWithIdentifier:@"info" sender:self];
}

///マップボタン外から指をドラッグしてマップボタンを押したときに呼ばれる処理
- (void)mapButtonTouchDragEnterAction:(UIButton *)button{
    //ローディング表示処理
    [SVProgressHUD showWithStatus:@"読み込み中"];
}

///コース一覧ボタン外から指をドラッグしてマップボタンを押したときに呼ばれる処理
- (void)tableButtonTouchDragEnterAction:(UIButton *)button{
    //ローディング表示処理
    [SVProgressHUD showWithStatus:@"読み込み中"];
}

///infoボタン外から指をドラッグしてマップボタンを押したときに呼ばれる処理
- (void)infoButtonTouchDragEnterAction:(UIButton *)button{
    //ローディング表示処理
    [SVProgressHUD showWithStatus:@"読み込み中"];
}

///マップボタン内から指をドラッグしてマップボタン外に移動したときに呼ばれる処理
- (void)mapButtonTouchDragExitAction:(UIButton *)button{
    [SVProgressHUD dismiss];
}

///コース一覧ボタン内から指をドラッグしてマップボタン外に移動したときに呼ばれる処理
- (void)tableButtonTouchDragExitAction:(UIButton *)button{
    [SVProgressHUD dismiss];
}

///infoボタン内から指をドラッグしてマップボタン外に移動したときに呼ばれる処理
- (void)infoButtonTouchDragExitAction:(UIButton *)button{
    [SVProgressHUD dismiss];
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
