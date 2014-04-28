//
//  Venue.h
//  WHClubCommunity
//
//  Created by yong choi on 2014. 4. 16..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *lati;
@property (strong, nonatomic) NSString *longi;
@property (strong, nonatomic) NSArray  *images;

-(UIImage*) loadImage:(NSString *) imageName;

@end
