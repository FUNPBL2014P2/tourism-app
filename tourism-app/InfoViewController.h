//
//  InfoViewController.h
//  tourism-app
//
//  Created by 河辺雅史 on 2014/12/02.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface InfoViewController : UIViewController

- (IBAction)myNavigationBuckButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end
