//
//  NotificationViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 28..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "NotificationManager.h"

@interface NotificationManager () 

@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;
@property (nonatomic, strong) NSArray *beaconsArray;

@end


@implementation NotificationManager


-(id)init {
    NSLog(@"  %s", __func__);
    self = [super init];
    if(self) {
        
        
        self.beaconManager = [[ESTBeaconManager alloc] init];
        self.beaconManager.delegate = self;
        self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                identifier:@"RegionIdentifier"];
    }
    return self;
}


- (void) startRange {
    NSLog(@"  started");
//    self.beaconRegion.notifyOnEntry = YES;
//    self.beaconRegion.notifyOnExit =  YES;
//  self.beaconRegion.notifyEntryStateOnDisplay = YES;

    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];

}

#pragma mark - ESTBeaconManager delegate
    
- (void)beaconManager:(ESTBeaconManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@" %s", __func__);
}

    
- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
     NSLog(@" %s", __func__);
    self.beaconsArray = beacons;
}

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    NSLog(@"  %s", __func__);
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Welcome London Night Club";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    NSLog(@"  %s", __func__);
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"See you next";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = beacons;
}

-(void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error {
    NSLog(@" %s", __func__);
}

-(void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error {
    NSLog(@" %s", __func__);
}

-(void)beaconManager:(ESTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(ESTBeaconRegion *)region {
    NSLog(@"  %s", __func__);
}

-(void)beaconManagerDidStartAdvertising:(ESTBeaconManager *)manager error:(NSError *)error {
    NSLog(@"  %s", __func__);
}


- (void)beaconManager:(ESTBeaconManager *)manager didFailDiscoveryInRegion:(ESTBeaconRegion *)region {
    NSLog(@"  %s", __func__);
}



@end
