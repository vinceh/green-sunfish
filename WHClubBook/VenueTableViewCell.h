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

@property (weak, nonatomic) IBOutlet UIView *vipView;
@property (weak, nonatomic) IBOutlet UIView *regularView;
@property (weak, nonatomic) IBOutlet UIView *tempView;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *mapIndicator;
@property (weak, nonatomic) IBOutlet UILabel *vipPercent;
@property (weak, nonatomic) IBOutlet UILabel *regPercent;
@property (weak, nonatomic) IBOutlet UILabel *degree;

@end
