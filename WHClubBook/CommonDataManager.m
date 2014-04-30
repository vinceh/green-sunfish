//
//  CommonDataManager.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 26..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "CommonDataManager.h"

@interface CommonDataManager()
    
@property(nonatomic,strong) UIImage  *myImage;
@property(nonatomic,strong) NSDictionary  *signUp;
@property(nonatomic,strong) NSString  *token;
@end

@implementation CommonDataManager

static CommonDataManager *_sharedInstance = nil;

+(instancetype)sharedInstance {

    static dispatch_once_t once_token;
    static id sharedInstance;
    dispatch_once(&once_token, ^{
        sharedInstance = [[CommonDataManager   alloc] init];
    });
    
    return sharedInstance;
}

-(void)setSignUpParameters: (NSArray *) values{
    
     self.signUp =  @{@"user[email]":values[0],
                                @"user[gender]":values[1],
                                @"user[birthday]":values[2],
                                @"user[first_name]":values[3],
                                @"user[last_initial]":values[4]};
    
    
    NSLog(@" sign  %@", self.signUp);

}

-(NSDictionary*) signupParameters {
    
        NSLog(@" befire return sign  %@", self.signUp);
    return self.signUp;
}

-(void)setMyProfileImage:(UIImage*) photo  {
    self.myImage = photo;
    
}

-(UIImage*) myProfileImage {
    return self.myImage;
}

-(void) setAccessToken:(NSString *) token  {

    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"myToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@" write  key==>  %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"]);
}

-(NSString*) accessToken  {
    
    NSLog(@" read  key==>  %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];

}


@end
