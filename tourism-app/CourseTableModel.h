//
//  CourseTableModel.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/25.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Course.h"

@interface CourseTableModel : NSObject {
    FMDatabase *database;
    @public
    NSMutableArray *course_table_data;
}

- (id)init;

@end