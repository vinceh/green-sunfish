//
//  PhotoUploadViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 24..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "PhotoUploadViewController.h"

@interface PhotoUploadViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, assign) BOOL viewVisible;

- (IBAction)takePic:(id)sender;
- (IBAction)selectPic:(id)sender;
- (IBAction)register:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation PhotoUploadViewController


//-(void) viewDidAppear:(BOOL)animated  {
//    
//     [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
//}
//
//- (void)showcamera {
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    [imagePicker setDelegate:self];
//    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    [imagePicker setAllowsEditing:YES];
//    
//    [self presentViewController:imagePicker animated:YES completion:nil];
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoView.layer.cornerRadius =  CGRectGetWidth(self.photoView.frame) / 2;
    self.photoView.backgroundColor = [UIColor lightGrayColor];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.photoView  addGestureRecognizer:singleTap];
    [self.photoView  setUserInteractionEnabled:YES];
    
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.photoView.image = image;
        [[CommonDataManager sharedInstance] setMyProfileImage:self.photoView.image];
        
        GBPathImageView *img1 = (GBPathImageView *)self.photoView;
        img1.self.originalImage = image;
        [img1 setPathColor:[UIColor yellowColor]];
        [img1 setBorderColor:[UIColor blackColor]];
        [img1 setPathWidth:6.0];
        [img1 setPathType:GBPathImageViewTypeCircle];
        [img1 draw];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) imageTapped:(id) sender {
    
    float originalY;
    
    if(self.viewVisible)  {
        self.viewVisible = NO;
        originalY = 568;
    }
    else {
        self.viewVisible = YES;
        originalY = 400;
    }
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.containerView.frame = CGRectMake(18, originalY,self.containerView.frame.size.width,self.containerView.frame.size.height);
        
    }completion:^(BOOL finished) {
        
    }];
}

- (IBAction)takePic:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        self.viewVisible = !self.viewVisible;
        
    }
}

- (IBAction)selectPic:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        self.viewVisible = !self.viewVisible;
    }
}

- (IBAction)register:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@" %s", __func__);
    [self.activityIndicator startAnimating];

    if ([[segue identifier] isEqualToString:@"venueSegue"])
    {
        NSDictionary *params = [[CommonDataManager sharedInstance] signupParameters];
        NSURLSessionTask  *task = [[WHHTTPClient sharedClient] signUp:params completion:^(NSString *result, NSError *error) {
            
            if(!error) {
                NSString *response = result;
                [[CommonDataManager sharedInstance]  setAccessToken:response];
                [segue destinationViewController];
            }
        }];
        [self.activityIndicator stopAnimating];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];

    }
    
    

    
}


@end
