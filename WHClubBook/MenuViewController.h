//
//  MenuViewController.h
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 23..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationContorllerAnimatorScale.h"

@interface MenuViewController :UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *cellIdentifier;

@end
