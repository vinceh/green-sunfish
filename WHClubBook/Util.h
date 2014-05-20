//
//  Util.h
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 8..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject


+(instancetype)sharedInstance;
-(NSString *)filePath:(NSString*)name;
-(NSMutableArray*)retrieveFromFile:(NSString*)fileName;
-(void)writeToFile:(NSString*)fileName fileData:(NSArray*)data;


@end
