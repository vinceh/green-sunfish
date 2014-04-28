//
//  PushCustomSegue.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 24..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "PushCustomSegue.h"

@interface PushCustomSegue ()

@end

@implementation PushCustomSegue

-(void)perform {
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    CATransition* transition = [CATransition animation];
    transition.duration = .25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
}

@end
