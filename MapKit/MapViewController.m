//
//  MapViewController.m
//  MapKit
//
//  Created by Игорь Талов on 19.06.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Student.h"
#import "MapAnnotation.h"
#import "UIView+MKAnnotationView.h"
#import "StudentViewController.h"
#import "MeetingPlace.h"

@interface MapViewController () <MKMapViewDelegate>
@property(strong, nonatomic) NSMutableArray* studentsArray;
@property(strong, nonatomic) NSMutableArray* annotationArray;
@property(strong, nonatomic) CLGeocoder* geocoder;
@property(strong, nonatomic) MKDirections* directions;
@property(assign, nonatomic) CLLocationCoordinate2D meetCoordinate;

@property(assign, nonatomic) BOOL isOverlays;

@property(assign, nonatomic) NSInteger smallRadius;
@property(assign, nonatomic) NSInteger middleRadius;
@property(assign, nonatomic) NSInteger bigRadius;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isOverlays = NO;
    
    self.geocoder = [[CLGeocoder alloc]init];
    
    self.ZoomButton.layer.cornerRadius = 18;
    self.radarButton.layer.cornerRadius = 18;
    self.routeButton.layer.cornerRadius = 18;
    self.infoView.layer.cornerRadius = 10;
    
    self.smallDistanceLabel.text = @"";
    self.midDistanceLabel.text = @"";
    self.bigDistanceLabel.text = @"";
    
    self.smallRadius = 100;
    self.middleRadius = 500;
    self.bigRadius = 1000;
    
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(addMeetPlace:)];
    longPress.numberOfTapsRequired = 0;
    [self.mapView addGestureRecognizer:longPress];
    
    CLLocationCoordinate2D spbCoordinate=CLLocationCoordinate2DMake(59.9, 30.3);
    MKCoordinateRegion initialRegion=MKCoordinateRegionMakeWithDistance(spbCoordinate, 8000, 8000);
    self.mapView.region=initialRegion;
    
    self.annotationArray = [NSMutableArray array];
    self.studentsArray = [NSMutableArray array];
    [self createStudents];
}

-(void)dealloc{
    if ([self.geocoder isGeocoding]) {
        [self.geocoder cancelGeocode];
    }
    if ([self.directions isCalculating]) {
        [self.directions cancel];
    }
    
}

-(void)addMeetPlace:(UILongPressGestureRecognizer* )sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        MeetingPlace* place = [MeetingPlace randomMeetPlace];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
        place.coordinate = coordinate;
        self.meetCoordinate = coordinate;

        [self.mapView addAnnotation:place];
        [self calculatingStudentOnMeetPlace:coordinate];
    }
    
}

-(void)createStudents{
    
    for (int i = 0; i < 5; i++) {
        Student* student = [Student randomStudent];
        NSLog(@"Student %@ %@ create", student.firstName, student.lastName );
        [self.studentsArray addObject:student];
    }
}

-(void) addAnnotation{

    for(Student* student in self.studentsArray){
        Student* annotation = student;
        annotation.title = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        annotation.coordinate = student.coordinate;
        annotation.subtitle = [NSString stringWithFormat:@"%d year old", student.age];
        [self.mapView addAnnotation:annotation];
    }
}

-(void)calculatingStudentOnMeetPlace:(CLLocationCoordinate2D)place{
    NSInteger numberOfStudentsInSmallArea = 0;
    NSInteger numberOfStudentsInMiddleArea = 0;
    NSInteger numberOfStudentsInBigArea = 0;
    MKMapPoint point = MKMapPointForCoordinate(place);
    
    for(Student* obj in self.studentsArray){
        MKMapPoint studentPoint = MKMapPointForCoordinate(obj.coordinate);
        
        CLLocationDistance distance = MKMetersBetweenMapPoints(point, studentPoint);
        if (distance<self.smallRadius) {
            numberOfStudentsInSmallArea++;
        } else if (distance>=self.smallRadius && distance<self.middleRadius){
            numberOfStudentsInMiddleArea++;
        } else if (distance>=self.middleRadius && distance < self.bigRadius){
            numberOfStudentsInBigArea++;
        }
    }
    
    self.smallDistanceLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfStudentsInSmallArea];
    self.midDistanceLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfStudentsInMiddleArea];
    self.bigDistanceLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfStudentsInBigArea];
    
}

- (void) showAlertWithMessage:(NSString* )message {
    [[[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
}

- (void) presentViewControllerForStudent:(Student* )student {
    //present View controller
    StudentViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentViewController"];
    vc.student = student;
    
    UINavigationController* nc = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nc animated:YES completion:nil];
}
#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if ([annotation isKindOfClass:[Student class]]){
        Student <MKAnnotation>* student = annotation;
        static NSString* identifier = @"StudentAnnotation";
        
        MKAnnotationView* pin = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pin) {
            pin = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
            pin.canShowCallout = YES;
            pin.draggable = NO;
            UIButton* detailButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
            [detailButton addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
            pin.rightCalloutAccessoryView = detailButton;
            if (student.gender == StudentGenderMale) {
                pin.image = [UIImage imageNamed:@"boy.png"];
            } else {
                pin.image = [UIImage imageNamed:@"girl.png"];
            }
        } else {
            pin.annotation = annotation;
        }
        
        return pin;
    } else if ([annotation isKindOfClass:[MeetingPlace class]]) {
        static NSString* meetIdentifier = @"Meet";
        MKAnnotationView* meet = (MKAnnotationView* )[mapView dequeueReusableAnnotationViewWithIdentifier:meetIdentifier];
        
        if (!meet) {
            meet = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:meetIdentifier];
            meet.canShowCallout = YES;
            meet.draggable = NO;
            meet.image = [UIImage imageNamed:@"college.png"];
        } else {
            meet.annotation = annotation;
        }
        
        return meet;
        
    } else {
       return nil;
    }
    
    
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer* render = [[MKCircleRenderer alloc]initWithOverlay:overlay];
        render.strokeColor = [UIColor greenColor];
        render.fillColor = [UIColor colorWithRed:126/255 green:217/255 blue:96/255 alpha:0.5];
        render.lineWidth = 1.f;
        return render;
    } else if ([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineRenderer* render = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
        
        render.strokeColor = [self randomColor];
        render.fillColor = [self randomColor];
        render.lineWidth = 3.f;
        
        return render;
    }
    return nil;

}


#pragma mark - Actions

-(void)showDetail:(UIButton* )sender {
    
    Student* student = (Student <MKAnnotation>*)[[sender superAnnotationView]annotation];
    
    //Search address
    
    CLLocationCoordinate2D coordinate = student.coordinate;
    
    CLLocation* location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];

    if ([self.geocoder isGeocoding]) {
        [self.geocoder cancelGeocode];
    }
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSString* message = nil;
        
        if (error) {
            
            message = [error localizedDescription];
            [self showAlertWithMessage:message];
        } else {
            
            if ([placemarks count] > 0) {
                
                CLPlacemark* placemark = [placemarks firstObject];
                
                student.country = [placemark.country description];
                student.city = [placemark.locality description];
                student.street = [placemark.thoroughfare description];
                
                if (placemark.subThoroughfare) {
                    student.subThoroughfare = [placemark.subThoroughfare description];
                }

                [self presentViewControllerForStudent:student];
                
            } else {
                message = @"No lacemarks found";
                [self showAlertWithMessage:message];
            }
        }
    }];

}


- (IBAction)createRoute:(UIButton *)sender {
    
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc]init];
    request.transportType = MKDirectionsTransportTypeWalking;
    MKPlacemark* meetPlace = [[MKPlacemark alloc]initWithCoordinate:self.meetCoordinate addressDictionary:nil];
    MKMapItem* meetItem = [[MKMapItem alloc]initWithPlacemark:meetPlace];
    request.destination = meetItem;
    request.requestsAlternateRoutes = NO;
    NSMutableArray* array = [NSMutableArray array];
    NSArray* sourceArray = nil;
    sourceArray = self.studentsArray;
    
    for(Student* obj in sourceArray){
        MKPlacemark* sourcePlace = [[MKPlacemark alloc]initWithCoordinate:obj.coordinate addressDictionary:nil];
        MKMapItem* sourceItem = [[MKMapItem alloc]initWithPlacemark:sourcePlace];
        request.source = sourceItem;
        
        self.directions = [[MKDirections alloc]initWithRequest:request];
        [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            NSString* message = nil;
            
            if (error) {
                message = [error localizedDescription];
                [self showAlertWithMessage:message];
            } else if ([response.routes count]== 0){
                message = @"No Route Found";
                [self showAlertWithMessage:message];
            } else {
                //[self.mapView removeOverlays:[self.mapView overlays]];

                for(MKRoute* route in response.routes){
                    [array addObject:route.polyline];
                }
                
                [self.mapView addOverlays:array level:MKOverlayLevelAboveRoads];
            }
            
        }];
    }
 
}

- (IBAction)radarAction:(UIButton *)sender {
    
    MKCircle* smallCircle = [MKCircle circleWithCenterCoordinate:self.meetCoordinate radius:self.smallRadius];
    MKCircle* middleCircle = [MKCircle circleWithCenterCoordinate:self.meetCoordinate radius:self.middleRadius];
    MKCircle* bigCircle = [MKCircle circleWithCenterCoordinate:self.meetCoordinate radius:self.bigRadius];
    
    NSArray* circles = [NSArray arrayWithObjects:smallCircle,middleCircle,bigCircle, nil];
    
    if (!self.isOverlays) {
        
        self.isOverlays = YES;

        [self.mapView addOverlays:circles level:MKOverlayLevelAboveRoads];
    } else {
        
        self.isOverlays = NO;
        
        [self.mapView removeOverlays:self.mapView.overlays];
    }

}

- (IBAction)addStudent:(UIBarButtonItem *)sender {
    [self addAnnotation];
}

-(IBAction)actionZoom:(UIBarButtonItem* )sender{
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location = annotation.coordinate;
        
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        static double delta = 2000;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        
        zoomRect = MKMapRectUnion(zoomRect, rect);
        
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
    
}

#pragma mark - Help Methods

-(UIColor* )randomColor{
    CGFloat red = (float)(arc4random() % 256) / 255;
    CGFloat blue = (float)(arc4random() % 256) / 255;
    CGFloat green = (float)(arc4random() % 256) / 255;
    
    UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
    return color;
}
@end
