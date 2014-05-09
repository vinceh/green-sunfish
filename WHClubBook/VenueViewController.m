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
@property (nonatomic,strong)  NSMutableArray *allVenues;
@property (nonatomic,strong)  NSMutableArray *myFavVenues;
@property (nonatomic,strong)  NSMutableArray *venuesForDisplay;
@property (nonatomic,strong)  UIRefreshControl  *refreshControl;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *targetLocation;
@property (nonatomic,strong)  UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableDictionary *placeDictionary;

@end

static NSString  *VenueViewCellIdentifier = @"com.whispr.VeneuViewCell";
static BOOL  favoriteMode = YES;
VenueTableViewCell *cell;

@implementation VenueViewController

#pragma  mark - Viewcontroller delegate

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor redColor];
    [self.refreshControl addTarget:self action:@selector(requestToServer) forControlEvents:UIControlEventValueChanged];

    /* NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
     [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
     refreshControl.attributedTitle = refreshString; */
    [refreshView addSubview:self.refreshControl];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.alpha = 1.0;
    self.activityIndicator.center = CGPointMake(160, 240);
    self.activityIndicator.hidesWhenStopped = NO;
    [self.tableView addSubview:self.activityIndicator];

    
    
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
  
    
}

- (void)viewDidAppear:(BOOL)animated{
}

-(void) viewWillAppear:(BOOL)animated  {
    [self requestToServer];
    [_locationManager startUpdatingLocation];
    [self updateTableData];

    NSLog(@"  %s", __func__);
}

-(void) updateTableData{
    [self.tableView reloadData];
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
    
    
    NSDictionary *nightlyInfo  = self.venuesForDisplay[indexPath.section][@"nightly"];
    
    NSString *addr = self.venuesForDisplay[indexPath.section][@"address"];
    NSString *city = self.venuesForDisplay[indexPath.section][@"city"];
    NSString *state = self.venuesForDisplay[indexPath.section][@"state"];
    
    
    
    NSString *fullAddress = [NSString stringWithFormat:@"%@ %@ %@", addr, city, state];
      [self coordinate:fullAddress withTagNo:indexPath.section];
    
    

    cell.guestWaitingTime.text =  [NSString stringWithFormat:@"%@", nightlyInfo[@"guest_wait_time"]];
    cell.regWaitingTime.text   =  [NSString stringWithFormat:@"%@", nightlyInfo[@"regular_wait_time"]];
    cell.degree.text = @"20°";

    if (!favoriteMode) {
        [addBtn removeFromSuperview];
        deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [deleteBtn setFrame:CGRectMake(250, 10, 50, 50)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [deleteBtn setTag:indexPath.section];
        [deleteBtn addTarget:self action:@selector(deleteMyfavorite:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bgImageView addSubview:deleteBtn];

    } else  {
        [deleteBtn removeFromSuperview];
        addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addBtn setFrame:CGRectMake(250, 10, 50, 50)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"star.jpg"] forState:UIControlStateNormal];
        [addBtn setTag:indexPath.section];
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
            self.allVenues = [NSMutableArray arrayWithArray:results];
            self.venuesForDisplay = [NSMutableArray arrayWithArray:results];
            self.myFavVenues = [NSMutableArray array];
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
            
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    //[self.refreshControl setRefreshingWithStateOfTask:task];
      [self.refreshControl endRefreshing];
      [self.activityIndicator stopAnimating];
}

-(void) addMyfavorite:(UIButton*)sender  {
    NSLog(@"  tag  ==> %ld", sender.tag);
    [self.myFavVenues addObject:self.allVenues[sender.tag]];
}

-(void)deleteMyfavorite:(UIButton*)sender  {
    
    [self.myFavVenues removeObjectAtIndex:sender.tag];
    [self.venuesForDisplay removeAllObjects];
    [self.venuesForDisplay addObjectsFromArray:self.myFavVenues];
  

//        [UIView transitionWithView: self.tableView
//                      duration: 0.35f
//                       options: UIViewAnimationOptionTransitionCrossDissolve
//                    animations: ^(void)
//     {
//         [self.tableView reloadData];
//     }
//                    completion: ^(BOOL isFinished)
//     {
//     }];
    

//    [self.tableView reloadData];
    
    
    
//    [UIView transitionWithView: self.tableView
//                      duration: 0.35f
//                       options: UIViewAnimationOptionTransitionCrossDissolve
//                    animations: ^(void)
//     {
//         [self.tableView reloadData];
//     }
//                    completion: ^(BOOL isFinished)
//     {
//         /* TODO: Whatever you want here */
//     }];

    
    
}

-(void) showMyFavorite:(id) sender {

    if (favoriteMode) {
        [self.venuesForDisplay removeAllObjects];
        [self.venuesForDisplay addObjectsFromArray:self.myFavVenues];
    }
    else  {
        [self.venuesForDisplay removeAllObjects];
        [self.venuesForDisplay addObjectsFromArray:self.allVenues];
    }

    [self.tableView reloadData];
    favoriteMode = !favoriteMode;
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self updateTableData];
}

-(void) coordinate :(NSString*) address withTagNo:(NSUInteger) tagNo {
    NSLog(@" tag no  %ld", tagNo);
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
 //   dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark* aPlacemark in placemarks)
        {
            self.targetLocation = aPlacemark.location;
//            NSLog(@" address %@", address);
//            NSLog(@" tar ==> %f",self.targetLocation.coordinate.latitude);
//            NSLog(@" tar ==> %f",self.targetLocation.coordinate.longitude);
//            NSLog(@" lat ==> %f",aPlacemark.location.coordinate.latitude);
//            NSLog(@" lon ===>%f",aPlacemark.location.coordinate.longitude);
            
          cell.distance.text = [self updateDistances];
  //         dispatch_semaphore_signal(sem);
        }
    }];
    
  //  dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

-(NSString*) updateDistances {
 
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:self.targetLocation.coordinate.latitude longitude:self.targetLocation.coordinate.longitude];
    
        CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude];
        CLLocationDistance distance = [venueLocation distanceFromLocation:myLocation];
        return [NSString stringWithFormat:@"%.0fkm", distance / 1000];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VenueDetailedViewController  *venueDetailedVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    venueDetailedVC.venueInfo = self.allVenues[indexPath.section];
        venueDetailedVC.venueInfo = self.venuesForDisplay[indexPath.section];
//    venueDetailedVC.meter = [self updateDistances];
    venueDetailedVC.venueLocation = self.targetLocation;
    
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
