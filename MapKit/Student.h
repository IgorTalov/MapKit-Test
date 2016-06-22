//
//  Student.h
//  MapKit
//
//  Created by Игорь Талов on 19.06.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

typedef enum {
    StudentGenderMale,
    StudentGenderFemale
}StudentGender;

@interface Student : NSObject <MKAnnotation>

@property(strong, nonatomic) NSString* firstName;
@property(strong, nonatomic) NSString* lastName;
@property(assign, nonatomic) NSInteger age;
@property(assign, nonatomic) StudentGender gender;

//Country, city, street...
@property(strong, nonatomic) NSString* country;
@property(strong, nonatomic) NSString* city;
@property(strong, nonatomic) NSString* street;
@property(strong, nonatomic) NSString* subThoroughfare;
//Location
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;

+(Student* )randomStudent;
@end
