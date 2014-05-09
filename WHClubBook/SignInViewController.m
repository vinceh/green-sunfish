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
    self.title = @"Sign In";
//    
//    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"V" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
//    self.navigationItem.leftBarButtonItem=newBackButton;
    
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

//- (IBAction) back:(id)sender
//{
//    
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//
//    transition.type =  kCATransitionReveal;
//    transition.subtype = kCATransitionFromBottom;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [[self navigationController] popViewControllerAnimated:NO];
//}


-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender  {
    
    
    if([[CommonDataManager sharedInstance] accessToken] == nil)  {
        
        WHAlert(@"Notice", @"Sign up first", nil);
        return NO;
    }
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
    
    [segue destinationViewController];
}

@end
