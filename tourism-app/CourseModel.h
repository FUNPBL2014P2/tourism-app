//
//  CourseModel.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/30.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Course.h"

@interface CourseModel : NSObject {
    FMDatabase *database;
    @public
    NSMutableArray *course_table_data;
}

- (id)init;
- (Course *) getDataWithName:(NSString *)name;

@end
