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
    
    NSString *token = [[CommonDataManager sharedInstance] accessToken];
    
    if (token != nil) {
        [self performSegueWithIdentifier:@"gotoVenue" sender:nil];
    }
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signIn:(id)sender {
    
}


-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender  {
    return YES;
}

#pragma mark - Navigation
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"gotoVenue"]) {
        [segue destinationViewController];
    }
}
//
//
//if(!self.isNewUser) {
//    
//    UIStoryboard  *st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    VenueViewController  *venueVC = [st instantiateViewControllerWithIdentifier:@"VenueViewController"];
//    [self.window.rootViewController.navigationController pushViewController:venueVC animated:YES];
//    
//}
//





@end
