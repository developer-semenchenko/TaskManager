//
//  ViewController.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/2/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

BOOL isShowingSideView = NO;

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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

#pragma  mark - Defaul View life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // InrtoViewController texts
    self.pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update"];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    CATransform3D transform1 = CATransform3DMakeTranslation(0, 0, 0);
    CATransform3D transform2 = CATransform3DMakeRotation((M_PI / 2) - 0, 0, -1, 0);
    CATransform3D transform = CATransform3DConcat(transform2, transform1);
    [self.sidePanel.layer setTransform:transform];
    
    [self.sidePanel.layer setAnchorPoint:CGPointMake(1.0, 0.5)];

    // set perspective of the transformation
    CATransform3D transform3 = CATransform3DIdentity;
    transform3.m34 = -1/500.0;
    [self.view.layer setSublayerTransform:transform3];
    // Checking first time launch
    if ([userDefaults boolForKey:@"firstLaunch"])
    {
        // App already launched - showing UI
        self.topPanel.alpha = 1;
        self.sideButton.alpha = 1;
        self.twButton.alpha = 1;
        self.fbButton.alpha = 1;
        self.addButton.alpha = 1;
        self.containerView.alpha = 1;
        
    }
    else
    {
        
        // Hiding UI
        self.topPanel.alpha = 0;
        self.sideButton.alpha = 0;
        self.twButton.alpha = 0;
        self.fbButton.alpha = 0;
        self.addButton.alpha = 0;
        self.containerView.alpha = 0;
        
        // Create page view controller
        self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        self.pageViewController.dataSource = self;
        
        PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        // Change the size of page view controller
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        // Show IntroViewcontroller
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.containerViewController = segue.destinationViewController;
    }
}


#pragma mark - PageView methods
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.labelText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - TopPanel methods
- (IBAction)showSidePanel:(id)sender {
    CGRect newMainViewFrame = self.mainView.frame;
    newMainViewFrame.origin.x += 70;
    
    // Sliding mainView to show SidePanel
    if (!isShowingSideView){
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.frame = newMainViewFrame;
        self.sidePanel.alpha = 1.0f;
        self.buttonTasks.alpha = 1.0f;
        self.buttonCompletedTasks.alpha = 1.0f;
        self.buttonOptions.alpha = 1.0f;
        self.buttonAbout.alpha = 1.0f;
        
        CATransform3D transform1 = CATransform3DMakeTranslation(70, 0, 0);
        CATransform3D transform2 = CATransform3DMakeRotation((M_PI / 2) - 1.570796, 0, -1, 0);
        CATransform3D transform = CATransform3DConcat(transform2, transform1);
        [self.sidePanel.layer setTransform:transform];
        
    }];
        isShowingSideView = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lockTableView" object:nil];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.mainView.frame = self.view.frame;
            self.sidePanel.alpha = 0.0f;
            self.buttonTasks.alpha = 0.0f;
            self.buttonCompletedTasks.alpha = 0.0f;
            self.buttonOptions.alpha = 0.0f;
            self.buttonAbout.alpha = 0.0f;
            
            CATransform3D transform1 = CATransform3DMakeTranslation(0, 0, 0);
            CATransform3D transform2 = CATransform3DMakeRotation((M_PI / 2) - 0, 0, -1, 0);
            CATransform3D transform = CATransform3DConcat(transform2, transform1);
            [self.sidePanel.layer setTransform:transform];

            
        }];
        isShowingSideView = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockTableView" object:nil];
    }
}

- (IBAction)addTask:(id)sender {
    
    NSMutableArray *tasksArray = [[TasksIO loadTasksFromFile] mutableCopy];

    NSString *taskText = [[NSString alloc] initWithFormat:@"Task text %d", [tasksArray count]];
    NSDictionary *newTask = [[NSDictionary alloc] initWithObjectsAndKeys: taskText, @"Task text", nil];
    [tasksArray insertObject:newTask atIndex:0];
    [TasksIO saveTaskArray:tasksArray];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil];
}

#pragma mark - SidePanel methods
- (IBAction)openTasks:(id)sender {
    [self.containerViewController swapToTasks];
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = self.view.frame;
        self.sidePanel.alpha = 0.0f;
        self.buttonTasks.alpha = 0.0f;
        self.buttonCompletedTasks.alpha = 0.0f;
        self.buttonOptions.alpha = 0.0f;
        self.buttonAbout.alpha = 0.0f;
    }];
    isShowingSideView = NO;
}

- (IBAction)openCompletedTasks:(id)sender {
    [self.containerViewController swapToCompletedTasks];
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = self.view.frame;
        self.sidePanel.alpha = 0.0f;
        self.buttonTasks.alpha = 0.0f;
        self.buttonCompletedTasks.alpha = 0.0f;
        self.buttonOptions.alpha = 0.0f;
        self.buttonAbout.alpha = 0.0f;
    }];
    isShowingSideView = NO;
}

- (IBAction)openOptions:(id)sender {
    [self.containerViewController swapToOptions];
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = self.view.frame;
        self.sidePanel.alpha = 0.0f;
        self.buttonTasks.alpha = 0.0f;
        self.buttonCompletedTasks.alpha = 0.0f;
        self.buttonOptions.alpha = 0.0f;
        self.buttonAbout.alpha = 0.0f;
    }];
    isShowingSideView = NO;
}

- (IBAction)openAbout:(id)sender {
    [self.containerViewController swapToAbout];
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = self.view.frame;
        self.sidePanel.alpha = 0.0f;
        self.buttonTasks.alpha = 0.0f;
        self.buttonCompletedTasks.alpha = 0.0f;
        self.buttonOptions.alpha = 0.0f;
        self.buttonAbout.alpha = 0.0f;
    }];
    isShowingSideView = NO;
}

#pragma mark - Sharing methods
- (IBAction)sharingToTwitter:(id)sender {
    
    NSArray *tasksArray = [TasksIO loadTasksFromFile];

    int tasksCount = [tasksArray count];
    
    NSString *tweetText = [[NSString alloc] initWithFormat:@"Now I have %d tasks.. I must done all of this withing 24h!", tasksCount];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:tweetText];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)sharingToFacebook:(id)sender {

    NSArray *tasksArray = [TasksIO loadTasksFromFile];

    int tasksCount = [tasksArray count];
    
    NSString *facebookText = [[NSString alloc] initWithFormat:@"Now I have %d tasks.. I must done all of this withing 24h!", tasksCount];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:facebookText];
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send any news right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


#pragma mark - CLLocationManagerDelegate

/*- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside)
    {
        [self showMessage:@"CLRegionStateInside"];
        NSLog(@"##Entered Region - %@", region.identifier);
    }
    else if(state == CLRegionStateOutside)
    {
        [self showMessage:@"CLRegionStateOutside"];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate date];
        localNotification.alertBody = @"CLRegionStateOutside";
        localNotification.alertAction = @"Show me app";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        
        NSLog(@"##Exited Region - %@", region.identifier);
    }
    else{
        [self showMessage:@"else state"];
        NSLog(@"##Unknown state  Region - %@", region.identifier);
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSString *string = [[NSString alloc] initWithFormat:@"didStartMonitoringForRegion: %@", region];
    [self showMessage:string];
    
    NSLog(@"Started monitoring %@ region", region.identifier);
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self showMessage:@"didEnterRegion:"];
    NSLog(@"Entered Region - %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self showMessage:@"didExitRegion:"];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate date];
    localNotification.alertBody = @"CLRegionStateOutside";
    localNotification.alertAction = @"Show me app";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"Exited Region - %@", region.identifier);
}*/

@end
