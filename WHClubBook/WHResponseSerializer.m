//
//  WHResponseSerializer.m
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 19..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "WHResponseSerializer.h"




@implementation WHResponseSerializer 


- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id JSONObject = [super responseObjectForResponse:response data:data error:error]; // may mutate `error`
    
    if (*error && [JSONObject objectForKey:@"error"]) {
        NSMutableDictionary *mutableUserInfo = [(*error).userInfo mutableCopy];
        
        mutableUserInfo[NSLocalizedFailureReasonErrorKey] = [[JSONObject objectForKey:@"error"] objectForKey:@"message"];
        
        NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:[mutableUserInfo copy]];
        (*error) = newError;
    }
    
    return JSONObject;
}

@end



/*

 if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
 if (*error != nil) {
 NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
 NSError *jsonError;
 // parse to json
 id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
 // store the value in userInfo
 userInfo[JSONResponseSerializerWithDataKey] = (jsonError == nil) ? json : nil;
 NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
 (*error) = newError;
 }
 return (nil);
 }
 return ([super responseObjectForResponse:response data:data error:error]);

*/