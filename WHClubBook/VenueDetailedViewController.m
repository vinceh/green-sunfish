//
//  VenueDetailedViewController.m
//  WHClubCommunity
//
//  Created by yong choi on 2014. 4. 15..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#define METERS_PER_MILE 11609.344

#import "VenueDetailedViewController.h"

@interface VenueDetailedViewController () <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIPageControl  *pageControl;

@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view


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

    self.mapView.delegate  =self;

    self.mapView.showsUserLocation = YES;
    
//    CLLocationCoordinate2D coordinate1;
//    coordinate1.latitude = 40.740384;
//    coordinate1.longitude = -73.991146;
//    myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:coordinate1 title:@"Starbucks NY"];
//    [self.mapView addAnnotation:annotation];
    
    
//    CLLocationCoordinate2D coordinateArray[2];
//    coordinateArray[0] = CLLocationCoordinate2DMake(lat1, lon1);
//    coordinateArray[1] = CLLocationCoordinate2DMake(lat2, lon2);
    
    
//    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
//    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
//    
//    [self.mapView addOverlay:self.routeLine];
//    

    
    [self setupView];
}
-(void) viewWillAppear:(BOOL)animated {
    
    
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = 40.740848;
//    zoomLocation.longitude= -73.991145;
//    // 2
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.003*METERS_PER_MILE, 0.003*METERS_PER_MILE);
//    [self.mapView setRegion:viewRegion animated:YES];
    
    
}
-(void)viewDidAppear:(BOOL)animated {

}
-(void) viewWillDisappear:(BOOL)animated  {
    
    [self.pageControl removeFromSuperview];
    
    
    
}
-(void)setupView  {

    self.sun.layer.borderWidth = 1.0f;
    self.sun.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mon.layer.borderWidth = 1.0f;
    self.mon.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tue.layer.borderWidth = 1.0f;
    self.tue.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.wed.layer.borderWidth = 1.0f;
    self.wed.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.thu.layer.borderWidth = 1.0f;
    self.thu.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.fri.layer.borderWidth = 1.0f;
    self.fri.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.sat.layer.borderWidth = 1.0f;
    self.sat.layer.borderColor = [UIColor lightGrayColor].CGColor;

    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(120, 0,100,40)];
    [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
//    self.pageControl.backgroundColor = [UIColor redColor];
//    self.navigationItem.titleView = self.pageControl;

    [self.navigationController.navigationBar addSubview:self.pageControl];
    

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
    
    
     self.address1 = self.venueInfo[@"address"];
//	self.pageControl.numberOfPages = [self.imageArray count];
    
}

#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

-(void) pageTurn:(UIPageControl*) sender {
    [UIView  animateWithDuration:0.5f animations:^{
        self.scrollView.contentOffset = CGPointMake(320.0f *sender.currentPage, 0.0f);
    } completion:^(BOOL finished) {
    }];
}



     
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
