//
//  AppDelegate.h
//  WHClubBook
//
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDataManager.h"
#import "WHHTTPClient.h"
#import <CoreLocation/CoreLocation.h>
#import "RemoteNotiView.h"
#import "LocalNotiView.h"
#import "VenueViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
