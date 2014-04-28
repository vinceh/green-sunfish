//
//  EditViewController.h
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 25..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSDictionary *editableField;

@end
