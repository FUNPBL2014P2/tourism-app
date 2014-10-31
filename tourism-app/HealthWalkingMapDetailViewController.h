//
//  HealthWalkingMapDetailViewController.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"
#import "Course.h"

@interface HealthWalkingMapDetailViewController : UIViewController {
    NSString *course_name;
}

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@property (nonatomic)NSString *course_name; //コース詳細画面から受け取ったコース名

@end
