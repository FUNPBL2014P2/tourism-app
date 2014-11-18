//
//  SpotDetailViewController.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"
#import "Course.h"

@interface SpotDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSString *course_name;
    NSString *spot_name;
}

- (IBAction)myNavigationBuckButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property NSString *course_name; //コース詳細マップ画面から引き渡されるコース名
@property NSString *spot_name; //コース詳細マップ画面から引き渡されるスポット名

@end
