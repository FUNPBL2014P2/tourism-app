//
//  SpotDetailViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "SpotDetailViewController.h"

@interface SpotDetailViewController ()

@end

@implementation SpotDetailViewController
@synthesize course_name;
@synthesize spot_name;

CourseModel *course_model;
Course *course;
NSString *spot_detail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    self.myNavigationItem.title = spot_name;
    
    //コース名を引数に、そのコースのデータを取得する
    course = [course_model getDataWithName:course_name];
    //コース名、スポット名を引数に、引数であるコース名のコースの、引数であるスポット名のスポットの詳細文を取得する
    spot_detail = [course_model getSpotDetailTextWithName:course_name spot_name:spot_name];
   
    // コース名、スポット名を引数に、引数であるコース名のコースの、引数であるスポット名のスポットの画像ファイル名を取得する処理
    NSString *spot_image = [course_model getSpotImageWithName:course_name spot_name:spot_name];
    self.myImageView.image = [UIImage imageNamed:spot_image];
}

/**
 ロード時に呼び出される
 
 @return セクションに含まれるCellの数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/**
 ロード時に呼び出される
 
 @return セルの内容
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.numberOfLines = 0; //改行可
    cell.textLabel.text = spot_detail;
    
    return cell;
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
