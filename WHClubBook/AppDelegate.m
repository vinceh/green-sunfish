//
//  AppDelegate.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 23..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    }

       return YES;
    
}

//Local notification
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (notification) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NotificationViewController   *notiVC = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        
        if ([notification.userInfo[@"key"] isEqualToString:@"I"])  {
            notiVC.message.text = @"Welcome";
        }else  {
            notiVC.message.text = @"Bye";
        }
        [self.window.rootViewController presentViewController:notiVC animated:YES completion:nil];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
