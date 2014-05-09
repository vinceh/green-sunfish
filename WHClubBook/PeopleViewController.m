//
//  PeopleViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 4..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "PeopleViewController.h"

@interface PeopleViewController ()

@end

@implementation PeopleViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return 32;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PeopleCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"peopleCell" forIndexPath:indexPath];
    
//  NSString *imageToLoad = [NSString stringWithFormat:@"%ld.JPG",indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"image2.jpg"];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailSegue"])
    {
//        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
//        NSString *imageNameToLoad = [NSString stringWithFormat:@"%ld_full", selectedIndexPath.row];
        NSString *pathToImage = [[NSBundle mainBundle] pathForResource:@"image2"ofType:@"jpg"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathToImage];
        PeopleDetailViewController  *detailVC = [segue destinationViewController];
        detailVC.image = image;
    }
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


@end
