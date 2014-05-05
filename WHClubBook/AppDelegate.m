//
//  AppDelegate.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 23..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate()


@property (nonatomic, strong) ESTBeaconManager* beaconManager;
@property (nonatomic, strong) ESTBeaconRegion* beaconRegion;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    
    if(remoteNotification != nil)
    {
        [self application:application didFinishLaunchingWithOptions:remoteNotification];
    }
    
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
    
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                                                                             UIRemoteNotificationTypeAlert|
                                                                             UIRemoteNotificationTypeBadge|
                                                                             UIRemoteNotificationTypeSound];

    }
    

    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
    
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                WHAlert(@"Error", @"network is not available",nil);
                break;
        }
    }];

    
    
    //ibeacon..
    NSLog(@" beacon started");
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                            identifier:@"region1"];
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
//    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    
    return YES;
}

//Local notification
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (notification) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NotificationViewController   *notiVC = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        notiVC.notiIndicator = @"LOCAL";
        [self.window.rootViewController presentViewController:notiVC animated:YES completion:nil];
    }
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"  remote noti  dic  ==>  %@", userInfo);

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NotificationViewController   *notiVC = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    notiVC.notiIndicator = @"REMOTE";
    [self.window.rootViewController presentViewController:notiVC animated:YES completion:nil];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {

    // device token registration
    NSMutableString *token = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [newDeviceToken bytes];
    
    for(int i = 0 ; i < 32 ; i++)
    {
        [token appendFormat:@"%02x", ptr[i]];
    }
    NSLog(@" apns token  ===> %@", token);

}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    NSLog(@" beacon  %ld", [beacons count]  );
}
-(void)beaconManager:(ESTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(ESTBeaconRegion *)region {

    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.beaconManager stopMonitoringForRegion:self.beaconRegion];
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    
    
    if(state == CLRegionStateInside) {
        NSLog(@"locationManager didDetermineState INSIDE Major(%@) Minor(%@)", region.major, region.minor);
    }
    else if(state == CLRegionStateOutside) {
        NSLog(@"locationManager didDetermineState OUTSIDE Major(%@) Minor(%@)", region.major, region.minor);
    }
    else {
        NSLog(@"locationManager didDetermineState OTHER Major(%@) Minor(%@)", region.major, region.minor);
    }
}

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{

    NSLog(@" %s", __func__);
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Enter(ESTIMO)";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    NSLog(@" %s", __func__);
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Exit(ESTIMO)";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}




-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}


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
