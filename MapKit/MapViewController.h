//
//  MapViewController.h
//  MapKit
//
//  Created by Игорь Талов on 19.06.16.
//  Copyright © 2016 Игорь Талов. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKMapView;



@interface MapViewController : UIViewController
//Property
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *ZoomButton;
@property (weak, nonatomic) IBOutlet UIButton *radarButton;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (weak, nonatomic) IBOutlet UILabel *smallDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *midDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigDistanceLabel;

//Actions
- (IBAction)createRoute:(UIButton *)sender;
- (IBAction)radarAction:(UIButton *)sender;
- (IBAction)addStudent:(UIBarButtonItem *)sender;
-(IBAction)actionZoom:(UIButton* )sender;
@end
