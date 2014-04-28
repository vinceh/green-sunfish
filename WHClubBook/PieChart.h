//
//  PieChart.h
//  WHClubCommunity
//
//  Created by yong choi on 2014. 4. 17..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChart : UIView

@property(nonatomic,retain) NSArray* itemArray;
@property(nonatomic,retain) NSArray* myColorArray;
//@property(nonatomic,assign) int radius;

-(void) initWithValues:(NSUInteger) boyCount  withValue2:(NSUInteger) girlCount;
@end
