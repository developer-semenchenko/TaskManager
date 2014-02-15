//
//  AddTaskViewController.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/10/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "AddTaskViewController.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

#pragma mark - Singleton Location MAnager
+ (AddTaskViewController *)sharedLocationController
{
    static AddTaskViewController *sharedLocationControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedLocationControllerInstance = [[self alloc] init];
    });
    return sharedLocationControllerInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

#pragma  mark - Defaul View life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Positioning user location to center of mapView
    userRegionPosition = MKCoordinateRegionMakeWithDistance([self.mapView userLocation].coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:userRegionPosition] animated:YES];
    
    // Set up delegates
    self.textField.delegate = self;
    self.mapView.delegate = self;
    
    [self addGestureRecogniserToMapView];
    
    // Add Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager stopMonitoringSignificantLocationChanges];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    // Positioning user location to center of mapView
    userRegionPosition = MKCoordinateRegionMakeWithDistance([self.mapView userLocation].coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:userRegionPosition] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"createTask"])
    {
        NSDictionary *newTask = [[NSDictionary alloc] initWithObjectsAndKeys:[self.textField text], @"Task text", nil];
        [TasksIO addTasksToFile:newTask];
        
        // Add Location Manager
        if (self.enableLocationMonitoring.isOn){
            taskRegion = [[CLCircularRegion alloc] initWithCenter:taskPlace.coordinate radius:1 identifier:[self.textField text]];
            
            [self.locationManager startMonitoringForRegion:taskRegion];
        }
    }
}

#pragma mark - MapView methods
- (void)addGestureRecogniserToMapView{
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(addPinToMap:)];
    lpgr.minimumPressDuration = 0.5; //
    [self.mapView addGestureRecognizer:lpgr];
    
}

- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    // Add annotation
    NSArray *existingAnnotations = self.mapView.annotations;
    [self.mapView removeAnnotations:existingAnnotations];
    
    taskPlace = [[MKPointAnnotation alloc]init];
    taskPlace.coordinate = touchMapCoordinate;
    taskPlace.title = [self.textField text];
    longitude = taskPlace.coordinate.longitude;
    latitude = taskPlace.coordinate.latitude;
    
    [self.mapView addAnnotation:taskPlace];
}

#pragma mark - TextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textField) {
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside)
    {

    }
    else if(state == CLRegionStateOutside)
    {
        
    }
    else{
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{

    UILocalNotification* localNotificationInside = [[UILocalNotification alloc] init];
    localNotificationInside.fireDate = [NSDate date];
    localNotificationInside.alertBody = self.textField.text;
    localNotificationInside.alertAction = @"Complete tasks and open App..";
    localNotificationInside.soundName = UILocalNotificationDefaultSoundName;
    localNotificationInside.timeZone = [NSTimeZone defaultTimeZone];
    localNotificationInside.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotificationInside];
    
}


#pragma mark - Helpers
-(void) showMessage:(NSString *) message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"V.S. Debug"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:Nil, nil];
    
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    
    [alertView show];
}

- (IBAction)clearMonitoredLocations:(id)sender {
    for (CLRegion *monitored in [self.locationManager monitoredRegions])
        [self.locationManager stopMonitoringForRegion:monitored];
}

@end
