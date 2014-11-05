//
//  CustomAnnotation.m
//  tourism-app
//
//  Created by FUNAICT201311 on 2014/11/05.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

@synthesize coordinate, title;

- (id) initWithCoordinate:(CLLocationCoordinate2D)annotation_point {
    coordinate = annotation_point;
    return self;
}

@end

