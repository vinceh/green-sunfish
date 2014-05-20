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
#import "WHResponseSerializer.h"
//#import "AFURLResponseSerialization.h"



@interface WHHTTPClient : AFHTTPSessionManager

@property(nonatomic,strong) NSString *url;

+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)getVenueList:(NSDictionary *)params completion:( void (^)(NSArray *results, NSError *error) )completion;
- (NSURLSessionDataTask *)signUp:(NSDictionary*)params  completion:( void (^)(NSString   *result, NSError *error) )completion;
- (NSURLSessionDataTask *)profileUpdate:(NSDictionary*)params completion:( void (^)(NSString *result, NSError *error) )completion;
- (NSURLSessionDataTask *)leaveVenue:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion;
- (NSURLSessionDataTask *)enterVenue:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion;
- (NSURLSessionDataTask *)profile:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion;
- (NSURLSessionDataTask *)lottery:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion;
- (NSURLSessionDataTask *)apnUpdate:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion;
- (NSURLSessionDataTask *)addFavoriteVenue:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion;
- (NSURLSessionDataTask *)removeFavoriteVenue:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion;


@end

