//
//  StudentViewController.h
//  MapKit
//
//  Created by Игорь Талов on 20.06.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class Student;
#import "Student.h"

@interface StudentViewController : UIViewController
@property(strong, nonatomic) Student* student;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;

- (IBAction)closeController:(UIBarButtonItem *)sender;
@end
