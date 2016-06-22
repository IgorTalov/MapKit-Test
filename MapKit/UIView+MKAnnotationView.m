//
//  UIView+MKAnnotationView.m
//  MapKit
//
//  Created by Игорь Талов on 15.06.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import "UIView+MKAnnotationView.h"
#import <MapKit/MKAnnotationView.h>

@implementation UIView (MKAnnotationView)

-(MKAnnotationView* )superAnnotationView{
    
    if ([self.superview isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView* )self.superview;
    }
    
    if (!self.superview) {
        return nil;
    }
    
    return [self.superview superAnnotationView];
    
}


@end
