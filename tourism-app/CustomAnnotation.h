//
//  CustomAnnotation.h
//  tourism-app
//
//  Created by FUNAICT201311 on 2014/11/05.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *frag;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *frag;

- (id) initWithCoordinate:(CLLocationCoordinate2D) annotation_point;

@end