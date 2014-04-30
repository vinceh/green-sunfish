//
//  NotificationViewController.h
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 28..
//  Copyright (c) 2014년 whispr. All rights reserved.
//


#import "ESTBeacon.h"
#import "ESTBeaconManager.h"




@interface NotificationManager : NSObject <ESTBeaconManagerDelegate>

- (void) startRange;

@end
