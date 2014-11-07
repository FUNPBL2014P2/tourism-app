//
//  SpotDetailViewController.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotDetailViewController : UIViewController {
    NSString *course_name;
    NSString *spot_name;
}

@property NSString *course_name;//コース詳細マップ画面から引き渡されるコース名
@property NSString *spot_name;//コース詳細マップ画面から引き渡されるスポット名

@end
