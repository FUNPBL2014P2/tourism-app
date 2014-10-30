//
//  CourseDetailViewController.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailViewController : UIViewController {
    NSString *course_name; //コース一覧画面から受け取ったコース名
}

@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic)NSString *course_name; //コース一覧画面から受け取ったコース名

@end
