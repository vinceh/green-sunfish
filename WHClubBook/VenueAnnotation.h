//
//  VenueAnnotation.h
//  WHClubBook
//
//  Created by yong choi on 2014. 5. 7..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VenueAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *title;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;

@end
