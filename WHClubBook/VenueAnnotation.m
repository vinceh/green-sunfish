//
//  VenueAnnotation.m
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 7..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "VenueAnnotation.h"

@implementation VenueAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
    }
    return self;
}

@end
