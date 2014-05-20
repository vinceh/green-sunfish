//
//  RemoteNotiView.h
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 8..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHHTTPClient.h"
#import "UIAlertView+AFNetworking.h"


@interface RemoteNotiView : UIView

@property (weak, nonatomic) IBOutlet UILabel *winnerID;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (strong, nonatomic) NSDictionary *lotteryResult;
@property (strong, nonatomic) NSArray  *lotteryRound;


-(void)setupView;
- (IBAction)dismiss:(id)sender;
@end
