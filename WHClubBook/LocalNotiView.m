//
//  LocalNotiView.m
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 8..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "LocalNotiView.h"


@interface LocalNotiView()
@property (weak, nonatomic) IBOutlet UILabel *who;
@property (weak, nonatomic) IBOutlet UILabel *todayMessage;

- (IBAction)seeParticipants:(id)sender;


@end


@implementation LocalNotiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setup {
    //    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.3];
    self.layer.cornerRadius = 5;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];


    button.frame = CGRectMake(CGRectGetMaxX(self.frame) - CGRectGetMinX(self.frame) - 70, CGRectGetMinY(self.frame) - 15, 50,50);
    [self  addSubview:button];
}

- (void)showInView:(UIView *)aView  animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self];
        if (animated) {
            [self animate];
        }
    });
}

//rect  {{28.5, 72}, {263, 424}}

- (void)animate
{
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:2.0
                          delay:0 usingSpringWithDamping:0.5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
        self.transform = CGAffineTransformMakeScale(1, 1);
                         
    } completion:^(BOOL finished) {
        //Completion Block
    }];

}

- (IBAction)seeParticipants:(id)sender {
    
    UIWindow  *window = [UIApplication sharedApplication].keyWindow;
    
    [[((UITabBarController *)window.rootViewController) viewControllers] objectAtIndex:1];
 
    WHTabBarController  *tabBarCTL= ((WHTabBarController *)window.rootViewController);
    
    [tabBarCTL.delegate tabBarController:tabBarCTL shouldSelectViewController:tabBarCTL.viewControllers[1]];
    [tabBarCTL setSelectedIndex:1];
    [self removeFromSuperview];
    
}

-(void) close :(id)sender {
    
    
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        //        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        finished = YES;
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end


//    - (UIImage*)getDarkBlurredImageWithTargetView:(UIView *)targetView
//    {
//        CGSize size = targetView.frame.size;
//        
//        UIGraphicsBeginImageContext(size);
//        CGContextRef c = UIGraphicsGetCurrentContext();
//        CGContextTranslateCTM(c, 0, 0);
//        [targetView.layer renderInContext:c]; // view is the view you are grabbing the screen shot of. The view that is to be blurred.
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return [image applyDarkEffect];
//    }

