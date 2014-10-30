//
//  CourseTableModel.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/25.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "CourseTableModel.h"
#import "FMDatabase.h"

@implementation CourseTableModel
NSString *getCourseDatasSql = @"select distinct * FROM courses left outer join routes ON courses.courseid = routes.coursesid left outer join spots ON courses.courseid = spots.courseid left outer join nearest_stops ON courses.courseid = nearest_stops.coursesid left outer join tags ON courses.courseid = tags.courseid;";

/**
 init（NSObject）を上書きする(コンストラクタ)
 
 Courseインスタンスを生成し、配列にコース情報が格納されたCourseインスタンスを格納する処理
 */
- (id)init{
    self = [super init];
    
    
    if (self != nil) {
        //DBファイルのパスを取得
        NSString *dbPath = nil;
        NSArray *documentsPath = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        
        //取得データ数を確認
        if ([documentsPath count] >= 1) {
            
            //固定で0番目を取得
            dbPath = [documentsPath objectAtIndex:0];
            
            //パスの最後にファイル名を追加
            dbPath = [dbPath stringByAppendingPathComponent:@"walking_map.db"];
        } else {
            
            //エラー
            NSLog(@"database file not found.");
        }
        
        //DBファイルがDocument配下に存在するか判定
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:dbPath]) {
            
            //存在しない場合、DBファイルをコピー(初回起動時のみ)
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *orgPath = [bundle bundlePath];
            orgPath = [orgPath stringByAppendingPathComponent:@"walking_map.db"];
            
            //DBファイルをDocument配下へコピー
            NSError *error = nil;
            if (![fileManager copyItemAtPath:orgPath toPath:dbPath error:&error]) {
                
                //エラー
                NSLog(@"db file copy error. : %@ to %@.", orgPath, dbPath);
            }
        }
        
        //コース情報が格納されたCourseインスタンスを格納する配列
        course_table_data = [NSMutableArray array];
        //Courseインスタンスのコース名に、既に同じコース名が格納されているか確認するための配列
        NSMutableArray *check_contain_coursename = [NSMutableArray array];
        //CourseインスタンスのルートIDに、既に同じルートIDが格納されているか確認するための配列
        NSMutableArray *check_contain_routeid = [NSMutableArray array];
        //CourseインスタンスのスポットIDに、既に同じスポットIDが格納されているか確認するための配列
        NSMutableArray *check_contain_spotid = [NSMutableArray array];
        //CourseインスタンスのタグIDに、既に同じタグIDが格納されているか確認するための配列
        NSMutableArray *check_contain_tagid = [NSMutableArray array];
        
        Course *course;
        
        //パスを設定して、データベースオープン
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        FMResultSet *results = [database executeQuery:getCourseDatasSql];
        while ([results next]) {
            if(![check_contain_coursename containsObject:[results stringForColumn:@"course_name"]]){ //同じコース名が格納されていない場合
                course = [[Course alloc]init];
                
                //コース情報格納
                course.courseid = [results intForColumn:@"courseid"];
                course.course_name = [results stringForColumn:@"course_name"];
                [check_contain_coursename addObject:[results stringForColumn:@"course_name"]];
                course.distance = [results doubleForColumn:@"distance"];
                course.steps = [results intForColumn:@"steps"];
                course.time = [results intForColumn:@"time"];
                course.male_calories = [results intForColumn:@"male_calories"];
                course.female_calories = [results intForColumn:@"female_calories"];
                course.course_url = [results stringForColumn:@"course_url"];
                course.course_image_name = [results stringForColumn:@"course_image_name"];
                
                //最寄り停留所情報格納
                course.nearest_stopid = [results intForColumn:@"nearest_stopid"];
                course.nearest_stop_name = [results stringForColumn:@"nearest_stop_name"];
                course.nearest_stop_latitude = [results doubleForColumn:@"nearest_stop_latitude"];
                course.nearest_stop_longitude = [results doubleForColumn:@"nearest_stop_longitude"];
                
                //ルート情報格納
                [check_contain_routeid addObject:[NSNumber numberWithInt:[results intForColumn:@"routeid"]]];
                [course.routeid addObject:[NSNumber numberWithInt:[results intForColumn:@"routeid"]]];
                [course.route_order addObject:[NSNumber numberWithInt:[results intForColumn:@"route_order"]]];
                [course.route_latitude addObject:[NSNumber numberWithDouble:[results doubleForColumn:@"route_latitude"]]];
                [course.route_longitude addObject:[NSNumber numberWithDouble:[results doubleForColumn:@"route_longitude"]]];
                [course.attribute addObject:[results stringForColumn:@"attribute"]];
                
                //スポット情報格納
                [check_contain_spotid addObject:[NSNumber numberWithInt:[results intForColumn:@"spotid"]]];
                [course.spot_name addObject:[results stringForColumn:@"spot_name"]];
                [course.spot_detail addObject:[results stringForColumn:@"spot_detail"]];
                [course.spot_latitude addObject:[NSNumber numberWithDouble:[results doubleForColumn:@"nearest_stop_latitude"]]];
                [course.spot_longitude addObject:[NSNumber numberWithDouble:[results doubleForColumn:@"nearest_stop_longitude"]]];
                [course.spot_image_name addObject:[results stringForColumn:@"spot_image_name"]];
                
                //タグ情報格納
                if([results stringForColumn:@"tag_name"] != nil){ //コースにタグ情報が存在する場合
                    [check_contain_tagid addObject:[NSNumber numberWithInt:[results intForColumn:@"tagid"]]];
                    [course.tagid addObject:[NSNumber numberWithInt:[results intForColumn:@"tagid"]]];
                    [course.tag_name addObject:[results stringForColumn:@"tag_name"]];
                }
                
                [course_table_data addObject:course];
            }else{ //既に同じコース名が格納されている場合
                //CourseインスタンスのルートIDに、既に同じルートIDが格納されているか確認するための配列に同じルートIDが格納されていない場合、
                //そのCourseインスタンスのルート情報を格納する配列に、ルート情報を格納する
                if(![check_contain_routeid containsObject:[NSNumber numberWithInt:[results intForColumn:@"routeid"]]]){
                    [course.routeid addObject:[NSNumber numberWithInt:[results intForColumn:@"routeid"]]];
                    [check_contain_routeid addObject:[NSNumber numberWithInt:[results intForColumn:@"routeid"]]];
                    [course.route_order addObject:[NSNumber numberWithInt:[results intForColumn:@"route_order"]]];
                    [course.route_latitude addObject:[NSNumber numberWithDouble:[results doubleForColumn:@"route_latitude"]]];
                    [course.route_longitude addObject:[NSNumber numberWithDouble:[results doubleForColumn:@"route_longitude"]]];
                    [course.attribute addObject:[results stringForColumn:@"attribute"]];
                }
                
                //CourseインスタンスのスポットIDに、既に同じスポットIDが格納されているか確認するための配列に同じスポットIDが格納されていない場合、
                //そのCourseインスタンスのスポット情報を格納する配列に、スポット情報を格納する
                if(![check_contain_spotid containsObject:[NSNumber numberWithInt:[results intForColumn:@"spotid"]]]){
                    [course.spot_name addObject:[results stringForColumn:@"spot_name"]];
                    [course.spot_detail addObject:[results stringForColumn:@"spot_detail"]];
                    [course.spot_latitude addObject:[NSNumber numberWithDouble:[results doubleForColumn:@"nearest_stop_latitude"]]];
                    [course.spot_longitude addObject:[NSNumber numberWithDouble:[results doubleForColumn:@"nearest_stop_longitude"]]];
                    [course.spot_image_name addObject:[results stringForColumn:@"spot_image_name"]];
                    
                    [check_contain_spotid addObject:[NSNumber numberWithInt:[results intForColumn:@"spotid"]]];
                }
                
                //コースに何かしらのタグが割り当てられており、
                //CourseインスタンスのタグIDに、既に同じタグIDが格納されているか確認するための配列に同じタグIDが格納されていない場合、
                //そのCourseインスタンスのタグ情報を格納する配列に、タグ情報を格納する
                if([results stringForColumn:@"tag_name"] != nil){
                    if(![check_contain_tagid containsObject:[NSNumber numberWithInt:[results intForColumn:@"tagid"]]]){
                        [course.tagid addObject:[NSNumber numberWithInt:[results intForColumn:@"tagid"]]];
                        [course.tag_name addObject:[results stringForColumn:@"tag_name"]];
                    
                        [check_contain_tagid addObject:[NSNumber numberWithInt:[results intForColumn:@"tagid"]]];
                    }
                }
            }
        }
        
        [database close];
    }
    
    return self;
}

@end
