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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    categories = [NSArray arrayWithObjects:@"春のおすすめ", @"夏のおすすめ", @"秋のおすすめ", @"冬のおすすめ", @"公園", @"海", nil];
    category_images = [NSArray arrayWithObjects:@"spring.png", @"summer.png", @"autumn.png", @"winter.png", @"park.png", @"sea.png", nil];
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
