//
//  AppDelegate.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 23..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate()


@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion  *beaconRegion;
@property (nonatomic, strong)  NSString  *major;
@property (nonatomic, strong)  NSString  *minor;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Remote notification
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotification != nil)
    {
        [self application:application didFinishLaunchingWithOptions:remoteNotification];
    }
    
    //Local notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];

    if (locationNotification) {
        application.applicationIconBadgeNumber = 1;
    } else  {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"bundle: nil];
        MenuViewController *leftMenu = (MenuViewController*)[mainStoryboard
                                                             instantiateViewControllerWithIdentifier: @"MenuViewController"];
        leftMenu.cellIdentifier = @"leftMenuCell";
        [SlideNavigationController sharedInstance].leftMenu = leftMenu;
        
        id <SlideNavigationContorllerAnimator> revealAnimator;
        revealAnimator = [[SlideNavigationContorllerAnimatorScale alloc] init];
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
            [SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
        }];
    
        
        //APNS
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                                                                             UIRemoteNotificationTypeAlert|
                                                                             UIRemoteNotificationTypeBadge|
                                                                             UIRemoteNotificationTypeSound];
    }
    
    //Network reachability
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                WHAlert(@"Error", @"network is not available",nil);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
            case AFNetworkReachabilityStatusUnknown:
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
        }
    }];

    
    //Ibeacon starting and running in background

    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                            identifier:@"region1"];
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    
    
    
    //once signup forward to the venueView
    
    return YES;
}

#pragma mark - Local notification delegate
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification

{
//    if (notification) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//        LocalNotiViewController   *localNotiVC = [storyboard instantiateViewControllerWithIdentifier:@"LocalNotiViewController"];
//        [self.window.rootViewController presentViewController:localNotiVC animated:YES completion:nil];
        
        LocalNotiView *localView = [[[NSBundle mainBundle] loadNibNamed:@"LocalNotiView" owner:self options:nil] objectAtIndex:0];
        localView.center = self.window.rootViewController.view.center;
        [self.window.rootViewController.view addSubview:localView];

//    }
    
    
    
}
#pragma mark - Remote notification delegate
//Present Remote notification view
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    
    NSLog(@"Remote noti userInfo  ==>  %@", userInfo);
    RemoteNotiView *remoteView = [[[NSBundle mainBundle] loadNibNamed:@"RemoteNotiView" owner:self options:nil] objectAtIndex:0];
      remoteView.center = self.window.rootViewController.view.center;
    [remoteView setupView];
      [self.window.rootViewController.view addSubview:remoteView];
    
}

#pragma mark - apns delegate
//Sending token to the server
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {

    // Device token registration for APNS
    NSMutableString *token = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [newDeviceToken bytes];
    
    for(int i = 0 ; i < 32 ; i++)
    {
        [token appendFormat:@"%02x", ptr[i]];
    }

    
    if ([[CommonDataManager sharedInstance] accessToken] != nil) {
        [[CommonDataManager sharedInstance] setAPNStoken:token withParam:@"Y"];
        NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken], @"token":token};
        NSURLSessionTask  *task = [[WHHTTPClient sharedClient] apnUpdate:params completion:^(NSDictionary *result, NSError *error) {
            if (result[@"success"]) {
                NSLog(@" apns updated in delegation");
            }
        }];
        
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    } else  {
        [[CommonDataManager sharedInstance] setAPNStoken:token withParam:@"N"];
    }
}

-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}


#pragma mark - ESTBeaconManager delegate
- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
  //  NSLog(@" beacon  %ld", [beacons count]  );
    
    if([beacons count] > 0 ) {
        
        ESTBeacon  *beacon = beacons[0];
        
        self.major = [NSString stringWithFormat:@"%@", beacon.major];
        self.minor = [NSString stringWithFormat:@"%@", beacon.minor];
  
        NSDictionary *ibeacon  = @{@"major": self.major, @"minor":self.minor};
        [[CommonDataManager sharedInstance] setCurrentBeacon:ibeacon];
       
    }
}
-(void)beaconManager:(ESTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(ESTBeaconRegion *)region {
//    
//    NSLog(@"  %s", __func__);
//    
//    if(state == CLRegionStateInside) {
//        NSLog(@"locationManager didDetermineState INSIDE Major(%@) Minor(%@)", region.major, region.minor);
//    }
//    else if(state == CLRegionStateOutside) {
//        NSLog(@"locationManager didDetermineState OUTSIDE Major(%@) Minor(%@)", region.major, region.minor);
//    }
//    else {
//        NSLog(@"locationManager didDetermineState OTHER Major(%@) Minor(%@)", region.major, region.minor);
//    }
//    
    
}

//success, data,,
- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
//    NSLog(@" %s ,major ->   %@, minor -> %@", __func__ , region.major, region.minor);
    

    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Enter";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

//    self.major = [NSString stringWithFormat:@"%@", region.major];
//    self.minor = [NSString stringWithFormat:@"%@", region.minor];

    
    if([[CommonDataManager sharedInstance] accessToken] != nil)  {

        self.major = [[CommonDataManager sharedInstance] currentBeacon][@"major"];
        self.minor = [[CommonDataManager sharedInstance] currentBeacon][@"minor"];
        
        NSString *beaconKey = [@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" stringByAppendingFormat:@"%@%@", self.major, self.minor];
        NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken],@"beacon_key":beaconKey};
        NSURLSessionTask  *task = [[WHHTTPClient sharedClient] enterVenue:params completion:^(NSDictionary *result, NSError *error) {

            if(result[@"success"])
                NSLog(@" update enter server");
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    }
}


- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    NSLog(@" %s", __func__);
    
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Exit";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

    
    if ([[CommonDataManager sharedInstance] accessToken] != nil) {

        NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken]};
        NSURLSessionTask  *task = [[WHHTTPClient sharedClient] leaveVenue:params completion:^(NSDictionary *result, NSError *error) {
        if (result[@"succcess"]) {
            NSLog(@" update leave server");
        }
     
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    }
    
}

#pragma mark - app delegate
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@" %s" , __func__);
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@" %s" , __func__);
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@" %s" , __func__);
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@" %s" , __func__);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@" %s" , __func__);
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
