//
//  EditProfileViewController.h
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 16..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSDictionary *editableField;

@end
