//
//  PeopleViewController.h
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 4..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleCell.h"
#import "PeopleDetailViewController.h"
#import "WHHTTPClient.h"


@interface PeopleViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

-(void) reloadView;
@end
