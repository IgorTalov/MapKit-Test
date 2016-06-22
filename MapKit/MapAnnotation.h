//
//  MapAnnotation.h
//  MapKit
//
//  Created by Игорь Талов on 15.06.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
