//
//  WHTabBarController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 18..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "WHTabBarController.h"

@interface WHTabBarController () <UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@end

@implementation WHTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
    
      NSArray *tabBarTitle = @[@"CHAT", @"PEOPLE", @"VENUE", @"ME"];
    
    [self setSelectedIndex:0];
    
    [[self.viewControllers objectAtIndex:0] setTitle:tabBarTitle[0]];
    [[self.viewControllers[0] tabBarItem] setImage:[[UIImage imageNamed:@"icon1.png"]
                                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    

    [[self.viewControllers objectAtIndex:1] setTitle:tabBarTitle[1]];
    [[self.viewControllers[1] tabBarItem] setImage:[[UIImage imageNamed:@"icon2.png"]
                                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [[self.viewControllers objectAtIndex:2] setTitle:tabBarTitle[2]];
    [[self.viewControllers[2] tabBarItem] setImage:[[UIImage imageNamed:@"icon3.png"]
                                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [[self.viewControllers objectAtIndex:3] setTitle:tabBarTitle[3]];
    [[self.viewControllers[3] tabBarItem] setImage:[[UIImage imageNamed:@"icon4.png"]
                                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];


    
    
// Text appearance values for the tab in normal state
//    NSDictionary *normalState = @{
//                                  NSForegroundColorAttributeName : [UIColor colorWithWhite:0.213 alpha:1.000],
//                                  UITextAttributeTextShadowColor: [UIColor whiteColor],
//                                  UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)]
//                                  };
//    
//    // Text appearance values for the tab in highlighted state
//    NSDictionary *selectedState = @{
//                                    NSForegroundColorAttributeName : [UIColor blackColor],
//                                    UITextAttributeTextShadowColor: [UIColor whiteColor],
//                                    UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)]
//                                    };
    
//    [[UITabBarItem appearance] setTitleTextAttributes:normalState forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:selectedState forState:UIControlStateHighlighted];
    
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
//    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selection.png"]];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

    UINavigationController * navigationController = (UINavigationController *)[tabBarController selectedViewController];

    if ([navigationController.visibleViewController isKindOfClass:[PeopleViewController class]]) {
          [(PeopleViewController*)navigationController.visibleViewController reloadView];
    }
    else if([navigationController.visibleViewController isKindOfClass:[ChatViewController class]]) {
        [(ChatViewController*)navigationController.visibleViewController reloadView];
    }
    else if([navigationController.visibleViewController isKindOfClass:[VenueViewController class]]) {
        [(VenueViewController*)navigationController.visibleViewController reloadView];
    }
    else if([navigationController.visibleViewController isKindOfClass:[MeMainViewController class]]) {
        [(MeMainViewController*)navigationController.visibleViewController reloadView];
    }

    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    [tabBarController.view.layer addAnimation:transition forKey:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
