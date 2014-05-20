//
//  AppDelegate.m
//  WHClubBook
//
//  Copyright (c) 2014년 whispr. All rights reserved.

#import "AppDelegate.h"
@interface AppDelegate()

@property (nonatomic, strong)  CLLocationManager *locationManager;
@property (nonatomic, strong)  NSString  *major;    //beacon major no
@property (nonatomic, strong)  NSString  *minor;    //beacon minor no

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Remote notification
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotification != nil)
    {
        int badgeCount = (int)[UIApplication sharedApplication].applicationIconBadgeNumber;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
    }
    
//    Local notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        application.applicationIconBadgeNumber = 1;
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                                                                         UIRemoteNotificationTypeAlert|
                                                                         UIRemoteNotificationTypeBadge|
                                                                         UIRemoteNotificationTypeSound];
    
    //Ibeacon starting and running in background
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    CLBeaconRegion *region;
    
    region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]
                                        initWithUUIDString:@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"]
                                                identifier: @"region1"];
    
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;

    [self.locationManager startMonitoringForRegion:region];
    [self.locationManager stopRangingBeaconsInRegion:region];
    [self.locationManager startRangingBeaconsInRegion:region];
    
    //once login, go to main view directly
    NSString *token = [[CommonDataManager sharedInstance] accessToken];
    if (token != nil) {
        UIStoryboard  *st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [st instantiateViewControllerWithIdentifier:@"WHTabBarController"];
    }
    
    
// local noti test pupose.
//    NSDate *alertTime = [[NSDate date]
//                         dateByAddingTimeInterval:1];
//    UIApplication* app = [UIApplication sharedApplication];
//    UILocalNotification* notifyAlarm = [[UILocalNotification alloc]
//                                        init];
//    if (notifyAlarm)
//    {
//        notifyAlarm.fireDate = alertTime;
//        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
//        notifyAlarm.alertBody = @"Staff meeting in 30 minutes";
//        [app scheduleLocalNotification:notifyAlarm];
//    }
    
    

    return YES;
}

#pragma mark - Local notification delegate
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
        [[UIApplication sharedApplication] cancelLocalNotification:notification];

    //    if ([[notification alertBody] isEqualToString:@"Enter"]) {

        LocalNotiView *localView = [[[NSBundle mainBundle] loadNibNamed:@"LocalNotiView" owner:self options:nil] objectAtIndex:0];
        localView.center = self.window.rootViewController.view.center;
        [localView setup];
        [localView showInView:self.window.rootViewController.view  animated:YES];
//      [self.window.rootViewController.view addSubview:localView];
        
//    }

}
#pragma mark - Remote notification delegate
//Present Remote notification view
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    RemoteNotiView *remoteView = [[[NSBundle mainBundle] loadNibNamed:@"RemoteNotiView" owner:self options:nil] objectAtIndex:0];
    remoteView.center = self.window.rootViewController.view.center;
    [remoteView setupView];
    [self.window.rootViewController.view addSubview:remoteView];
    
}

#pragma mark - apns delegate
//Sending token to the server
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {

    NSMutableString *token = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [newDeviceToken bytes];
    
    for(int i = 0 ; i < 32 ; i++)
    {
        [token appendFormat:@"%02x", ptr[i]];
    }

    if ([[CommonDataManager sharedInstance] accessToken] != nil) {
        [[CommonDataManager sharedInstance] setAPNStoken:token withParam:@"Y"];
        NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken], @"token":token};
        NSURLSessionTask  *task = [[WHHTTPClient sharedClient] apnUpdate:params
                                                              completion:^(NSDictionary *result, NSError *error) {
            if (result[@"success"]) {
                NSLog(@" apns updated in delegation");
            }
        }];
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    } else  {
        [[CommonDataManager sharedInstance] setAPNStoken:token withParam:@"N"];
    }
}

-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

#pragma mark - BeaconManager delegate
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside) {
        NSLog(@"locationManager didDetermineState INSIDE for %@", region.identifier);
    }
    else if(state == CLRegionStateOutside) {
        NSLog(@"locationManager didDetermineState OUTSIDE for %@", region.identifier);
    }
    else {
        NSLog(@"locationManager didDetermineState OTHER for %@", region.identifier);
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
//    NSLog(@" %s", __func__);
//    NSLog(@" beaco count ==>  %ld", [beacons count]);
    
    if ([beacons count]) {
        CLBeacon  *bea = beacons[0];
        self.major = [NSString stringWithFormat:@"%@", bea.major];
        self.minor = [NSString stringWithFormat:@"%@", bea.minor];

        NSDictionary *ibeacon  = @{@"major": self.major, @"minor":self.minor};
        [[CommonDataManager sharedInstance] setCurrentBeacon:ibeacon];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region  {

    
    UILocalNotification *notification = [UILocalNotification new];
    notification.applicationIconBadgeNumber++;
    notification.alertBody = [@"Enter(" stringByAppendingFormat:@" %@, %@)", self.major, self.minor];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

    
    if([[CommonDataManager sharedInstance] accessToken] != nil)  {

        self.major = [[CommonDataManager sharedInstance] currentBeacon][@"major"];
        self.minor = [[CommonDataManager sharedInstance] currentBeacon][@"minor"];

        NSString *beaconKey = [@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6" stringByAppendingFormat:@"%@%@", self.major, self.minor];
        NSLog(@" beaon key(enter) %@", beaconKey);
        
        NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken],@"beacon_key":beaconKey};
        [[WHHTTPClient sharedClient] enterVenue:params completion:^(NSDictionary *result, NSError *error) {
            if(result[@"success"])
                NSLog(@" update enter server");
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region  {
    
    UILocalNotification *notification = [UILocalNotification new];
    self.major = [[CommonDataManager sharedInstance] currentBeacon][@"major"];
    self.minor = [[CommonDataManager sharedInstance] currentBeacon][@"minor"];
    notification.alertBody = [@"Exit(" stringByAppendingFormat:@" %@, %@)", self.major, self.minor];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

    NSString *beaconKey = [@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6" stringByAppendingFormat:@"%@%@", self.major, self.minor];
      NSLog(@" beaon key(exit) %@", beaconKey);
    if ([[CommonDataManager sharedInstance] accessToken] != nil) {
        
        NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken]};
        NSURLSessionTask  *task = [[WHHTTPClient sharedClient] leaveVenue:params completion:^(NSDictionary *result, NSError *error) {
            if (result[@"succcess"]) {
                NSLog(@" update leave server");
            }
        }];
//     [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
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

    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
///      NSLog(@"the notification: %@", localNotification);
        localNotification.applicationIconBadgeNumber= application.applicationIconBadgeNumber+1;
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@" %s" , __func__);
    
//    int badgeCount = (int)[UIApplication sharedApplication].applicationIconBadgeNumber;
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@" %s" , __func__);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@" %s" , __func__);
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
