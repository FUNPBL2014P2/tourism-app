//
//  Course.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/25.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Course : NSObject {
    int courseid;
    NSString *course_name;
    double distance;
    int steps;
    int time;
    int male_calories;
    int female_calories;
    NSString *course_url;
}

@property(nonatomic,assign)int courseid;
@property(nonatomic,retain)NSString *course_name;
@property(nonatomic,assign)double distance;
@property(nonatomic,assign)int steps;
@property(nonatomic,assign)int time;
@property(nonatomic,assign)int male_calories;
@property(nonatomic,assign)int female_calories;
@property(nonatomic,retain)NSString *course_url;



@end
