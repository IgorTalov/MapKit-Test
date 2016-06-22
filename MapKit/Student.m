//
//  Student.m
//  MapKit
//
//  Created by Игорь Талов on 19.06.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import "Student.h"

@implementation Student

static NSString* maleFirstNames[] = {@"Vova", @"Alex", @"Michail",@"David",@"Vasya"};
static NSString* femaleFirstNames[] = {@"Maria", @"Alexa",@"Anna",@"Tanya"};
static NSString* maleLastNames[] = {@"Petrov", @"Ivanov", @"Bogdanov", @"Alexandrov"};
static NSString* femaleLastNames[] = {@"Korotkova", @"Bogdanova", @"Filatova",@"Petrova"};

+(Student* )randomStudent{
    Student* student = [[Student alloc]init];

    student.gender = arc4random() % 2 ? StudentGenderFemale : StudentGenderMale;
    
    if (student.gender == StudentGenderMale) {
        student.firstName = maleFirstNames[arc4random_uniform(5)];
        student.lastName = maleLastNames[arc4random_uniform(5)];
    } else if (student.gender == StudentGenderFemale){
        student.firstName = femaleFirstNames[arc4random_uniform(4)];
        student.lastName = femaleLastNames[arc4random_uniform(4)];
    }
    
    student.age = (int)(30 - arc4random_uniform(9));

    NSInteger minusOrPlus = (arc4random() % 2 ? 1 : -1);
    
    double longtitude = 30.26417 + ((double)(arc4random() % 10000) / 900000*minusOrPlus);
    double latitude = 59.89444 + ((double)(arc4random() % 180000) / 50000000*minusOrPlus);
    
    student.coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
    
    student.street = @"";
    student.subThoroughfare = @"";
    
    return student;
}

@end
