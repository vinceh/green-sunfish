//
//  VenueDetailedViewController.m
//  WHClubCommunity
//
//  Created by yong choi on 2014. 4. 15..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "VenueDetailedViewController.h"

@interface VenueDetailedViewController ()

@property (nonatomic, strong) NSArray *imageArray;
@end

static NSString *CellIdentifier = @"com.whispr.TwitterCell";

@implementation VenueDetailedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.venue[@"name"];
    self.venueInfoLabel.text = self.venue[@"address"];
    [self setupView];
}

-(void)setupView  {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageArray = [[NSArray alloc] initWithObjects:@"image1.jpg", @"image2.jpg", @"image3.jpg",@"image4.jpg" ,nil];
    
    for (int i = 0; i < [self.imageArray count]; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:i]];
        imageView.clipsToBounds = YES;
         [self.scrollView addSubview:imageView];
    }

     self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.imageArray count], self.scrollView.frame.size.height);
    
    
	self.pageControl.numberOfPages = [self.imageArray count];
    
    //twitter..
//    [self.tweetTableView registerClass:[TwitterTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)getTimeLine {
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =
                 [arrayOfAccounts lastObject];
                 
                 NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                 
                 NSDictionary *parameters = @{@"screen_name" : @"@techotopia",
                                              @"include_rts" : @"0",
                                              @"trim_user" : @"1",
                                              @"count" : @"20"};
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 
                 postRequest.account = twitterAccount;
                 [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                       self.dataSource = [NSJSONSerialization
                                         JSONObjectWithData:responseData
                                         options:NSJSONReadingMutableLeaves
                                         error:&error];
                      if (self.dataSource) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.tweetTableView reloadData];
                          });
                      }
                  }];
             }
         } else {
             // Handle failure to get account access
         }
     }];
}

#pragma mark -
#pragma mark UITableViewDataSource


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)tableCover:(id)sender {
}
@end
