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

-(NSString *)filePath:(NSString*)name  {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:name];

}


-(NSMutableArray*)retrieveFromFile:(NSString*)fileName
{
	NSString *filePath = [self filePath:fileName];
    
	if( [[NSFileManager defaultManager]fileExistsAtPath:filePath] )
	{
		NSMutableArray *array	= [[NSMutableArray alloc] initWithContentsOfFile:filePath];
		return array;
	}
    
	return NULL;
}

-(void)writeToFile:(NSString*)fileName fileData:(NSArray*)data
{
	[data writeToFile:[self filePath:fileName ] atomically:YES];
    
    NSLog(@" my venue saved : %@", data);
    
    [self retrieveFromFile:@"myVenueList.dat"];
}






@end

//
//
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    //2) Create the full file path by appending the desired file name
//    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
//
//    //Load the array
//    NSMutableArray *yourArray = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
//    if(yourArray == nil)
//    {
//        //Array file didn't exist... create a new one
//        yourArray = [[NSMutableArray alloc] initWithCapacity:10];
//        
//        //Fill with default values
//    }
//    ...
//    //Use the content
//    ...
//    //Save the array
//    [yourArray writeToFile:yourArrayFileName atomically:YES];

