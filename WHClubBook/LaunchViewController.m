//
//  LaunchViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 19..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "LaunchViewController.h"



@interface LaunchViewController () 



@end

@implementation LaunchViewController




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
    // Do any additional setup after loading the view.
    
    self.signin.layer.cornerRadius = 30.0f;
    self.signup.layer.cornerRadius = 30.0f;

    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signIn:(id)sender {
    
    UIStoryboard  *st = [UIStoryboard storyboardWithName:@"SignInView" bundle:nil];
    SignInViewController  *signinVC = [st instantiateInitialViewController];
    signinVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:signinVC animated:YES completion:nil];
}

- (IBAction)signUp:(id)sender {
    
    UIStoryboard  *st = [UIStoryboard storyboardWithName:@"SignUpView" bundle:nil];
    SignUpViewController  *signupVC = [st instantiateInitialViewController];
    signupVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:signupVC animated:YES completion:nil];
}
@end
