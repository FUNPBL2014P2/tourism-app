//
//  CourseTableViewController.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseTableModel.h"

@interface CourseTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    CourseTableModel *course_table_model;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
