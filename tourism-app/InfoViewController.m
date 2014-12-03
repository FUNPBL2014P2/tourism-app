//
//  InfoViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/12/02.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

- (void)viewWillAppear:(BOOL)animated{
    //ローディング表示を止める処理
    [SVProgressHUD dismiss];
}

///戻るボタンのアクション
- (IBAction)myNavigationBuckButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
