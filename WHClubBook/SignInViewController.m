//
//  SignInViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 21..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "SignInViewController.h"


@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

#pragma mark- textfield delegations

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender  {

    if ([[CommonDataManager sharedInstance] accessToken] == nil && [identifier isEqualToString:@"mainViewSegue"])  {
       WHAlert(@"Notice", @"Sign up first", nil);
        return NO;
    }
    if ([identifier isEqualToString:@"launchViewSegue"])  {
        return YES;
    }
    
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
    
    [segue destinationViewController];
}

@end
