//
//  LaunchViewController.h
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 19..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "SlideNavigationController.h"



@interface LaunchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *greetinng;
@property (weak, nonatomic) IBOutlet UILabel *welcome;

@property (weak, nonatomic) IBOutlet UIButton *signin;
@property (weak, nonatomic) IBOutlet UIButton *signup;

- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;

@end
