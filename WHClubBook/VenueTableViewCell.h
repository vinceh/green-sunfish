//
//  VenueTableViewCell.h
//  WHClubCommunity
//
//  Created by yong choi on 2014. 4. 16..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PieChart;

@interface VenueTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *guestWaitingTime;
@property (weak, nonatomic) IBOutlet UILabel *regWaitingTime;
@property (weak, nonatomic) IBOutlet UILabel *degree;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end
