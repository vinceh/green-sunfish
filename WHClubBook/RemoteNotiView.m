//
//  RemoteNotiView.m
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 8..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "RemoteNotiView.h"

@implementation RemoteNotiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setupView  {
    
    
    if ([[CommonDataManager sharedInstance] accessToken] != nil) {
        
        NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken]};
        NSURLSessionTask  *task = [[WHHTTPClient sharedClient] lottery:params completion:^(NSDictionary *results, NSError *error) {
            NSLog(@" error");
            
            if (!error) {
                if (results[@"success"]) {
                    self.lotteryResult  = results[@"data"];
                    self.lotteryRound   = self.lotteryResult[@"winnings"];
                    if ([self.lotteryRound count] != 0 ) {
                        self.winnerID.text = self.lotteryRound[0][@"winner_id"];
                        self.message.text = self.lotteryRound[0][@"message"];
                    }
                    else {
                        return;
                    }
                }
            }
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)dismiss:(id)sender {
    
    [self removeFromSuperview];
}
@end
