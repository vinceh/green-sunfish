//
//  MyViewController.h
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 20..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "VenueDetailedViewController.h"
#import "VenueTableViewCell.h"
#import "WHHTTPClient.h"
//#import "UIAlertView+AFNetworking.h"
#import  "VenueTableView.h"
#import "CommonDataManager.h"
#import "UIImageView+AFNetworking.h"
#import "Util.h"



@interface VenueViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

-(void) reloadView;

@end
