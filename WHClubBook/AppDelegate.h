//
//  AppDelegate.h
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 23..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "MenuViewController.h"
#import "CommonDataManager.h"
#import "NotificationViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "ESTBeaconManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,ESTBeaconManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
