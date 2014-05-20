//
//  PeopleLayout.m
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 14..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "PeopleLayout.h"

@implementation PeopleLayout

-(CGSize) collectionViewContentSize {

    return CGSizeMake(CGRectGetWidth(self.collectionView.frame) *
                      3,
                      CGRectGetHeight(self.collectionView.frame)) ;
}



@end
