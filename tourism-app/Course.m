//
//  Course.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/25.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "Course.h"
#import "FMDatabase.h"

@implementation Course

@synthesize courseid;
@synthesize course_name;
@synthesize distance;
@synthesize steps;
@synthesize time;
@synthesize male_calories;
@synthesize female_calories;
@synthesize course_url;
@synthesize course_image_name;

@synthesize nearest_stopid;
@synthesize nearest_stop_name;
@synthesize nearest_stop_latitude;
@synthesize nearest_stop_longitude;
@synthesize nearest_stop_type;

@synthesize routeid;
@synthesize route_order;
@synthesize route_latitude;
@synthesize route_longitude;
@synthesize attribute;

@synthesize spotid;
@synthesize spot_name;
@synthesize spot_detail;
@synthesize spot_latitude;
@synthesize spot_longitude;
@synthesize spot_image_name;

@synthesize tagid;
@synthesize tag_name;

- (id)init {
    routeid = [NSMutableArray array];
    route_order = [NSMutableArray array];
    route_latitude = [NSMutableArray array];
    route_longitude = [NSMutableArray array];
    attribute = [NSMutableArray array];
    
    spotid = [NSMutableArray array];
    spot_name = [NSMutableArray array];
    spot_detail = [NSMutableArray array];
    spot_latitude = [NSMutableArray array];
    spot_longitude = [NSMutableArray array];
    spot_image_name = [NSMutableArray array];
    
    tagid = [NSMutableArray array];
    tag_name = [NSMutableArray array];
    
    return self;
}

@end
