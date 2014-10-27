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
NSString *getCourseDatasSql = @"SELECT * FROM courses;";

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
        
        course_table_data = [NSMutableArray array];
        
        //パスを設定して、データベースオープン
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        FMResultSet *results = [database executeQuery:getCourseDatasSql];
        while ([results next]) {
            Course *course = [[Course alloc]init];
            course.courseid = [results intForColumn:@"courseid"];
            course.course_name = [results stringForColumn:@"course_name"];
            course.distance = [results doubleForColumn:@"distance"];
            course.steps = [results intForColumn:@"steps"];
            course.time = [results intForColumn:@"time"];
            course.male_calories = [results intForColumn:@"male_calories"];
            course.female_calories = [results intForColumn:@"female_calories"];
            course.course_url = [results stringForColumn:@"course_url"];
            [course_table_data addObject:course];
        }
        
        //[results close];
        [database close];
    }
    
    return self;
}

@end
