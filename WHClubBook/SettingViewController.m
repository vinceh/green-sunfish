//
//  SettingViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 24..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)   NSDictionary *myProfile;
@property (nonatomic,strong)   NSString     *successFlag;
@property (nonatomic,assign)   BOOL         editable;
@property (nonatomic,strong)   NSArray      *values;
@property (nonatomic,strong)   UIImage      *myImage;
@property (nonatomic,strong)   UIActivityIndicatorView *activityIndicator;

@end

@implementation SettingViewController

static NSString *PhotoViewCellIdentifier = @"com.whispr.photoViewCell";
static NSString *BasicProfileCellIdentifier = @"com.whispr.basicViewCell";

- (void)viewDidLoad
{
    self.title = @"Edit";

    [super viewDidLoad];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.alpha = 1.0;
    self.activityIndicator.center = CGPointMake(160, 240);
    self.activityIndicator.hidesWhenStopped = NO;
    [self.tableView addSubview:self.activityIndicator];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoViewCell" bundle:nil] forCellReuseIdentifier:PhotoViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"BasicProfileCell" bundle:nil] forCellReuseIdentifier:BasicProfileCellIdentifier];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self requestToServer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (section == 0) ? 1 : 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

	return (section == 0) ? @"PHOTO" : @"BASIC";
}
////                 [cell.photoView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"profile"]];

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0)  {
         NSURL *imageURL = [NSURL URLWithString:self.myProfile[@"avatar"]];
        
         PhotoViewCell *cell = (PhotoViewCell*)[tableView dequeueReusableCellWithIdentifier:PhotoViewCellIdentifier forIndexPath:indexPath];
         switch (indexPath.row) {
            case 0:
                 [cell.photoView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"profile"]];
                 break;
        }
        return cell;
    }else  {
         BasicProfileCell *cell = (BasicProfileCell*)[tableView dequeueReusableCellWithIdentifier:BasicProfileCellIdentifier forIndexPath:indexPath];
         switch (indexPath.row) {
            case 0:
                 cell.keyField.text = @"FIRST NAME";
                 cell.valueField.text = self.myProfile[@"first_name"];
                break;
            case 1:
                 cell.keyField.text = @"LAST NAME";
                 cell.valueField.text = self.myProfile[@"last_initial"];
                 break;
            case 2:
                 cell.keyField.text = @"BIRTHDAY";
                 cell.valueField.text = self.myProfile[@"birthday"];
                 break;
            case 3:
                 cell.keyField.text = @"GENDER";
                 cell.valueField.text = self.myProfile[@"gender"];
                 break;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

   [self performSegueWithIdentifier:@"editSegue" sender:self];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }
    return 44;
    
}


-(void) requestToServer  {
    
  [self.activityIndicator startAnimating];
    NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken]};
    NSURLSessionTask  *task = [[WHHTTPClient sharedClient] profile:params completion:^(NSDictionary *result, NSError *error) {
        
        if (result[@"success"])  {
            self.successFlag = @"YES";
            self.myProfile = result[@"data"];
            [self.tableView reloadData];
            [self.activityIndicator  stopAnimating];
        }
    }];
    
[self.activityIndicator  stopAnimating];
    
[UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];

}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender  {
    if ([identifier isEqualToString:@"editSegue"] && [self.successFlag isEqualToString:@"YES"]) {
        
        return YES;
    }
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath  *indexPath = [self.tableView indexPathForSelectedRow];
    NSString     *key;
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:  key=@"first_name";    break;
            case 1:  key=@"last_initial";  break;
            case 2:  key=@"birthday";      break;
            case 3:  key=@"gender";        break;
        }
    }
    
    if ([[segue  identifier] isEqualToString:@"editSegue"]) {
        
        EditViewController  *editVC  = [segue destinationViewController];
        editVC.editableField = @{key:self.myProfile[key]};
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Slider menu delegation
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
	return NO;
}

@end



