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
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    //コース一覧画面で選択されたコース名
    NSLog(@"%@", course_name);
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
    return 8 + [course.spot_name count];
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
    
    //UITableViewのCellの値がスクロールするごとに重なったり壊れるなどの問題を防ぐために
    //最初に全てのcell.accessoryTypeをNoneに設定する
    cell.accessoryType = UITableViewCellAccessoryNone;
    //セルを押したとき青くならなくする
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //UITableViewのCellの値がスクロールするごとに重なったり壊れる,UITableViewでCell再描画時に文字が重なる
    //などの問題を防ぐために、CellのsubViewを消去する
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    if(indexPath.row == 0){
        //UITableViewのCellの値がスクロールするごとに重なったり壊れる,UITableViewでCell再描画時に文字が重なる問題を防ぐために、
        //cell.textLabel.textに空文字を代入する
        cell.textLabel.text = @"";
        
        UIButton *walkUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [walkUIButton setFrame:CGRectMake(0, 0, 213.0, 37.0)];
        [walkUIButton setCenter:CGPointMake(self.view.frame.size.width/2, 70.0/2.0)];
        [walkUIButton setImage:[UIImage imageNamed:@"walk_course.png"] forState:UIControlStateNormal];
        [walkUIButton setImage:[UIImage imageNamed:@"walk_course.png"] forState:UIControlStateSelected];
        [walkUIButton addTarget:self
                         action:@selector(walkUIButtonDidPush:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [cell setSelectionStyle: (UITableViewCellSelectionStyle)UITableViewCellEditingStyleNone];
        [cell.contentView addSubview:walkUIButton];
    }else if(indexPath.row == 1){
        //UITableViewのCellの値がスクロールするごとに重なったり壊れる,UITableViewでCell再描画時に文字が重なる問題を防ぐために、
        //cell.textLabel.textに空文字を代入する
        cell.textLabel.text = @"";

        UIButton *walkingmapUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [walkingmapUIButton setFrame:CGRectMake(0, 0, 213.0, 37.0)];
        [walkingmapUIButton setCenter:CGPointMake(self.view.frame.size.width/2, 70.0/2.0)];
        [walkingmapUIButton setImage:[UIImage imageNamed:@"see_walkingmap.png"] forState:UIControlStateNormal];
        [walkingmapUIButton setImage:[UIImage imageNamed:@"see_walkingmap.png"] forState:UIControlStateSelected];
        [walkingmapUIButton addTarget:self
                         action:@selector(walkingmapUIButtonDidPush:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [cell setSelectionStyle: (UITableViewCellSelectionStyle)UITableViewCellEditingStyleNone];
        [cell.contentView addSubview:walkingmapUIButton];
    }else if(indexPath.row == 2){
        cell.textLabel.text = [NSString stringWithFormat:@"所要時間:%d分", course.time];
    }else if(indexPath.row == 3){
        cell.textLabel.text = [NSString stringWithFormat:@"移動距離:%.1fkm", course.distance];
    }else if(indexPath.row == 4){
        cell.textLabel.text = [NSString stringWithFormat:@"男性消費カロリー:%dkcal, 女性消費カロリー:%dkcal", course.male_calories, course.female_calories];
        cell.textLabel.numberOfLines = 0; //改行可
    }else if(indexPath.row == 5){
        cell.textLabel.text = [NSString stringWithFormat:@"歩数:%d歩", course.steps];
    }else if(indexPath.row == 6){
        cell.textLabel.text = @"タグ画像を入れる";
    }else if(indexPath.row == 7 + [course.spot_name count]){
        cell.textLabel.text = @"Powered by 健康ウォーキングマップ";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    for(int i = 0;i < [course.spot_name count];i++){
        if(indexPath.row == 7 + i){
            cell.textLabel.text = [course.spot_name objectAtIndex:i];
        }
    }
    
    return cell;
}

/**
 セルタップ時に呼び出される
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //ハイライトを外す
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 7 + [course.spot_name count]){
        NSURL *url = [NSURL URLWithString:@"http://www.city.hakodate.hokkaido.jp/docs/2014012700900/"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

/**
 Cellに入れたボタン(このコースを歩く)が押された際に、呼び出される
 */
- (void)walkUIButtonDidPush:(UIButton*)sender {
    [self performSegueWithIdentifier:@"detailmap" sender:self];
}

/**
 Cellに入れたボタン(健康ウォーキングマップを見る)が押された際に、呼び出される
 */
- (void)walkingmapUIButtonDidPush:(UIButton*)sender {
    [self performSegueWithIdentifier:@"walkingmap" sender:self];
}


///戻るボタンのアクション
- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
