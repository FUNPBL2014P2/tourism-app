//
//  CourseTableViewController.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

@interface CourseTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    CourseModel *course_table_model;
    NSString *course_name; //コース詳細画面に受け渡すコース名
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;
- (IBAction)mySegmentedControlAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic)NSString *course_name; //コース詳細画面に受け渡すコース名

@end
