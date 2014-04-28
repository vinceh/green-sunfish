//
//  MyViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 20..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "VenueViewController.h"


@interface VenueViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet VenueTableView *tableView;
@property(nonatomic, strong) NSMutableArray *venues;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) CLGeocoder *geocoder;


- (IBAction)selectVenue:(UISegmentedControl *)sender;


@end

static NSString  *VenueViewCellIdentifier = @"com.whispr.VeneuViewCell";

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
