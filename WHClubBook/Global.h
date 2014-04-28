//
//  Global.h
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 23..
//  Copyright (c) 2014년 whispr. All rights reserved.
//



#define WHAlert(TITLE,MSG)   [UIAlertView showWithTitle:(TITLE)    \
                                                       message:(MSG)      \
                                             cancelButtonTitle:@"Cancel"  \
                                             otherButtonTitles:@[@"OK"]   \
                                                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {  \
                                            }];

