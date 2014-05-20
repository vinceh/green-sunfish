//
//  MeMainViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 16..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "MeMainViewController.h"


@interface MeMainViewController ()

@end


@interface MeMainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;

@property (nonatomic,strong)   NSDictionary *myProfile;
@property (nonatomic,strong)   NSString     *successFlag;
@property (nonatomic,assign)   BOOL         editable;
@property (nonatomic,strong)   NSArray      *values;
@property (nonatomic,strong)   UIImage      *myImage;
@property (nonatomic,strong)   UIActivityIndicatorView *activityIndicator;

@end


@implementation MeMainViewController

static NSString *PhotoViewCellIdentifier = @"com.whispr.photoViewCell";
static NSString *MeHistoryCellIdentifier = @"com.whispr.historyViewCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.alpha = 1.0;
    self.activityIndicator.center = CGPointMake(160, 240);
    self.activityIndicator.hidesWhenStopped = NO;
    [self.tableView addSubview:self.activityIndicator];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoViewCell" bundle:nil]
         forCellReuseIdentifier:PhotoViewCellIdentifier];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"MeHistoryViewCell" bundle:nil]
         forCellReuseIdentifier:MeHistoryCellIdentifier];

    self.tableView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0);
}

-(void) reloadView {
    [self requestToServer];
}

//-(void) viewWillAppear:(BOOL)animated {
//    
//    [self requestToServer];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//return (section == 0) ? 1 : 4;
    if (self.tableView == tableView)
        return 1;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        UIImageView *tempImageView;
        NSURL *imageURL1, *imageURL2, *imageURL3;
    
        PhotoViewCell *cell = (PhotoViewCell*)[tableView dequeueReusableCellWithIdentifier:PhotoViewCellIdentifier
                                                                              forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
        [cell.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
        [cell.contentView.layer setBorderWidth:0.5f];
        //cell.contentView.layer.cornerRadius = 5.0f;
    
        for (UIImageView *photoView in cell.contentView.subviews) {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(addNewImage:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            
            switch (photoView.tag) {
                case 0:
                {
                    imageURL1 = [NSURL URLWithString:self.myProfile[@"avatar"]];
                    cell.photoView1.image = [UIImage imageNamed:@"add.jpg"];
                    [cell.photoView1 setImageWithURL:imageURL1
                                    placeholderImage:[UIImage imageNamed:@"add.jpg"]];
                    
                    tempImageView = cell.photoView1;
                    if (imageURL1 != nil) {
                    }
                }
                   break;
                case 1:
                {
                    imageURL2 = [NSURL URLWithString:self.myProfile[@"avatar2"]];
                    cell.photoView2.image = [UIImage imageNamed:@"add.jpg"];
                    cell.photoView2.hidden = (imageURL1 != nil)? NO : YES;
                    [cell.photoView2 setImageWithURL:imageURL2
                                    placeholderImage:[UIImage imageNamed:@"add.jpg"]];

                    tempImageView = cell.photoView2;
                }
                    break;
                case 2:
                {
                    imageURL3 = [NSURL URLWithString:self.myProfile[@"avatar3"]];
                    cell.photoView3.image = [UIImage imageNamed:@"add.jpg"];
                    cell.photoView3.hidden = (imageURL2 != nil)? NO : YES;
                    [cell.photoView3 setImageWithURL:imageURL2
                                    placeholderImage:[UIImage imageNamed:@"add.jpg"]];
                    if (imageURL2 != nil)
                        cell.photoView3.hidden = YES;
                    
                    tempImageView = cell.photoView2;
                }
                    break;
            }
            
            [tempImageView  setUserInteractionEnabled:YES];
            tempImageView.layer.cornerRadius = 10.0f;
            tempImageView.layer.masksToBounds = YES;
            [tempImageView addGestureRecognizer:singleTap];

        }
        
    return cell;

    }else  {
     
        MeHistoryViewCell *cell = (MeHistoryViewCell*)[tableView dequeueReusableCellWithIdentifier:MeHistoryCellIdentifier
                                                                                forIndexPath:indexPath];
        cell.myImageView.image = [UIImage imageNamed:@"profile.png"];
        cell.myHistory.text = @"test  test";
        cell.eventDate.text = @"02.12.12";
    
    return cell;
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    PhotoViewCell *cell = (PhotoViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//    
//    if (![cell selectionStyle] == UITableViewCellSelectionStyleNone)
//        [self performSegueWithIdentifier:@"editSegue" sender:self];
//}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 18)];
//    [label setFont:[UIFont boldSystemFontOfSize:12]];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
//    return view;
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section == 0) {
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 30;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView == tableView)
        return 100;
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

-(void) addNewImage:(UITapGestureRecognizer *)tapGesture{
    
   //UIAction sheet..
    NSLog (@"%lu",(unsigned long)tapGesture.view.tag);
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addRemoveButton:(UIImageView *) imageView {
    
    UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    removeButton.frame = CGRectMake(CGRectGetMinX(imageView.frame),
                                    CGRectGetMinY(imageView.frame),
                                    40,
                                    40);
    
    [removeButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:removeButton];
    
}

-(void) removeImage:(UIButton*) sender {
    
    sender.hidden = YES;
    CGPoint center = sender.superview.center;

    [UIView animateWithDuration:3 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [sender removeFromSuperview];
                         sender.superview.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         sender.superview.center = center;
                     } completion:^(BOOL finished){
                         [sender.superview removeFromSuperview];
                         [sender removeFromSuperview];
                     }];
}



//
//- (IBAction)OnButtonPictureClicked:(id)sender {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:nil
//                                  delegate:self
//                                  cancelButtonTitle:@"취소"
//                                  destructiveButtonTitle:@"사진 촬영"
//                                  otherButtonTitles:@"앨범에서 사진 선택하기", @"삭제하기", nil];
//    
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    //  UIView *keyView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
//    [actionSheet showInView:self.view];
//}
//
//#pragma mark -  ActionSheet Event
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
//    [imagePicker setDelegate:self];
//    [imagePicker setAllowsEditing:YES];
//    if(buttonIndex == 0)    // 카메라 촬영
//    {
//        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//        [self presentViewController:imagePicker animated:YES completion:^{
//            NSLog(@"Camera presentViewControllerAnimated completion: ");
//        }];
//    }
//    else if(buttonIndex == 1)   // 사진 선택
//    {
//        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//        [self presentViewController:imagePicker animated:YES completion:^{
//            NSLog(@"PhotoLibrary presentViewControllerAnimated completion: ");
//        }];
//    }
//    else if(buttonIndex == 2)   // 사진 삭제
//    {
//        _imgView.image = [UIImage imageNamed:@"school_li_photo.png"];
//        _imageTemp = nil;
//        mode =0;
//       // [self SetProfileImage];
//    }
//}




//-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender  {
//    if ([identifier isEqualToString:@"editSegue"] && [self.successFlag isEqualToString:@"YES"]) {
//
//        return YES;
//    }
//    return NO;
//}
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//    NSIndexPath  *indexPath = [self.tableView indexPathForSelectedRow];
//    NSString     *key;
//
//    if (indexPath.section == 1) {
//        switch (indexPath.row) {
//            case 0:  key=@"first_name";    break;
//            case 1:  key=@"last_initial";  break;
//            case 2:  key=@"birthday";      break;
//            case 3:  key=@"gender";        break;
//        }
//    }
//
//    if ([[segue  identifier] isEqualToString:@"editSegue"]) {
//
//        //        EditViewController  *editVC  = [segue destinationViewController];
//        //        editVC.editableField = @{key:self.myProfile[key]};
//    }
//}




@end


