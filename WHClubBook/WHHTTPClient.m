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
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        [config setURLCache:cache];

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
                                               NSLog(@"  respomse....  %@", responseObject);
                                               completion(responseObject[@"list"], nil);
                                       } else {
                                           completion(nil, nil);
                                           NSLog(@"Received: %@", responseObject);
                                           NSLog(@"Received HTTP %ld", httpResponse.statusCode);
                                       }
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           completion(nil, error);
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
    
    
    NSDate  *startDate  = [NSDate date];
    double start = [startDate timeIntervalSince1970];
    
    UIImage  *newImage = [[CommonDataManager sharedInstance] myImage];
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    
    NSURLSessionDataTask *signUpTask = [self POST:@"api/users/signup" parameters:params
                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                            
            [formData appendPartWithFileData:imageData
                                        name:@"user[avatar]"
                                    fileName:@"image1.jpg"
                                    mimeType:@"image/jpeg"];
        } success:^(NSURLSessionDataTask *task, id responseObject) {

        [[CommonDataManager sharedInstance]  setAccessToken:responseObject[@"data"][@"key"]];
        NSHTTPURLResponse  *httpResponse = (NSHTTPURLResponse*) task.response;
        if(httpResponse.statusCode == 200)  {
            
            if ([responseObject[@"success"] intValue]) {
                NSLog(@" response obj %@",  responseObject);
                NSLog(@" response.data  %@", responseObject[@"data"]);
                NSLog(@" response.data  %@", responseObject[@"data"][@"key"]);
                NSLog(@" response.success  %@", responseObject[@"success"]);
                
                completion(responseObject[@"data"][@"key"], nil);

                NSDate  *endDate  = [NSDate date];
                double end = [endDate timeIntervalSince1970];
                NSLog(@" total elaspe  time  %.f", end -start);
                
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"notice"
//                                                                 message:@"success"
//                                                                delegate:self
//                                                       cancelButtonTitle:@"Ok"
//                                                       otherButtonTitles:nil];
//                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didRegisterSuccess" object:self];
                
            }else  {
                NSLog(@" response.msg  %@", responseObject[@"message"]);
                NSLog(@" response.dup  %@", responseObject[@"success"]);
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"notice"
                                                                 message:@"dup"
                                                                delegate:self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didRegisterDup" object:self];
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

- (NSURLSessionDataTask *)profileUpdate:(NSDictionary *)params completion:( void (^)(NSString *result, NSError *error) )completion {
//    NSDictionary *dictParameter = @{@"user[email]": @"11.gmail.com", @"user[gender]":@"M",@"user[birthday]":@"2011-11-12", @"user[first_name]":@"updateqqqq",@"user[last_initial]":@"qq"};
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"image1" ofType:@"jpg" ];
    UIImage *image22 = [[UIImage alloc] initWithContentsOfFile:filePath];
    NSData *imageData = UIImageJPEGRepresentation(image22, 0.5);
    
    NSURLSessionDataTask *uploadTask = [self POST:@"api/users/update" parameters:params
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
                                    
//                                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"notice"
//                                                                                     message:@"success"
//                                                                                    delegate:self
//                                                                           cancelButtonTitle:@"Ok"
//                                                                           otherButtonTitles:nil];
//                                    // [alert show];
//                                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                                    
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

- (NSURLSessionDataTask *)enterVenue:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion  {

    NSURLSessionDataTask *task = [self POST:@"api/room/enter"
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        NSHTTPURLResponse  *httpResponse = (NSHTTPURLResponse*) task.response;
                                        NSLog(@" response..enter venue => %@", httpResponse);
                                        completion(responseObject, nil);
                                    }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        completion(nil, error);
                                        NSLog(@" response..enter Venue.error  %@", task.response);
                                        
                                    }];
    return task;
    
    
}

- (NSURLSessionDataTask *)leaveVenue:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion  {
    
    NSURLSessionDataTask *task = [self POST:@"api/room/leave"
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        NSHTTPURLResponse  *httpResponse = (NSHTTPURLResponse*) task.response;
                                        NSLog(@" response..leavevenue => %@", httpResponse);
                                        completion(responseObject, nil);
                                    }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        completion(nil, error);
                                        NSLog(@" response..leaveVenue.error  %@", task.response);
                                        
                                    }];
    return task;
}


- (NSURLSessionDataTask *)profile:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion  {

    NSURLSessionDataTask *task = [self GET:@"api/profile"
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        NSHTTPURLResponse  *httpResponse = (NSHTTPURLResponse*) task.response;
                                        NSLog(@" response..profile=> %@", responseObject);
                                        completion(responseObject, nil);
                                        completion(responseObject, nil);
                                        
                                    }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        completion(nil, error);
                                        NSLog(@" response..profile.error  %@", task.response);
                                        
                                    }];
    return task;
}

- (NSURLSessionDataTask *)lottery:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion  {

    NSLog(@"  %s", __func__);
    NSURLSessionDataTask *task = [self GET:@"api/lottery/show"
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSHTTPURLResponse  *httpResponse = (NSHTTPURLResponse*) task.response;
                                       NSLog(@" response..lottery=> %@", responseObject);
                                       completion(responseObject, nil);
                                       completion(responseObject, nil);
                                       
                                   }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       completion(nil, error);
                                       NSLog(@" response..lottery  %@", task.response);
                                       
                                   }];
    return task;

    
}

- (NSURLSessionDataTask *)apnUpdate:(NSDictionary*)params completion:( void (^)(NSDictionary *result, NSError *error) )completion {
    
    NSLog(@"  %s", __func__);
    NSURLSessionDataTask *task = [self POST:@"api/users/update-apn"
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSHTTPURLResponse  *httpResponse = (NSHTTPURLResponse*) task.response;
                                       NSLog(@" response..apns=> %@", responseObject);
                                       completion(responseObject, nil);
                                       completion(responseObject, nil);
                                       
                                   }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       completion(nil, error);
                                       NSLog(@" response..spns  %@", task.response);
                                       
                                   }];
    return task;
    
    
    
    
}

@end

