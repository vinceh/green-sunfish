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

@property (nonatomic,strong)   NSDictionary        *myProfile;
@property (nonatomic,assign)   BOOL editable;
@property (nonatomic,strong)   NSArray  *values;
@property (nonatomic,strong)   UIImage  *myImage;

@end


@implementation SettingViewController

static NSString *PhotoViewCellIdentifier = @"com.whispr.photoViewCell";
static NSString *BasicProfileCellIdentifier = @"com.whispr.basicViewCell";



- (void)viewDidLoad
{
    self.title = @"Edit";

    [super viewDidLoad];
    
//    NOT YET..
//    [self.activityIndicator startAnimating];
    
//    NSDictionary  *params = [[CommonDataManager sharedInstance] signupParameters];
//    NSURLSessionTask  *task = [[WHHTTPClient sharedClient] XXXX:params completion:^(NSString *result, NSError *error) {
//        if(!error) {
//      self.values =  [XX values];
//        }
//        
//    }];
//    [self.activityIndicator stopAnimating];
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    
    self.myProfile = @{@"first_name":@"firstname", @"last_initial":@"last",@"birthday":@"11-11-2012",@"email":@"e@gmail.com",@"gender":@"M",@"avatar":@"www.xxx.xxx/xxx.jpg"};
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoViewCell" bundle:nil] forCellReuseIdentifier:PhotoViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"BasicProfileCell" bundle:nil] forCellReuseIdentifier:BasicProfileCellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (section == 0) ? 1 : 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return (section == 0) ? @"PHOTO" : @"BASIC";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0)  {
         PhotoViewCell *cell = (PhotoViewCell*)[tableView dequeueReusableCellWithIdentifier:PhotoViewCellIdentifier forIndexPath:indexPath];
         switch (indexPath.row) {
            case 0:
                 cell.photoView.image = [UIImage imageNamed:@"image1.jpg"];   //self.myImage..
                 break;
        }
        return cell;
    }else  {
         BasicProfileCell *cell = (BasicProfileCell*)[tableView dequeueReusableCellWithIdentifier:BasicProfileCellIdentifier forIndexPath:indexPath];
         switch (indexPath.row) {
            case 0:
                cell.keyField.text = @"FIRST NAME";
                cell.valueField.text = @"KKKKK";  //self.values[indexPath.row]
                break;
            case 1:
                 cell.keyField.text = @"LAST NAME";  //self.values[indexPath.row]
                 cell.valueField.text = @"KKKKK";  //self.values[indexPath.row]
                 break;
            case 2:
                 cell.keyField.text = @"EMAIL";  //self.values[indexPath.row]
                 cell.valueField.text = @"KKKKK";  //self.values[indexPath.row]
                 break;
            case 3:
                 cell.keyField.text = @"BIRTHDAY";  //self.values[indexPath.row]
                 cell.valueField.text = @"KKKKK";  //self.values[indexPath.row]
                 break;
            case 4:
                 cell.keyField.text = @"GENDER";  //self.values[indexPath.row]
                 cell.valueField.text = @"KKKKK";  //self.values[indexPath.row]
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


//-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender  {
//    if ([identifier isEqualToString:@"editSegue"]) {
//        return NO;
//    }
//    return NO;
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath  *indexPath = [self.tableView indexPathForSelectedRow];
    NSString     *key;
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:  key=@"first_name";    break;
            case 1:  key=@"last_initial";  break;
            case 2:  key=@"email";         break;
            case 3:  key=@"birthday";      break;
            case 4:  key=@"gender";        break;
        }
    }
    
    if ([[segue  identifier] isEqualToString:@"editSegue"]) {
        
        EditViewController  *editVC  = [segue destinationViewController];
        editVC.editableField = @{key:self.myProfile[key]};
    }
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



