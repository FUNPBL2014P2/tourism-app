//
//  CategoryViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

NSArray *categories;
NSArray *category_images;
AppDelegate *appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    categories = [NSArray arrayWithObjects:@"春のおすすめ", @"夏のおすすめ", @"秋のおすすめ", @"冬のおすすめ", @"公園", @"海", nil];
    category_images = [NSArray arrayWithObjects:@"spring.png", @"summer.png", @"autumn.png", @"winter.png", @"park.png", @"sea.png", nil];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    return 6;
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
    
    cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[category_images objectAtIndex:indexPath.row]];
    
    //春,夏,秋,冬,公園,海それぞれが選択されているか確認し、選択されている場合はチェックマークを付ける
    //選択されていない場合はチェックマークをつけない
    if(indexPath.row == 0){
        if(appDelegate.isSpringChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 1){
        if(appDelegate.isSummerChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 2){
        if(appDelegate.isAutumnChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 3){
        if(appDelegate.isWinterChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 4){
        if(appDelegate.isParkChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 5){
        if(appDelegate.isSeaChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

///セルタップ時に呼び出される
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) { //選択されたセルにチェックがついていなかった場合
        cell.accessoryType = UITableViewCellAccessoryCheckmark; //選択されたセルにチェックを入れる
    }else if(cell.accessoryType == UITableViewCellAccessoryCheckmark){ //選択されたセルにチェックがついていた場合
        cell.accessoryType = UITableViewCellAccessoryNone; //選択されたセルのチェックを外す
    }
    
    //春,夏,秋,冬,公園,海それぞれで選択されているか確認し、チェックマークがついたときにはフラグをYESに、
    //チェックマークがついていないときにはフラグをNOにする
    if(indexPath.row == 0){
        if(appDelegate.isSpringChecked){
            appDelegate.isSpringChecked = NO;
        }else{
            appDelegate.isSpringChecked = YES;
        }
    }if(indexPath.row == 1){
        if(appDelegate.isSummerChecked){
            appDelegate.isSummerChecked = NO;
        }else{
            appDelegate.isSummerChecked = YES;
        }
    }if(indexPath.row == 2){
        if(appDelegate.isAutumnChecked){
            appDelegate.isAutumnChecked = NO;
        }else{
            appDelegate.isAutumnChecked = YES;
        }
    }if(indexPath.row == 3){
        if(appDelegate.isWinterChecked){
            appDelegate.isWinterChecked = NO;
        }else{
            appDelegate.isWinterChecked = YES;
        }
    }if(indexPath.row == 4){
        if(appDelegate.isParkChecked){
            appDelegate.isParkChecked = NO;
        }else{
            appDelegate.isParkChecked = YES;
        }
    }if(indexPath.row == 5){
        if(appDelegate.isSeaChecked){
            appDelegate.isSeaChecked = NO;
        }else{
            appDelegate.isSeaChecked = YES;
        }
    }
}

//戻るボタンのアクション
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
