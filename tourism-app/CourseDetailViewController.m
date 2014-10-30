//
//  CourseDetailViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "CourseDetailViewController.h"

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController

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
    
    //NavigationBarのタイトルをコース名に設定
    self.myNavigationItem.title = course_name;
    //UIImageViewをコース画像に設定
    [self.myImageView setImage:[UIImage imageNamed:course.course_image_name]];
    
    //コース一覧画面で選択されたコース名
    NSLog(@"%@", course_name);
}

//戻るボタンのアクション
- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
