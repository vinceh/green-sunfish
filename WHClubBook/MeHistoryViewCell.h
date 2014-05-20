//
//  MeHistoryViewCell.h
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 16..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeHistoryViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myHistory;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;

@end
