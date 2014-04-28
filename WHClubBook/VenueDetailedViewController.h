//
//  VenueDetailedViewController.h
//  WHClubCommunity
//
//  Created by yong choi on 2014. 4. 15..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface VenueDetailedViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UILabel *venueInfoLabel;
@property (weak, nonatomic) IBOutlet UITableView *twitterTableView;
@property (weak, nonatomic) IBOutlet UIButton *buyCover;

@property(nonatomic,strong) NSString *venueName;
@property(nonatomic,strong) UITableView *tweetTableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSDictionary  *venue;


- (IBAction)tableCover:(id)sender;


@end
