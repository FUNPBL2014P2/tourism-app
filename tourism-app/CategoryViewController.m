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

@synthesize isSpringChecked;
@synthesize isSummerChecked;
@synthesize isAutumnChecked;
@synthesize isWinterChecked;
@synthesize isParkChecked;
@synthesize isSeaChecked;

NSArray *categories;
NSArray *category_images;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    categories = [NSArray arrayWithObjects:@"春のおすすめ", @"夏のおすすめ", @"秋のおすすめ", @"冬のおすすめ", @"公園", @"海", nil];
    category_images = [NSArray arrayWithObjects:@"spring.png", @"summer.png", @"autumn.png", @"winter.png", @"park.png", @"sea.png", nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    //ローディング表示処理
    [SVProgressHUD showWithStatus:@"読み込み中"];
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
    
    //cellイメージの大きさを画像ではなくコードで調整できるようにした処理
    UIImage *cellImage = [UIImage imageNamed:[category_images objectAtIndex:indexPath.row]];

    CGSize thumb = CGSizeMake(60, 60);
    UIGraphicsBeginImageContextWithOptions(thumb, NO, 0.0);
    [cellImage drawInRect:CGRectMake(0, 0, thumb.width, thumb.height)];
    cellImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    cell.imageView.image = cellImage;
    
    //春,夏,秋,冬,公園,海それぞれが選択されているか確認し、選択されている場合はチェックマークを付ける
    //選択されていない場合はチェックマークをつけない
    if(indexPath.row == 0){
        if(isSpringChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 1){
        if(isSummerChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 2){
        if(isAutumnChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 3){
        if(isWinterChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 4){
        if(isParkChecked){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(indexPath.row == 5){
        if(isSeaChecked){
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
        if(isSpringChecked){
            isSpringChecked = NO;
        }else{
            isSpringChecked = YES;
        }
    }if(indexPath.row == 1){
        if(isSummerChecked){
            isSummerChecked = NO;
        }else{
            isSummerChecked = YES;
        }
    }if(indexPath.row == 2){
        if(isAutumnChecked){
            isAutumnChecked = NO;
        }else{
            isAutumnChecked = YES;
        }
    }if(indexPath.row == 3){
        if(isWinterChecked){
            isWinterChecked = NO;
        }else{
            isWinterChecked = YES;
        }
    }if(indexPath.row == 4){
        if(isParkChecked){
            isParkChecked = NO;
        }else{
            isParkChecked = YES;
        }
    }if(indexPath.row == 5){
        if(isSeaChecked){
            isSeaChecked = NO;
        }else{
            isSeaChecked = YES;
        }
    }
}

/**
 Segueが実行されると、実行直前に自動的に呼び出される
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CategoryViewController *nextViewController = (CategoryViewController *)[segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"categoryTotable"]){
        nextViewController.isSpringChecked = isSpringChecked;
        nextViewController.isSummerChecked = isSummerChecked;
        nextViewController.isAutumnChecked = isAutumnChecked;
        nextViewController.isWinterChecked = isWinterChecked;
        nextViewController.isParkChecked = isParkChecked;
        nextViewController.isSeaChecked = isSeaChecked;
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
