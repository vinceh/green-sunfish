//
//  WHHTTPClient.m
//  Copyright (c) 2014년 whispr. All rights reserved.


#import "WHHTTPClient.h"

static NSString * const _baseURLString = @"http://purpleoctopus-staging.herokuapp.com/";

@implementation WHHTTPClient



+ (instancetype)sharedClient {
    
    static WHHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WHHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:_baseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)getVenueList:(NSDictionary *)params completion:( void (^)(NSArray *results, NSError *error) )completion;
{
    NSURLSessionDataTask *task = [self GET:@"api/venues/list"
                                parameters: params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {

                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                       if (httpResponse.statusCode == 200) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(responseObject[@"list"], nil);
                                           });
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, nil);
                                           });
                                           NSLog(@"Received: %@", responseObject);
                                           NSLog(@"Received HTTP %ld", httpResponse.statusCode);
                                       }
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(nil, error);
                                       });
                                   }];
    return task;
    
}

//POST:@"api/users/signup"
//user[email]
//user[gender]
//user[birthday]
//user[first_name]
//user[last_initial]
//user[avatar]

- (NSURLSessionDataTask *)signUp:(NSDictionary *)params completion:( void (^)(NSString *result, NSError *error) )completion {
    
    UIImage  *newImage = [[CommonDataManager sharedInstance] myImage];
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    NSURLSessionDataTask *signUpTask = [self POST:@"api/users/signup" parameters:params
                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                            
            [formData appendPartWithFileData:imageData
                                        name:@"user[avatar]"
                                    fileName:@"image1.jpg"
                                    mimeType:@"image/jpeg"];
        } success:^(NSURLSessionDataTask *task, id responseObject) {

        NSHTTPURLResponse  *httpResponse = (NSHTTPURLResponse*) task.response;
        if(httpResponse.statusCode == 200)  {
            
            if ([responseObject[@"success"] intValue]) {
                NSLog(@" response obj %@",  responseObject);
                NSLog(@" response.data  %@", responseObject[@"data"]);
                NSLog(@" response.data  %@", responseObject[@"data"][@"key"]);
                NSLog(@" response.success  %@", responseObject[@"success"]);
                
                completion(responseObject[@"data"][@"key"], nil);
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"notice"
                                                                 message:@"success"
                                                                delegate:self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            }else  {
                NSLog(@" response.msg  %@", responseObject[@"message"]);
                NSLog(@" response.dup  %@", responseObject[@"success"]);
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"notice"
                                                                 message:@"dup"
                                                                delegate:self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil,error);
        
        NSLog(@"  http return code  %@", task.response);
    }];
    return signUpTask;
}




//POST:@"api/users/update?key="""
//user[email]
//user[gender]
//user[birthday]
//user[first_name]
//user[last_initial]
//user[avatar]

- (NSURLSessionDataTask *)update:(NSString *)queryString completion:( void (^)(NSString *result, NSError *error) )completion {
    NSDictionary *dictParameter = @{@"user[email]": @"11.gmail.com", @"user[gender]":@"M",@"user[birthday]":@"2011-11-12", @"user[first_name]":@"updateqqqq",@"user[last_initial]":@"qq"};
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"image1" ofType:@"jpg" ];
    UIImage *image22 = [[UIImage alloc] initWithContentsOfFile:filePath];
    NSData *imageData = UIImageJPEGRepresentation(image22, 0.5);
    
    NSURLSessionDataTask *uploadTask = [self POST:@"api/users/update?key=YYVa_aeqxLYDseZ-_2Mivg" parameters:dictParameter
                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                            
                            [formData appendPartWithFileData:imageData name:@"user[avatar]" fileName:@"image1.jpg" mimeType:@"image/jpeg"];
                            
                        } success:^(NSURLSessionDataTask *task, id responseObject) {
                            
                            NSHTTPURLResponse  *httpResponse = (NSHTTPURLResponse*) task.response;
                            
                            if(httpResponse.statusCode == 200)  {
                                
                                if ([responseObject[@"success"] intValue]) {
                                    NSLog(@" update obj %@",  responseObject);
                                    NSLog(@" update  %@", responseObject[@"data"]);
                                    NSLog(@" update.data  %@", responseObject[@"data"][@"key"]);
                                    NSLog(@" update.success  %@", responseObject[@"success"]);
                                    
                                    completion(responseObject[@"data"][@"key"], nil);
                                    
                                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"notice"
                                                                                     message:@"success"
                                                                                    delegate:self
                                                                           cancelButtonTitle:@"Ok"
                                                                           otherButtonTitles:nil];
                                    // [alert show];
                                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                    
                                    //            dispatch_async(dispatch_get_main_queue(), ^{
                                    //                completion(responseObject[@"list"], nil);
                                    //            });
                                }else  {
                                    
                                    
                                    NSLog(@" update.msg  %@", responseObject[@"message"]);
                                    NSLog(@" response.dup  %@", responseObject[@"success"]);
                                    
                                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"notice"
                                                                                     message:@"dup"
                                                                                    delegate:self
                                                                           cancelButtonTitle:@"Ok"
                                                                           otherButtonTitles:nil];
                                    // [alert show];
                                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                    
                                    
                                    
                                }
                                
                            }
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            completion(nil,error);
                            
                            NSLog(@"  http return code  %@", task.response);
                        }];
    return uploadTask;
}





@end

