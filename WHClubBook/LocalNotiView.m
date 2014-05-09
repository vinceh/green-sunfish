//
//  LocalNotiView.m
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 8..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "LocalNotiView.h"

@implementation LocalNotiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
