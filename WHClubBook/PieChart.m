//
//  PieChart.m
//  WHClubCommunity
//
//  Created by yong choi on 2014. 4. 17..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "PieChart.h"



@interface PieChart()

@property(nonatomic,assign) NSUInteger  boyCount;
@property(nonatomic,assign) NSUInteger  girlCount;


@end
@implementation PieChart



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) initWithValues:(NSUInteger) boyCount  withValue2:(NSUInteger) girlCount {
    self.boyCount = boyCount;
    self.girlCount = girlCount;

    [self setRatio];
}

-(void) setRatio {

    NSUInteger bPert =  self.boyCount  * 100 / (self.boyCount + self.girlCount);
    NSUInteger gPert =  self.girlCount * 100 / (self.boyCount + self.girlCount);
    
    self.itemArray = @[[NSNumber numberWithInteger:bPert], [NSNumber numberWithInteger:gPert]];
    self.myColorArray = @[[UIColor redColor], [UIColor greenColor]];
    
}
- (void)drawRect:(CGRect)rect
{
    CGRect chartBound = self.bounds;
    CGPoint center = CGPointMake(chartBound.size.width / 2, chartBound.size.height / 2);
    int radius = (chartBound.size.width) / 2;
    
    int count =(int)[self.itemArray count];
    
    CGFloat angleArray[count];
    CGFloat offset = 0.0f;
    CGFloat startAngle = 0.0;
    CGFloat endAngle   = 0.0;
    CGColorRef  fillColor = nil;
    
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    for(int i=0;i<[self.itemArray count];i++)
    {
        angleArray[i]=(float)(([[self.itemArray objectAtIndex:i] intValue])/(float) 100.0)*(M_PI * 2);
        CGContextMoveToPoint(context, center.x, center.y);
        
        if(i==0) {
            startAngle = - M_PI / 2;
            endAngle   =  angleArray[i] -M_PI / 2;
            fillColor = ((UIColor *) [self.myColorArray objectAtIndex:i]).CGColor;
        } else  {
            startAngle =  offset -M_PI /2;
            endAngle   =  offset+angleArray[i] - M_PI/ 2;
            fillColor = ((UIColor *) [self.myColorArray objectAtIndex:i]).CGColor;
        }
        
        CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
        CGContextSetFillColorWithColor(context, fillColor);
        CGContextClosePath(context);
        CGContextFillPath(context);
        offset+=angleArray[i];
    }
}

@end






//PieClass *myPieClass=[[PieClass alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//myPieClass.center = self.view.center;
//
//myPieClass.itemArray=[[NSArray alloc]initWithObjects:@"60",@"40", nil];
//myPieClass.myColorArray=[[NSArray alloc]initWithObjects:[UIColor yellowColor],[UIColor redColor], nil];
////    myPieClass.radius=60;
//[self.view addSubview:myPieClass];
