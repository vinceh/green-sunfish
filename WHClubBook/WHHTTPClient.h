//
//  WHHTTPClient.h
//  WHClubCommunity
//
//  Created by yong choi on 2014. 4. 18..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "CommonDataManager.h"

@interface WHHTTPClient : AFHTTPSessionManager

@property(nonatomic,strong) NSString *url;

+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)getVenueList:(NSDictionary *)params completion:( void (^)(NSArray *results, NSError *error) )completion;
- (NSURLSessionDataTask *)signUp:(NSDictionary*)params  completion:( void (^)(NSString   *result, NSError *error) )completion;
- (NSURLSessionDataTask *)update:(NSDictionary*)params completion:( void (^)(NSString *result, NSError *error) )completion;
- (NSURLSessionDataTask *)leaveVenue:(NSDictionary*)params completion:( void (^)(NSString *result, NSError *error) )completion;
- (NSURLSessionDataTask *)enterVenue:(NSDictionary*)params completion:( void (^)(NSString *result, NSError *error) )completion;

@end

