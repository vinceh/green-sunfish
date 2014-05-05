//
//  MyViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 20..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "VenueViewController.h"

@interface VenueViewController () <CLLocationManagerDelegate>

@property (weak,nonatomic) IBOutlet VenueTableView *tableView;
@property (weak,nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) NSMutableArray *venues;
@property (nonatomic,strong) NSMutableArray *myVenues;
@property (nonatomic,strong) NSMutableArray *venuesForDisplay;

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *targetLocation;
@end

static NSString  *VenueViewCellIdentifier = @"com.whispr.VeneuViewCell";
static BOOL  favoriteMode = YES;
VenueTableViewCell *cell;

@implementation VenueViewController

#pragma  mark - Viewcontroller delegate

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
//  self.title = @"Venue";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 40.0f)];
    [btn addTarget:self action:@selector(showMyFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"star.jpg"] forState:UIControlStateNormal];
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = eng_btn;

    [self.tableView registerNib:[UINib nibWithNibName:@"VenueTableViewCell" bundle:nil] forCellReuseIdentifier:VenueViewCellIdentifier];
    [self requestToServer];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [_locationManager startUpdatingLocation];
    [self updateTableData];
}

-(void) updateTableData{
    [self.tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated  {
    NSLog(@"  %s", __func__);

}


-(void) viewWillLayoutSubviews  {
    self.tableView.frame = CGRectMake(0, self.topLayoutGuide.length + 52,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.tableView.contentInset = UIEdgeInsetsMake(-3, 0, 0, 0);
}

#pragma mark-  tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    
    return self.venuesForDisplay.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  self.venuesForDisplay[section][@"name"];
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 130.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView   cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = (VenueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:VenueViewCellIdentifier forIndexPath:indexPath];
    UIButton * addBtn,*deleteBtn;
    
    NSURL  *imageURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"club" ofType:@"jpg"]];
    [cell.bgImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    
    
    NSDictionary *nightlyInfo  = self.venuesForDisplay[indexPath.row][@"nightly"];
    [self coordinates:self.venues[indexPath.row][@"address"]];
    
    cell.distance.text = [self updateDistances];
    cell.guestWaitingTime.text =  [NSString stringWithFormat:@"%@", nightlyInfo[@"guest_wait_time"]];
    cell.regWaitingTime.text   =  [NSString stringWithFormat:@"%@", nightlyInfo[@"regular_wait_time"]];
    cell.degree.text = @"20°";

    if (!favoriteMode) {
        [addBtn removeFromSuperview];
        deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [deleteBtn setFrame:CGRectMake(250, 10, 50, 50)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [deleteBtn setTag:indexPath.row];
        [deleteBtn addTarget:self action:@selector(deleteMyfavorite:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bgImageView addSubview:deleteBtn];

    } else  {
        [deleteBtn removeFromSuperview];
        addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addBtn setFrame:CGRectMake(250, 10, 50, 50)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"star.jpg"] forState:UIControlStateNormal];
        [addBtn setTag:indexPath.row];
        [addBtn addTarget:self action:@selector(addMyfavorite:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bgImageView addSubview:addBtn];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"venueDetailSegue" sender:tableView];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width,20)];
    lbl.backgroundColor = [UIColor lightGrayColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    //  lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    lbl.text = [self tableView:tableView titleForHeaderInSection:section];
    lbl.textColor = [UIColor blackColor];
    
    return lbl;
}


#pragma mark - cloud  integration
-(void) requestToServer {
    
    [self.activityIndicator startAnimating];
    NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken]};
    NSURLSessionTask  *task = [[WHHTTPClient sharedClient] getVenueList:params completion:^(NSArray *results, NSError *error) {
        if (!error) {
            //   [self.venues removeAllObjects];
            self.venues = [NSMutableArray arrayWithArray:results];
            self.venuesForDisplay = [NSMutableArray arrayWithArray:results];
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
            self.myVenues = [NSMutableArray array];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    //[self.refreshControl setRefreshingWithStateOfTask:task];
}

-(void) addMyfavorite:(UIButton*)sender  {
    [self.myVenues addObject:self.venues[sender.tag]];
}

-(void)deleteMyfavorite:(UIButton*)sender  {
    
    [self.myVenues removeObjectAtIndex:sender.tag];
    [self.venuesForDisplay removeAllObjects];
    [self.venuesForDisplay addObjectsFromArray:self.myVenues];
    [self.tableView reloadData];
}

-(void) showMyFavorite:(id) sender {

    if (favoriteMode) {
        [self.venuesForDisplay removeAllObjects];
        [self.venuesForDisplay addObjectsFromArray:self.myVenues];
    }
    else  {
        [self.venuesForDisplay removeAllObjects];
        [self.venuesForDisplay addObjectsFromArray:self.venues];
    }

    [self.tableView reloadData];
    favoriteMode = !favoriteMode;
}



#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self updateTableData];
}

- (void) coordinates:(NSString*) clubAddress  {
    
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    [self.geocoder geocodeAddressString:@"1150 Granville st vancouver BC" completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.targetLocation = placemark.location;
            CLLocationCoordinate2D coordinate = self.targetLocation.coordinate;
            NSLog(@" lat %f", coordinate.latitude);
            NSLog(@" lon %f", coordinate.longitude);
        }
    }];
}

-(NSString*) updateDistances{
    
        CLLocationCoordinate2D my2DLocation = self.targetLocation.coordinate;
        CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:my2DLocation.latitude longitude:my2DLocation.longitude];
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude];
        CLLocationDistance distance = [myLocation distanceFromLocation:newLocation];
       return [NSString stringWithFormat:@"%.0fkm", distance / 1000];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VenueDetailedViewController  *venueDetailedVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    venueDetailedVC.venueInfo = self.venues[indexPath.section];
    venueDetailedVC.hidesBottomBarWhenPushed  = YES;
//  venueDetailedVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SlideNavigationController Methods -
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
	return NO;
}

@end
