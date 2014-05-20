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

typedef void(^myPhotos)(BOOL);

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
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
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

	return (section == 0) ? @"PHOTO88" : @"BASIC";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.section == 0)  {

        PhotoViewCell *cell = (PhotoViewCell*)[tableView dequeueReusableCellWithIdentifier:PhotoViewCellIdentifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        switch (indexPath.row) {
             case 0:  {

                 
                 [cell.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
                 [cell.contentView.layer setBorderWidth:0.5f];
                 //cell.contentView.layer.cornerRadius = 5.0f;
                 
                 UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
                 singleTap.numberOfTapsRequired = 1;
                 singleTap.numberOfTouchesRequired = 1;
                 
                 [cell.photoView1  setUserInteractionEnabled:YES];
                 cell.photoView1.layer.cornerRadius = 10.0f;
                 cell.photoView1.layer.masksToBounds = YES;
                 [cell.photoView1 addGestureRecognizer:singleTap];
                 singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
                 singleTap.numberOfTapsRequired = 1;
                 singleTap.numberOfTouchesRequired = 1;
                 
                 [cell.photoView2  setUserInteractionEnabled:YES];
                 cell.photoView2.layer.cornerRadius = 10.0f;
                 cell.photoView2.layer.masksToBounds = YES;
                 [cell.photoView2 addGestureRecognizer:singleTap];
                 singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
                 singleTap.numberOfTapsRequired = 1;
                 singleTap.numberOfTouchesRequired = 1;
                 
                 [cell.photoView3  setUserInteractionEnabled:YES];
                 cell.photoView3.layer.cornerRadius = 10.0f;
                 cell.photoView3.layer.masksToBounds = YES;
                 [cell.photoView3 addGestureRecognizer:singleTap];
                 
                 NSURL *imageURL1, *imageURL2, *imageURL3;
                 
                 
                 for (UIImageView *photoView in cell.contentView.subviews) {
                     
                     if(photoView.tag == 0)  {
                             imageURL1 = [NSURL URLWithString:self.myProfile[@"avatar"]];
                             if(imageURL1 != nil)
                                 [cell.photoView1 setImageWithURL:imageURL1 placeholderImage:[UIImage imageNamed:@"add.jpg"]];
                     } else if(photoView.tag == 1)  {
                             imageURL2 = [NSURL URLWithString:self.myProfile[@"avatar2"]];
                         cell.photoView2.hidden = (imageURL1 != nil)? NO : YES;
                             [cell.photoView2 setImageWithURL:imageURL2 placeholderImage:[UIImage imageNamed:@"add.jpg"]];
                    } else if(photoView.tag == 2)  {
                                                 NSLog(@" tag 2");
                         imageURL3 = [NSURL URLWithString:self.myProfile[@"avatar3"]];
                         [cell.photoView3 setImageWithURL:imageURL2 placeholderImage:[UIImage imageNamed:@"add.jpg"]];
                         if (imageURL2 != nil)
                             cell.photoView3.hidden = YES;
                     }
                   }
                 }
            break;
        }
        return cell;
    }else  {
         BasicProfileCell *cell = (BasicProfileCell*)[tableView dequeueReusableCellWithIdentifier:BasicProfileCellIdentifier forIndexPath:indexPath];
         NSURL *imageURL = [NSURL URLWithString:self.myProfile[@"avatar"]];
         switch (indexPath.row) {
            case 0:
                 [cell.imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"profile"]];
                 break;
            case 1:
                 cell.keyField.text = @"FIRST NAME";
                 cell.valueField.text = self.myProfile[@"first_name"];
                break;
            case 2:
                 cell.keyField.text = @"LAST NAME";
                 cell.valueField.text = self.myProfile[@"last_initial"];
                 break;
            case 3:
                 cell.keyField.text = @"BIRTHDAY";
                 cell.valueField.text = self.myProfile[@"birthday"];
                 break;
            case 4:
                 cell.keyField.text = @"GENDER";
                 cell.valueField.text = self.myProfile[@"gender"];
                 break;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    PhotoViewCell *cell = (PhotoViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];

    if (![cell selectionStyle] == UITableViewCellSelectionStyleNone)
        [self performSegueWithIdentifier:@"editSegue" sender:self];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 30;
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
        
//        EditViewController  *editVC  = [segue destinationViewController];
//        editVC.editableField = @{key:self.myProfile[key]};
    }
}


-(void) imageTapped:(UITapGestureRecognizer *)tapGesture{
    
    NSLog (@"%lu",(unsigned long)tapGesture.view.tag);
    
    
}

-(void) displayMyPhotoBlock:(myPhotos) completion {
    completion(YES);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



