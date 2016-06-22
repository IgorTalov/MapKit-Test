//
//  MeetingPlace.h
//  MapKit
//
//  Created by Игорь Талов on 20.06.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MeetingPlace : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+(MeetingPlace* )randomMeetPlace;

@end
