//
//  AddTaskViewController.h
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/10/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TasksIO.h"

@interface AddTaskViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
    MKCoordinateRegion userRegionPosition;
    MKPointAnnotation *taskPlace;
    CLLocationDegrees longitude;
    CLLocationDegrees latitude;
    CLCircularRegion *taskRegion;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISwitch *enableLocationMonitoring;

- (IBAction)clearMonitoredLocations:(id)sender;

// Shared Location Monitor
+ (AddTaskViewController *)sharedLocationController;

@end
