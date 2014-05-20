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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *address2;
@property (weak, nonatomic) IBOutlet UILabel *address1;
@property (weak, nonatomic) IBOutlet UILabel *ageLimit;
@property (weak, nonatomic) IBOutlet UILabel *operHour;
@property (weak, nonatomic) IBOutlet UILabel *dressCode;
@property (weak, nonatomic) IBOutlet UILabel *distance;


@property (nonatomic, strong) NSArray *imageArrayURL;
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
    
    [self venueMap];
    
}
 -(void) viewWillDisappear:(BOOL)animated  {
    
    [self.pageControl removeFromSuperview];
    
}
-(void)setupView  {

    self.imageArrayURL = [NSArray arrayWithArray:self.venueInfo[@"images"]];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(120, 0,100,40)];
    [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.numberOfPages = [self.imageArrayURL count];
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
//    self.pageControl.backgroundColor = [UIColor redColor];
//    self.navigationItem.titleView = self.pageControl;

    [self.navigationController.navigationBar addSubview:self.pageControl];
     self.automaticallyAdjustsScrollViewInsets = NO;


    
    for (int i = 0; i < [self.imageArrayURL count]; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setImageWithURL: [NSURL URLWithString:self.imageArrayURL[i]]  placeholderImage:[UIImage imageNamed:@"profile"]];
        imageView.clipsToBounds = YES;
         [self.scrollView addSubview:imageView];
    }
     self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.imageArrayURL count], self.scrollView.frame.size.height);
    
     self.address1.text = self.venueInfo[@"address"];
    
     self.address2.text = self.venueInfo[@"city"];
    self.address2.text = [self.address2.text stringByAppendingString:@"B.C"];
     self.distance.text = self.meter;
     self.segmentControl.selectedSegmentIndex = [self dayOfTheWeek] - 1;
[[UISegmentedControl appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor redColor] } forState:UIControlStateNormal];
}


-(void) venueMap  {

  double latitude  = [self.venueInfo[@"latitude"] doubleValue];
  double longitude = [self.venueInfo[@"longitude"] doubleValue];
  
   CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    VenueAnnotation *annotation = [[VenueAnnotation alloc] initWithCoordinate:coordinate title:self.venueInfo[@"name"]];
    [self.mapView addAnnotation:annotation];

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1609.344, 1609.344);
    [self.mapView setRegion:viewRegion animated:YES];

//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 0.003*METERS_PER_MILE, 0.003*METERS_PER_MILE);
//    [self.mapView setRegion:viewRegion animated:YES];
}

- (NSInteger)dayOfTheWeek {
   
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
//    NSInteger day = [weekdayComponents day];
    NSInteger weekday = [weekdayComponents weekday];
    return weekday;
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
