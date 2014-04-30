//
//  MyViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 20..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "VenueViewController.h"
#import "ESTBeaconManager.h"



@interface VenueViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager* beaconManager;
@property (nonatomic, strong) ESTBeaconRegion* region;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet VenueTableView *tableView;
@property(nonatomic, strong) NSMutableArray *venues;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) CLGeocoder *geocoder;




- (IBAction)selectVenue:(UISegmentedControl *)sender;


@end

static NSString  *VenueViewCellIdentifier = @"com.whispr.VeneuViewCell";
NSString  *indicator = @"N";

@implementation VenueViewController


#pragma mark- initial load view


#pragma  mark - Viewcontroller delegate

-(void)viewWillAppear:(BOOL)animated {
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Venue";
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.tintColor = [UIColor redColor];
    self.segmentControl.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"VenueTableViewCell" bundle:nil] forCellReuseIdentifier:VenueViewCellIdentifier];
    [self requestToServer];
    
    NSLog(@" ibeacon start");
    
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    // create sample region with major value defined
     self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
//                                                                       major:28646 minor:40307
                                                                  identifier: @"EstimoteSampleRegion"];
    
    
//    self.region.notifyOnEntry = YES;
//    self.region.notifyOnExit  = YES;
//    self.region.notifyEntryStateOnDisplay = YES;
    [self.beaconManager startRangingBeaconsInRegion:self.region];
    [self.beaconManager startMonitoringForRegion:self.region];
    [self.beaconManager requestStateForRegion:self.region];

}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"  %s", __func__);

}


-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    
   NSLog(@"  %s", __func__);
    if ([beacons count] > 0) {
    NSLog(@" beacin identity.rssi  = %ld", [beacons[0] rssi]);
    NSLog(@" beacin identity.major  = %@", [beacons[0] major]);
    NSLog(@" beacin identity.minor  = %@", [beacons[0] minor]);
 //    [self.beaconManager stopRangingBeaconsInRegion:self.region];
    }
    
}

-(void)beaconManager:(ESTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(ESTBeaconRegion *)region
{
    NSLog(@"  %s", __func__);
    if(state == CLRegionStateInside)
    {
        NSLog(@"  didDetermine inSide");
    }
    else if( state == CLRegionStateOutside)
    {
        NSLog(@"  didDetermine outside");
    }
    else if (state == CLRegionStateUnknown)  {
        NSLog(@"  didDetermine unknow");
    }

}

-(void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    NSLog(@"  %s", __func__);
    
    NSDictionary  *myAccessToken1 = @{@"key": [[CommonDataManager sharedInstance] accessToken]};
    NSDictionary  *myAccessToken = @{@"key": [[CommonDataManager sharedInstance] accessToken],@"beacon_key":@"B9407F30-F5F8-466E-AFF9-25556B57FE6D2864640307"};
    NSLog(@" my access key = %@", myAccessToken1);
    [[WHHTTPClient sharedClient] enterVenue:myAccessToken completion:^(NSString *result, NSError *error) {
        if(!error)  {
            NSLog(@" server update successfullly  enter ....");
            indicator = @"Y";
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertBody = @"Welcome";
            notification.alertAction = @"View";
            notification.soundName = UILocalNotificationDefaultSoundName;
//          notification.userInfo  = @{@"key":@"I"};
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

        }
    }];
}

-(void)beaconManager:(ESTBeaconManager *)manager  didExitRegion:(ESTBeaconRegion *)region

{
    
    NSLog(@"  %s", __func__);
    
    NSDictionary  *myAccessToken1 = @{@"key": [[CommonDataManager sharedInstance] accessToken]};
    NSDictionary  *myAccessToken = @{@"key": [[CommonDataManager sharedInstance] accessToken],@"beacon_key":@"B9407F30-F5F8-466E-AFF9-25556B57FE6D2864640307"};

    NSLog(@" my access key = %@", myAccessToken1);

    if([indicator isEqualToString:@"Y"])  {
        
        [[WHHTTPClient sharedClient] leaveVenue:myAccessToken completion:^(NSString *result, NSError *error) {
            
            if(!error)  {
                
                NSLog(@" server update successfullly leave ....");

            }
        }];
        
    }
    
}


-(void) viewWillLayoutSubviews  {
    self.tableView.frame = CGRectMake(0, self.topLayoutGuide.length + 52,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.tableView.contentInset = UIEdgeInsetsMake(-3, 0, 0, 0);
    self.segmentControl.frame = CGRectMake(90, self.topLayoutGuide.length + 5,150,40);
}


#pragma mark-  tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    
    return self.venues.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  self.venues[section][@"name"];
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 130.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView   cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VenueTableViewCell *cell = (VenueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:VenueViewCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *nightlyInfo  = self.venues[indexPath.row][@"nightly"];
    NSUInteger guestWaitTime   =  (NSUInteger) nightlyInfo[@"guest_wait_time"];
    NSUInteger regularWaitTime =  (NSUInteger) nightlyInfo[@"regular_wait_time"];

     UIButton * favorite = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [favorite setTitle:@"ADD TO FAV" forState:UIControlStateNormal];
    [favorite setFrame:CGRectMake(230, -4, 90, 24)];
    [favorite setTag:indexPath.row];
    [favorite.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [favorite addTarget:self action:@selector(addMyfavorite:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:favorite];
    
    cell.vipView = (UIView*)[cell viewWithTag:1];
    cell.vipView.layer.cornerRadius = CGRectGetWidth(cell.vipView.frame) / 2;
    
    cell.regularView = (UIView*) [cell viewWithTag:2];
    cell.regularView.layer.cornerRadius = CGRectGetWidth(cell.regularView.frame) / 2;
    cell.tempView = (UIView*)[cell viewWithTag:3];
    cell.tempView.layer.cornerRadius = CGRectGetWidth(cell.tempView.frame) / 2;
    
    cell.vipPercent.text = @"20%";
    cell.regPercent.text = @"30%";
    cell.degree.text = @"20°";
    cell.address.text =  self.venues[indexPath.row][@"address"];
//    [self coordinates:cell.address.text];
    return cell;
}

//venueDetailSegue

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
    NSURLSessionTask  *task = [[WHHTTPClient sharedClient] getVenueList:nil completion:^(NSArray *results, NSError *error) {
        if (!error) {
            //   [self.venues removeAllObjects];
            self.venues = [NSMutableArray arrayWithArray:results];
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
            self.segmentControl.hidden = NO;
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    //[self.refreshControl setRefreshingWithStateOfTask:task];
    
}


-(void) addMyfavorite:(id)sender  {
    
}


- (void) coordinates:(NSString*) clubAddress  {
    
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }

    [self.geocoder geocodeAddressString:clubAddress completionHandler:^(NSArray *placemarks, NSError *error) {

        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            NSLog(@" lat %f", coordinate.latitude);
            NSLog(@" lon %f", coordinate.longitude);
           
        }
    }];
}




#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VenueDetailedViewController  *venueDetailedVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    venueDetailedVC.venue = self.venues[indexPath.section];
    venueDetailedVC.hidesBottomBarWhenPushed  = YES;
//    venueDetailedVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectVenue:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self requestToServer];
            break;
        case 1:
            [self requestToServer];  //with my list..
            break;
    }
}

-(void)dealloc {
    
    NSLog(@" %s", __func__);
    
    [self.beaconManager stopRangingBeaconsInRegion:self.region];

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
