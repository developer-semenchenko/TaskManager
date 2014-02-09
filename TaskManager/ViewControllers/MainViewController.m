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

#pragma  mark - Defaul View life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update"];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    // Checking first time launch
    if ([userDefaults boolForKey:@"firstLaunch"])
    {
        // app already launched
        
        // Showing UI
        _topPanel.alpha = 1;
        _sideButton.alpha = 1;
        _twButton.alpha = 1;
        _fbButton.alpha = 1;
        _addButton.alpha = 1;
        _containerView.alpha = 1;
        
    }
    else
    {
        
        // Hiding UI
        _topPanel.alpha = 0;
        _sideButton.alpha = 0;
        _twButton.alpha = 0;
        _fbButton.alpha = 0;
        _addButton.alpha = 0;
        _containerView.alpha = 0;
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create page view controller
        self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        self.pageViewController.dataSource = self;
        
        PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        // Change the size of page view controller
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
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
    CGRect newMainViewFrame = _mainView.frame;
    newMainViewFrame.origin.x += 70;
    
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = -1.0 / 500.0;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 45, 0, 1, 0);
    
    // Sliding mainView to show SidePanel
    
    if (!isShowingSideView){
    [UIView animateWithDuration:0.5 animations:^{
        _mainView.frame = newMainViewFrame;
        _sidePanel.alpha = 1.0f;
        _buttonTasks.alpha = 1.0f;
        _buttonCompletedTasks.alpha = 1.0f;
        _buttonOptions.alpha = 1.0f;
        _buttonAbout.alpha = 1.0f;
        
    }];
        isShowingSideView = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lockTableView" object:nil];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            _mainView.frame = self.view.frame;
            _sidePanel.alpha = 0.0f;
            _buttonTasks.alpha = 0.0f;
            _buttonCompletedTasks.alpha = 0.0f;
            _buttonOptions.alpha = 0.0f;
            _buttonAbout.alpha = 0.0f;
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
        _mainView.frame = self.view.frame;
        _sidePanel.alpha = 0.0f;
        _buttonTasks.alpha = 0.0f;
        _buttonCompletedTasks.alpha = 0.0f;
        _buttonOptions.alpha = 0.0f;
        _buttonAbout.alpha = 0.0f;
    }];
    isShowingSideView = NO;
}

- (IBAction)openCompletedTasks:(id)sender {
    [self.containerViewController swapToCompletedTasks];
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.frame = self.view.frame;
        _sidePanel.alpha = 0.0f;
        _buttonTasks.alpha = 0.0f;
        _buttonCompletedTasks.alpha = 0.0f;
        _buttonOptions.alpha = 0.0f;
        _buttonAbout.alpha = 0.0f;
    }];
    isShowingSideView = NO;
}

- (IBAction)openOptions:(id)sender {
    [self.containerViewController swapToOptions];
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.frame = self.view.frame;
        _sidePanel.alpha = 0.0f;
        _buttonTasks.alpha = 0.0f;
        _buttonCompletedTasks.alpha = 0.0f;
        _buttonOptions.alpha = 0.0f;
        _buttonAbout.alpha = 0.0f;
    }];
    isShowingSideView = NO;
}

- (IBAction)openAbout:(id)sender {
    [self.containerViewController swapToAbout];
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.frame = self.view.frame;
        _sidePanel.alpha = 0.0f;
        _buttonTasks.alpha = 0.0f;
        _buttonCompletedTasks.alpha = 0.0f;
        _buttonOptions.alpha = 0.0f;
        _buttonAbout.alpha = 0.0f;
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
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


-(void)reloadSelf
{
    NSLog(@"something");
    
    [self.pageViewController dismissViewControllerAnimated:YES completion:Nil];
}
@end
