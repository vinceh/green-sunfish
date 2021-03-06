//
//  EditViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 25..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


static NSString *cellIdentifier = @"com.whispr.editTableCell ";

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.editableField enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        self.title = [key uppercaseString];
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UITableViewCell    *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
    
    
    return cell;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
