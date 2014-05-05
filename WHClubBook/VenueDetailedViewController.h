//
//  VenueDetailedViewController.h
//  WHClubCommunity
//
//  Created by yong choi on 2014. 4. 15..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface VenueDetailedViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *address2;

@property (weak, nonatomic) IBOutlet UILabel *address1;
@property (weak, nonatomic) IBOutlet UILabel *ageLimit;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (strong, nonatomic) NSDictionary  *venueInfo;

@property (weak, nonatomic) IBOutlet UILabel *sun;
@property (weak, nonatomic) IBOutlet UILabel *mon;
@property (weak, nonatomic) IBOutlet UILabel *tue;
@property (weak, nonatomic) IBOutlet UILabel *wed;
@property (weak, nonatomic) IBOutlet UILabel *thu;
@property (weak, nonatomic) IBOutlet UILabel *fri;
@property (weak, nonatomic) IBOutlet UILabel *sat;

@end
