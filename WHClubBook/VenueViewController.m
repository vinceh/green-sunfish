//
//  MyViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 20..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "VenueViewController.h"

@interface VenueViewController () <CLLocationManagerDelegate>

@property (weak,nonatomic)    IBOutlet VenueTableView *tableView;

@property (nonatomic,strong)  NSMutableArray *allVenues;
@property (nonatomic,strong)  NSMutableArray *myVenueList;
@property (nonatomic,strong)  NSMutableArray *venuesForDisplay;
@property (nonatomic,strong)  UIRefreshControl  *refreshControl;
@property (nonatomic,strong) CLGeocoder *geocoder;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,assign) CLLocationDegrees  latitude;
@property (nonatomic,assign) CLLocationDegrees  longitude;
@property (nonatomic,strong)  UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) NSMutableDictionary *placeDictionary;

@end


static NSString  *VenueViewCellIdentifier = @"com.whispr.VeneuViewCell";
static BOOL  favoriteMode = NO;
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
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.alpha = 1.0;
    self.activityIndicator.center = CGPointMake(160, 240);
    self.activityIndicator.hidesWhenStopped = YES;
    [self.tableView addSubview:self.activityIndicator];

    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
//    [_locationManager startUpdatingLocation];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 40.0f)];
    [btn addTarget:self action:@selector(showMyFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"star.jpg"] forState:UIControlStateNormal];
    UIBarButtonItem  *favoriteButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = favoriteButton;

    [self.tableView registerNib:[UINib nibWithNibName:@"VenueTableViewCell" bundle:nil] forCellReuseIdentifier:VenueViewCellIdentifier];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void) reloadView {

    [self requestToServer];
    [_locationManager startUpdatingLocation];
    [self updateTableData];

}

- (void)viewDidAppear:(BOOL)animated{
}

-(void) viewWillAppear:(BOOL)animated  {

    [self requestToServer];
    [_locationManager startUpdatingLocation];
    [self updateTableData];

}

-(void) viewWillDisappear:(BOOL)animated {
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [_locationManager startUpdatingLocation];
    [_locationManager stopUpdatingLocation];
    
}

-(void) viewWillLayoutSubviews  {
    self.tableView.frame = CGRectMake(0, self.topLayoutGuide.length + 52,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.tableView.contentInset = UIEdgeInsetsMake(-3, 0, 0, 0);
}



-(void) updateTableData{
    [self.tableView reloadData];
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
    
   
    
    
    cell = (VenueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:VenueViewCellIdentifier
                                                                 forIndexPath:indexPath];
    UIButton * addBtn,*deleteBtn;
    
    NSURL  *imageURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"club" ofType:@"jpg"]];
    [cell.bgImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];

    NSDictionary *nightlyInfo  = self.venuesForDisplay[indexPath.section][@"nightly"];
    cell.guestWaitingTime.text =  [NSString stringWithFormat:@"%@", nightlyInfo[@"guest_wait_time"]];
    cell.regWaitingTime.text   =  [NSString stringWithFormat:@"%@", nightlyInfo[@"regular_wait_time"]];
    
    self.latitude   =  [self.venuesForDisplay[indexPath.section][@"latitude"] doubleValue];
    self.longitude  =  [self.venuesForDisplay[indexPath.section][@"longitude"] doubleValue];
    cell.distance.text = [self updateDistances];

    cell.degree.text = @"20°";
    
 
    if (favoriteMode) {
        [addBtn removeFromSuperview];
        deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [deleteBtn setFrame:CGRectMake(250, 10, 50, 50)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [deleteBtn setTag:indexPath.section];
        [deleteBtn addTarget:self action:@selector(removeMyfavorite:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bgImageView addSubview:deleteBtn];

    } else  {
        [deleteBtn removeFromSuperview];
        addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addBtn setFrame:CGRectMake(250, 10, 50, 50)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"star.jpg"] forState:UIControlStateNormal];
        [addBtn setTag:indexPath.section];
        addBtn.exclusiveTouch = YES;
        [addBtn addTarget:self action:@selector(addMyfavorite:) forControlEvents:UIControlEventTouchDownRepeat];
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

#pragma mark -  cloud  integration
-(void) requestToServer {
    
    [self.activityIndicator startAnimating];
    NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken]};
    NSURLSessionTask  *task = [[WHHTTPClient sharedClient] getVenueList:params
                                                             completion:^(NSArray *results, NSError *error) {
        if (!error) {
            self.allVenues = [NSMutableArray arrayWithArray:results];
            if (!favoriteMode) {
                self.venuesForDisplay = [NSMutableArray arrayWithArray:results];  //in case of favoride mode, skip..
            }
            self.tableView.delegate =self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
            [self writeToLocalFromServer];
            [self.activityIndicator stopAnimating];
        }
    }];
    
 //   [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
  //  [self.activityIndicator stopAnimating];

    //[self.refreshControl setRefreshingWithStateOfTask:task];
      [self.refreshControl endRefreshing];
}

//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:UITableViewRowAnimationTop];

//-(void) populateVenueList:(id) sender {
//
//    [self.tableView reloadData];
//    [self.activityIndicator stopAnimating];
//    
//}



//always overwrite..myVenuelist initialization..
-(void) writeToLocalFromServer   {
//
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(queue, ^{
//    
    if(self.myVenueList == nil)  {
        self.myVenueList  = [NSMutableArray array];
    }
    else  {
        [self.myVenueList removeAllObjects];
    }
    
    NSLog(@" all venue  %@", self.allVenues);
        for(id obj in self.allVenues) {
            if ([obj[@"is_favourite"] boolValue]) {
                [self.myVenueList addObject:obj];
                NSLog(@" from server %@", self.myVenueList);
            }
        }
        [[Util sharedInstance] writeToFile:@"myVenueList.dat" fileData:self.myVenueList];
 //   });
}

-(NSMutableArray *)readFromLocal {
    return   [[Util sharedInstance] retrieveFromFile:@"myVenueList.dat"];
}


//always read from file
-(void) showMyFavorite:(id) sender {
    
    if ([self readFromLocal] == nil) {
        WHAlert(@"alert", @"no data", nil);
    }
    else  {
        [self.activityIndicator startAnimating];
        
        favoriteMode = !favoriteMode;
        if (favoriteMode) {
            NSLog(@" favorite mode");
            [self.venuesForDisplay removeAllObjects];
            [self.myVenueList removeAllObjects];
            NSMutableArray *venueListFromLocal = [self readFromLocal];
            NSLog(@" switch...showMyFav from file ==> %@", venueListFromLocal);
            [self.venuesForDisplay addObjectsFromArray:venueListFromLocal];
            [self.myVenueList addObjectsFromArray:venueListFromLocal];
        }
        else  {
            [self.venuesForDisplay removeAllObjects];
            [self.venuesForDisplay addObjectsFromArray:self.allVenues];
        }
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
        
    }
}


////myvenueList, file  should same..
-(void) addMyfavorite:(UIButton*)sender  {

    sender.enabled = NO;
    if ([self contains:self.allVenues[sender.tag]]) {
        WHAlert(@"Alert", @"dup",nil);
    } else {
              [self.activityIndicator startAnimating];
              NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken], @"venue_id":self.allVenues[sender.tag][@"id"]};
              NSURLSessionTask  *task = [[WHHTTPClient sharedClient] addFavoriteVenue:params completion:^(NSDictionary *results, NSError *error) {

        if (!error) {
            NSMutableDictionary *newVenue = [self.allVenues[sender.tag] mutableCopy];
            [newVenue  setObject:@YES forKey:@"is_favourite"];
            
            NSMutableArray *venueListFromLocal = [self readFromLocal];
            NSLog(@" from file  %@", venueListFromLocal);
            
            if ([venueListFromLocal count] > 0) {
                 [venueListFromLocal addObject:newVenue];
                [[Util sharedInstance] writeToFile:@"myVenueList.dat" fileData:venueListFromLocal];
                NSLog(@"  after adding data from fhte file %@", [self readFromLocal]);
            }else {
                NSLog(@" count is zero  %@", newVenue);
                [[Util sharedInstance] writeToFile:@"myVenueList.dat" fileData:[NSMutableArray arrayWithObject:newVenue]];
                                NSLog(@"  after adding data from fhte file(only one) %@", [self readFromLocal]);
            }
        }
    }];
//TODO: message..
//TODO: handle..this
        [self.activityIndicator stopAnimating];
  //      [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    }
}


-(void)removeMyfavorite:(UIButton*)sender  {
   
    NSDictionary *params = @{@"key":[[CommonDataManager sharedInstance] accessToken], @"venue_id":self.myVenueList[sender.tag][@"id"]};
     NSLog(@"  removing2");
    NSURLSessionTask  *task = [[WHHTTPClient sharedClient] removeFavoriteVenue:params completion:^(NSDictionary *results, NSError *error) {

        if (!error) {
            
            NSLog(@"  before  removing %@", self.myVenueList);
            [self.myVenueList removeObjectAtIndex:sender.tag];
            NSLog(@" sender tag  %ld", sender.tag);
            NSLog(@"  after removing %@", self.myVenueList);
             [[Util sharedInstance] writeToFile:@"myVenueList.dat" fileData:self.myVenueList];
            [self.venuesForDisplay removeAllObjects];
            [self.venuesForDisplay addObjectsFromArray:[self readFromLocal]];  // prevent accessing file,,
            [self.tableView reloadData];
        }
        else  {
            //message.. later..
        }
        
//        [self.activityIndicator stopAnimating];
    }];
    [self.activityIndicator stopAnimating];
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];



    

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


-(BOOL) contains:(NSDictionary *) venue {
    
    NSLog(@"  %s", __func__);
    
    __block BOOL result = NO;
    NSMutableArray *currentMyVenues = [[Util sharedInstance] retrieveFromFile:@"myVenueList.dat"];
    if (currentMyVenues != nil ) {
        [currentMyVenues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj[@"id"] isEqualToNumber:venue[@"id"]]) {
                result = YES;
            }
        }];
    }
    return result;
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self updateTableData];
}

-(NSString*) updateDistances {
    
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:self.latitude
                                                               longitude:self.longitude];
    
        CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:_locationManager.location.coordinate.latitude
                                                            longitude:_locationManager.location.coordinate.longitude];
        CLLocationDistance distance = [venueLocation distanceFromLocation:myLocation];
        return [NSString stringWithFormat:@"%.0fkm", distance / 1000];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    VenueDetailedViewController  *venueDetailedVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    venueDetailedVC.venueInfo = self.venuesForDisplay[indexPath.section];
    venueDetailedVC.meter = cell.distance.text;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
