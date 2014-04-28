//
//  CommonDataManager.h
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 26..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonDataManager : NSObject


+(instancetype)sharedInstance;
-(void)setSignUpParameters: (NSArray *) values;
-(NSDictionary*) signupParameters;
-(void) setAccessToken:(NSString *) token;
-(void)setMyProfileImage:(UIImage*) myImage;
-(UIImage*) myImage;

@end
