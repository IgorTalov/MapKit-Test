//
//  StudentViewController.m
//  MapKit
//
//  Created by Игорь Талов on 20.06.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import "StudentViewController.h"

@interface StudentViewController ()

@end

@implementation StudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.student.gender == StudentGenderMale) {
        self.imageView.image = [UIImage imageNamed:@"boy.png"];
        self.genderLabel.text = @"Male";
    } else {
        self.imageView.image = [UIImage imageNamed:@"girl.png"];
        self.genderLabel.text = @"Female";
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%ld year old", (long)self.student.age];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.student.firstName, self.student.lastName];
    self.countryLabel.text = [NSString stringWithFormat:@"%@", self.student.country];
    self.cityLabel.text = [NSString stringWithFormat:@"%@", self.student.city];
    self.streetLabel.text = [NSString stringWithFormat:@"%@, %@", self.student.street, self.student.subThoroughfare];
    
}


- (IBAction)closeController:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
