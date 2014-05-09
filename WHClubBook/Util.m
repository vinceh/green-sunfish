//
//  Util.m
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 8..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "Util.h"

@implementation Util


static Util *_sharedInstance = nil;

+(instancetype)sharedInstance {
    
    static dispatch_once_t once_token;
    static id sharedInstance;
    dispatch_once(&once_token, ^{
        sharedInstance = [[Util   alloc] init];
    });
    return sharedInstance;
}


-(NSString *)dataFilePath:(NSString*)name  {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:name];

}





@end
