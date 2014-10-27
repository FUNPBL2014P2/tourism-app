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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    course_table_model = [[CourseTableModel alloc]init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [course_table_model->course_table_data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Course *course = [course_table_model->course_table_data objectAtIndex:indexPath.row];
    cell.textLabel.text = course.course_name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"所要時間:%d分 距離:%f km 男性消費カロリー:%dkcal 女性消費カロリー:%dkcal", course.time, course.distance, course.male_calories, course.female_calories];
    
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
