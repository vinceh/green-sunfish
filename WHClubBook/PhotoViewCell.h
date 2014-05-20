//
//  PhotoViewCell.h
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 25..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoView1;
@property (weak, nonatomic) IBOutlet UIImageView *photoView2;
@property (weak, nonatomic) IBOutlet UIImageView *photoView3;

- (IBAction)changePhoto:(id)sender;

@end
