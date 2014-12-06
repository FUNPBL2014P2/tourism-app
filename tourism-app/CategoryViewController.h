//
//  CategoryViewController.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface CategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    //カテゴリ画面にチェックマークがついているか、ついていないか判別するフラグ
    BOOL isSpringChecked;
    BOOL isSummerChecked;
    BOOL isAutumnChecked;
    BOOL isWinterChecked;
    BOOL isParkChecked;
    BOOL isSeaChecked;
}

- (IBAction)myNavigationBuckButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myNavigationFinishButton;

//カテゴリ画面にチェックマークがついているか、ついていないか判別するフラグ
@property (nonatomic)BOOL isSpringChecked;
@property (nonatomic)BOOL isSummerChecked;
@property (nonatomic)BOOL isAutumnChecked;
@property (nonatomic)BOOL isWinterChecked;
@property (nonatomic)BOOL isParkChecked;
@property (nonatomic)BOOL isSeaChecked;

@end
