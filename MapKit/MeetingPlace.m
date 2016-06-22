//
//  MeetingPlace.m
//  MapKit
//
//  Created by Игорь Талов on 20.06.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import "MeetingPlace.h"

@implementation MeetingPlace

+(MeetingPlace* )randomMeetPlace{
   static MeetingPlace* meetPlace = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        meetPlace = [[MeetingPlace alloc]init];
    });
    
    return meetPlace;
}

@end
