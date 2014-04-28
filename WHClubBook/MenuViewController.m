//
//  MenuViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 23..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController
@synthesize cellIdentifier;

#pragma mark - UITableView Delegate & Datasrouce -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (section == 0) ? 2 : 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
	return (section == 0) ? @"Menu" : @"Setting";
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
	
	if (indexPath.section == 0)
	{
		switch (indexPath.row)
		{
			case 0:
				cell.textLabel.text = @"Venue";
				break;
            case 1:
				cell.textLabel.text = @"Chat";
				break;
        }
	}
    else  {
		switch (indexPath.row)
		{
			case 0:
				cell.textLabel.text = @"Profile";
				break;
            case 1:
				cell.textLabel.text = @"About";
				break;

        }
        
    }
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *vc ;

    if (indexPath.section == 0)
	{
		switch (indexPath.row)
		{
			case 0:
				vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"VenueViewController"];
				break;
			case 1:
				vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ChatViewController"];
				break;

        }
	}
    else  {
        switch (indexPath.row)
		{
            case 0:
				vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"SettingViewController"];
				break;
            case 1:
				vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AboutViewController"];
				break;

        }
    }
    [[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.0f;
}


@end
