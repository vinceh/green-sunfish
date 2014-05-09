//
//  SettingViewController.h
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 24..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "PhotoViewCell.h"
#import "BasicProfileCell.h"
#import "EditViewController.h"
#import "CommonDataManager.h"
#import "WHHTTPClient.h"
#import "UIAlertView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"



@interface SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SlideNavigationControllerDelegate>

@end
