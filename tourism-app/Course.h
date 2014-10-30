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
    NSString *course_image_name;
    
    int nearest_stopid;
    NSString *nearest_stop_name;
    double nearest_stop_latitude;
    double nearest_stop_longitude;
    
    NSMutableArray *routeid;
    NSMutableArray *route_order;
    NSMutableArray *route_latitude;
    NSMutableArray *route_longitude;
    NSMutableArray *attribute;
    
    NSMutableArray *spotid;
    NSMutableArray *spot_name;
    NSMutableArray *spot_detail;
    NSMutableArray *spot_latitude;
    NSMutableArray *spot_longitude;
    NSMutableArray *spot_image_name;
    
    NSMutableArray *tagid;
    NSMutableArray *tag_name;
}

@property(nonatomic,assign)int courseid;
@property(nonatomic,retain)NSString *course_name;
@property(nonatomic,assign)double distance;
@property(nonatomic,assign)int steps;
@property(nonatomic,assign)int time;
@property(nonatomic,assign)int male_calories;
@property(nonatomic,assign)int female_calories;
@property(nonatomic,retain)NSString *course_url;
@property(nonatomic,retain)NSString *course_image_name;

@property(nonatomic,assign)int nearest_stopid;
@property(nonatomic,retain)NSString *nearest_stop_name;
@property(nonatomic,assign)double nearest_stop_latitude;
@property(nonatomic,assign)double nearest_stop_longitude;

@property(nonatomic,retain)NSMutableArray *routeid;
@property(nonatomic,retain)NSMutableArray *route_order;
@property(nonatomic,retain)NSMutableArray *route_latitude;
@property(nonatomic,retain)NSMutableArray *route_longitude;
@property(nonatomic,retain)NSMutableArray *attribute;

@property(nonatomic,retain)NSMutableArray *spotid;
@property(nonatomic,retain)NSMutableArray *spot_name;
@property(nonatomic,retain)NSMutableArray *spot_detail;
@property(nonatomic,retain)NSMutableArray *spot_latitude;
@property(nonatomic,retain)NSMutableArray *spot_longitude;
@property(nonatomic,retain)NSMutableArray *spot_image_name;

@property(nonatomic,retain)NSMutableArray *tagid;
@property(nonatomic,retain)NSMutableArray *tag_name;

@end
