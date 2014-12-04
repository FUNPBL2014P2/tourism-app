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
@synthesize spot_name;

CourseModel *course_model;
Course *course;
int numberOfIndexPath_row;

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

- (void)viewWillAppear:(BOOL)animated{
    //ローディング表示を止める処理
    [SVProgressHUD dismiss];
}

/**
 @return Cellの高さ
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

/**
 @return セクションの数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

/**
 ロード時に呼び出される
 
 @return セクションに含まれるCellの数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 8 + [course.spot_name count];
    if(section == 0){
        return 2;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return [course.spot_name count];
    }else if(section == 3){
        return 4;
    }else if (section == 4){
        return 1;
    }
    
    return 0;
}

/**
 @return セクションのヘッダーの高さ
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 75;
}

/**
 @return セクションのタイトル
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"コース詳細";
    }else if(section == 1){
        return @"カテゴリ";
    }else if (section == 2){
        return @"スポット";
    }else if(section == 3){
        return @"コースの特徴";
    }else if (section == 4){
        return @"出典";
    }
    
    return nil;
}

/**
 ロード時に呼び出される
 
 @return セルの内容
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    //UITableViewのCellの値がスクロールするごとに重なったり壊れるなどの問題を防ぐために
    //最初に全てのcell.accessoryTypeをNoneに設定する
    cell.accessoryType = UITableViewCellAccessoryNone;
    //セルを押したとき青くならなくする
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //UITableViewのCellの値がスクロールするごとに重なったり壊れるなどの問題を防ぐために
    //最初に全てのcell.imageView.imageをnilに設定する
    cell.imageView.image = nil;
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.textLabel.text = @"このコースを歩く";
            cell.imageView.image = [UIImage imageNamed:@"map_button.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"健康ウォーキングマップを見る";
            cell.textLabel.numberOfLines = 0;
            cell.imageView.image = [UIImage imageNamed:@"walkingmap_button.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            //タグアイコンの表示
            UIImage *spring_image = [UIImage imageNamed:@"spring.png"];
            UIImageView *spring_tag = [[UIImageView alloc]initWithImage:spring_image];
            spring_tag.frame = CGRectMake(20, 20, 40, 40);
            
            UIImage *spring_on_image = [UIImage imageNamed:@"spring_on.png"];
            UIImageView *spring_on_tag = [[UIImageView alloc]initWithImage:spring_on_image];
            spring_on_tag.frame = CGRectMake(20, 20, 40, 40);
            
            UIImage *summer_image = [UIImage imageNamed:@"summer.png"];
            UIImageView *summer_tag = [[UIImageView alloc]initWithImage:summer_image];
            summer_tag.frame = CGRectMake(65, 20, 40, 40);
            
            UIImage *summer_on_image = [UIImage imageNamed:@"summer_on.png"];
            UIImageView *summer_on_tag = [[UIImageView alloc]initWithImage:summer_on_image];
            summer_on_tag.frame = CGRectMake(65, 20, 40, 40);
            
            UIImage *autumn_image = [UIImage imageNamed:@"autumn.png"];
            UIImageView *autumn_tag = [[UIImageView alloc]initWithImage:autumn_image];
            autumn_tag.frame = CGRectMake(110, 20, 40, 40);
            
            UIImage *autumn_on_image = [UIImage imageNamed:@"autumn_on.png"];
            UIImageView *autumn_on_tag = [[UIImageView alloc]initWithImage:autumn_on_image];
            autumn_on_tag.frame = CGRectMake(110, 20, 40, 40);
            
            UIImage *winter_image = [UIImage imageNamed:@"winter.png"];
            UIImageView *winter_tag = [[UIImageView alloc]initWithImage:winter_image];
            winter_tag.frame = CGRectMake(155, 20, 40, 40);
            
            UIImage *winter_on_image = [UIImage imageNamed:@"winter_on.png"];
            UIImageView *winter_on_tag = [[UIImageView alloc]initWithImage:winter_on_image];
            winter_on_tag.frame = CGRectMake(155, 20, 40, 40);
            
            UIImage *park_image = [UIImage imageNamed:@"park.png"];
            UIImageView *park_tag = [[UIImageView alloc]initWithImage:park_image];
            park_tag.frame = CGRectMake(200, 20, 40, 40);
            
            UIImage *park_on_image = [UIImage imageNamed:@"park_on.png"];
            UIImageView *park_on_tag = [[UIImageView alloc]initWithImage:park_on_image];
            park_on_tag.frame = CGRectMake(200, 20, 40, 40);
            
            UIImage *sea_image = [UIImage imageNamed:@"sea.png"];
            UIImageView *sea_tag = [[UIImageView alloc]initWithImage:sea_image];
            sea_tag.frame = CGRectMake(245, 20, 40, 40);
            
            UIImage *sea_on_image = [UIImage imageNamed:@"sea_on.png"];
            UIImageView *sea_on_tag = [[UIImageView alloc]initWithImage:sea_on_image];
            sea_on_tag.frame = CGRectMake(245, 20, 40, 40);
            
            
            //タグアイコンの透明度の設定
            if(![course.tag_name containsObject:@"春"]){
                [cell.contentView addSubview:spring_tag];
            }else{
                [cell.contentView addSubview:spring_on_tag];
            }
            if(![course.tag_name containsObject:@"夏"]){
                [cell.contentView addSubview:summer_tag];
            }else{
                [cell.contentView addSubview:summer_on_tag];
            }
            if(![course.tag_name containsObject:@"秋"]){
                [cell.contentView addSubview:autumn_tag];
            }else{
                [cell.contentView addSubview:autumn_on_tag];
            }
            if(![course.tag_name containsObject:@"冬"]){
                [cell.contentView addSubview:winter_tag];
            }else{
                [cell.contentView addSubview:winter_on_tag];
            }
            if(![course.tag_name containsObject:@"公園"]){
                [cell.contentView addSubview:park_tag];
            }else{
                [cell.contentView addSubview:park_on_tag];
            }
            if(![course.tag_name containsObject:@"海"]){
                [cell.contentView addSubview:sea_tag];
            }else{
                [cell.contentView addSubview:sea_on_tag];
            }
        }
    }else if(indexPath.section == 2){
        //display size
        CGRect bounds = [[UIScreen mainScreen] bounds];
        
        for(int i = 0;i < [course.spot_name count];i++){
            if(indexPath.row == i){
                //スポット名をCellのViewに追加する
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                    NSLog(@"iPhoneの処理");
                    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.textLabel.frame.origin.x + 130, cell.textLabel.frame.origin.y - 20, bounds.size.width - 190, 120)];
                    textLabel.text = [course.spot_name objectAtIndex:i];
                    textLabel.numberOfLines = 0;
                    [cell.contentView addSubview:textLabel];
                }else{
                    NSLog(@"iPadの処理");
                    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.textLabel.frame.origin.x + 130, cell.textLabel.frame.origin.y - 20, bounds.size.width, 120)];
                    textLabel.text = [course.spot_name objectAtIndex:i];
                    textLabel.numberOfLines = 0;
                    [cell.contentView addSubview:textLabel];
                }
                
                //スポットの画像をCellのViewに追加する
                UIImage *image = [UIImage imageNamed:[course.spot_image_name objectAtIndex:i]];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
                imageView.frame = CGRectMake(10, 0, 110.0f, 79.0f);
                [cell.contentView addSubview:imageView];
                
                //Cellの設定
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
        }
    }else if(indexPath.section == 3){
        if(indexPath.row == 0){
            cell.textLabel.text = [NSString stringWithFormat:@"所要時間:%d分", course.time];
        }else if(indexPath.row == 1){
            cell.textLabel.text = [NSString stringWithFormat:@"移動距離:%.1fkm", course.distance];
        }else if(indexPath.row == 2){
            cell.textLabel.text = [NSString stringWithFormat:@"男性消費カロリー:%dkcal\n女性消費カロリー:%dkcal", course.male_calories, course.female_calories];
            cell.textLabel.numberOfLines = 0; //改行可
        }else if(indexPath.row == 3){
            cell.textLabel.text = [NSString stringWithFormat:@"歩数:%d歩", course.steps];
        }
    }else if(indexPath.section == 4){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Powered by 健康ウォーキングマップ";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }
    
    return cell;
}

/**
 セルタップ時に呼び出される
 */
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //ハイライトを外す
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            //ローディング表示処理
            [SVProgressHUD showWithStatus:@"読み込み中"];

            [self performSegueWithIdentifier:@"detailmap" sender:self];
        }else if(indexPath.row == 1){
            //ローディング表示処理
            [SVProgressHUD showWithStatus:@"読み込み中"];
            
            [self performSegueWithIdentifier:@"walkingmap" sender:self];
        }
    }else if(indexPath.section == 2){
        for(int i = 0;i < [course.spot_name count];i++){
            if(indexPath.row == i){
                spot_name = [course.spot_name objectAtIndex:i];
            }
        }
        [self performSegueWithIdentifier:@"spot_detail" sender:self];
    }else if(indexPath.section == 4){
        if(indexPath.row == 0){
            NSURL *url = [NSURL URLWithString:@"http://www.city.hakodate.hokkaido.jp/docs/2014012700900/"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
 */

/**
 セルタップ時に呼び出される
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //ハイライトを外す
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //セルがタップされたときに呼ばれるアクションの設定
    numberOfIndexPath_row = (int)indexPath.row;

    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            //ローディング表示処理
            [SVProgressHUD showWithStatus:@"読み込み中"];
            
            [self performSelector:@selector(detailmap_segue) withObject:nil afterDelay:0.1];
        }else if(indexPath.row == 1){
            //ローディング表示処理
            [SVProgressHUD showWithStatus:@"読み込み中"];
            
            [self performSelector:@selector(walkingmap_segue) withObject:nil afterDelay:0.1];
        }
    }else if(indexPath.section == 2){
        for(int i = 0;i < [course.spot_name count];i++){
            if(indexPath.row == i){
                spot_name = [course.spot_name objectAtIndex:i];
            }
        }
        
        [self performSegueWithIdentifier:@"spot_detail" sender:self];
    }else if(indexPath.section == 4){
        if(indexPath.row == 0){
            NSURL *url = [NSURL URLWithString:@"http://www.city.hakodate.hokkaido.jp/docs/2014012700900/"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)detailmap_segue {
    [self performSegueWithIdentifier:@"detailmap" sender:self];
}

- (void)walkingmap_segue {
    [self performSegueWithIdentifier:@"walkingmap" sender:self];
}

/**
 Segueが実行されると、実行直前に自動的に呼び出される
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CourseDetailViewController *nextViewController = (CourseDetailViewController*)[segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"walkingmap"]||[[segue identifier] isEqualToString:@"detailmap"]){
        nextViewController.course_name = course_name;
    }else if([[segue identifier] isEqualToString:@"spot_detail"]){
        nextViewController.course_name = course_name;
        nextViewController.spot_name = spot_name;
    }
}

///戻るボタンのアクション
- (IBAction)myNavigationBuckButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
