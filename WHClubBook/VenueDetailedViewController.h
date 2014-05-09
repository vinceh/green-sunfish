//
//  VenueDetailedViewController.h
//  WHClubCommunity
//
//  Created by yong choi on 2014. 4. 15..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UIImageView+AFNetworking.h"
#import "VenueAnnotation.h"

@interface VenueDetailedViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) NSDictionary  *venueInfo;
@property (strong, nonatomic) NSString      *meter;
@property (strong, nonatomic) CLLocation *venueLocation;
@end
