//
//  CourseTableViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "CourseTableViewController.h"

@interface CourseTableViewController ()

@end

@implementation CourseTableViewController

@synthesize course_name;

BOOL isSorted;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

/**
 Viewが表示される直前に呼び出される
 タブ等の切り替え等により、画面に表示されるたびに呼び出される
 */
- (void)viewWillAppear:(BOOL)animated {
    course_table_model = [[CourseModel alloc]init];
    
    //SegmentedContrlの初期状態が「距離順」なので、距離を降順でソート
    [course_table_model getSortedbyDistanceMutableArray:course_table_model->course_table_data];
    //カテゴリ画面でチェックマークがついている項目に対応するコースを検索
    [course_table_model getSearchedbyCategoryMutableArray:course_table_model->course_table_data];
    
    [self.myTableView reloadData];
}

/**
 SegmentedControlが変更された時に呼び出される
 */
- (IBAction)mySegmentedControlAction:(id)sender {
    if(self.mySegmentedControl.selectedSegmentIndex == 0){
        NSLog(@"距離順");
        //距離を降順でソート
        [course_table_model getSortedbyDistanceMutableArray:course_table_model->course_table_data];
        isSorted = YES;
    }else if(self.mySegmentedControl.selectedSegmentIndex == 1){
        NSLog(@"カロリー順");
        //消費カロリー(男性消費カロリー)を降順でソート
        [course_table_model getSortedbyCaloryMutableArray:course_table_model->course_table_data];
        isSorted = YES;
    }else if(self.mySegmentedControl.selectedSegmentIndex == 2){
        NSLog(@"時間順");
        //所要時間を降順でソート
        [course_table_model getSortedbyTimeMutableArray:course_table_model->course_table_data];
        isSorted = YES;
    }
    
    //TableViewの更新
    [self.myTableView reloadData];
}

/**
 @return Cellの高さ
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

/**
 ロード時に呼び出される
 
 @return セクションに含まれるCellの数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [course_table_model->course_table_data count];
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
    
    //タグアイコンの設定
    UIImage *spring_image = [UIImage imageNamed:@"spring_waku.png"];
    UIImageView *spring_tag = [[UIImageView alloc]initWithImage:spring_image];
    spring_tag.frame = CGRectMake(148, 65, 15, 15);
    
    UIImage *summer_image = [UIImage imageNamed:@"summer_waku.png"];
    UIImageView *summer_tag = [[UIImageView alloc]initWithImage:summer_image];
    summer_tag.frame = CGRectMake(168, 65, 15, 15);
    
    UIImage *autumn_image = [UIImage imageNamed:@"autumn_waku.png"];
    UIImageView *autumn_tag = [[UIImageView alloc]initWithImage:autumn_image];
    autumn_tag.frame = CGRectMake(188, 65, 15, 15);
    
    UIImage *winter_image = [UIImage imageNamed:@"winter_waku.png"];
    UIImageView *winter_tag = [[UIImageView alloc]initWithImage:winter_image];
    winter_tag.frame = CGRectMake(208, 65, 15, 15);
    
    UIImage *park_image = [UIImage imageNamed:@"park_waku.png"];
    UIImageView *park_tag = [[UIImageView alloc]initWithImage:park_image];
    park_tag.frame = CGRectMake(228, 65, 15, 15);
    
    UIImage *sea_image = [UIImage imageNamed:@"sea_waku.png"];
    UIImageView *sea_tag = [[UIImageView alloc]initWithImage:sea_image];
    sea_tag.frame = CGRectMake(248, 65, 15, 15);
    
    
    //UITableViewのCellの値がスクロールするごとに重なったり壊れる,UITableViewでCell再描画時に文字が重なる
    //などの問題を防ぐために、CellのsubViewを消去する
    //タグアイコンを表示する前に、以前のsubviewsを削除する
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    //タグアイコンの表示
    for(int i = 0;i < [course_table_model->course_table_data count];i++){
        Course *tag_course = [course_table_model->course_table_data objectAtIndex:i];
        [cell.contentView addSubview:spring_tag];
        [cell.contentView addSubview:summer_tag];
        [cell.contentView addSubview:autumn_tag];
        [cell.contentView addSubview:winter_tag];
        [cell.contentView addSubview:park_tag];
        [cell.contentView addSubview:sea_tag];

        if(indexPath.row == i){
            if(![tag_course.tag_name containsObject:@"春"]){
                spring_tag.alpha = 0.2;
            }
            if(![tag_course.tag_name containsObject:@"夏"]){
                summer_tag.alpha = 0.2;
            }
            if(![tag_course.tag_name containsObject:@"秋"]){
                autumn_tag.alpha = 0.2;
            }
            if(![tag_course.tag_name containsObject:@"冬"]){
                winter_tag.alpha = 0.2;
            }
            if(![tag_course.tag_name containsObject:@"公園"]){
                park_tag.alpha = 0.2;
            }
            if(![tag_course.tag_name containsObject:@"海"]){
                sea_tag.alpha = 0.2;
            }
        }
    }
    
    Course *course = [course_table_model->course_table_data objectAtIndex:indexPath.row];
    cell.textLabel.text = course.course_name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"所要時間:%d分 距離:%.1fkm 男性消費カロリー:%dkcal 女性消費カロリー:%dkcal", course.time, course.distance, course.male_calories, course.female_calories];
    cell.detailTextLabel.numberOfLines = 0; //改行可
    cell.imageView.image = [UIImage imageNamed:course.course_image_name];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/**
 セルタップ時に呼び出される
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //ハイライトを外す
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for(int i = 0;i < [course_table_model->course_table_data count];i++){
        if(indexPath.row == i){
            Course *course = [course_table_model->course_table_data objectAtIndex:i];
            course_name = course.course_name;
            [self performSegueWithIdentifier:@"detail" sender:self];
        }
    }
}

/**
 Segueが実行されると、実行直前に自動的に呼び出される
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CourseTableViewController *nextViewController = (CourseTableViewController*)[segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"detail"]){
        nextViewController.course_name = course_name;
    }
}

///戻るボタンのアクション
- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/**
 Viewの表示が完了後に呼び出される
 画面に表示されるたびに呼び出される
 */
- (void)viewDidAppear:(BOOL)animated {
    //スクロールバーの点滅
    [self.myTableView flashScrollIndicators];
    //表示後の処理
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
