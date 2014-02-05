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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
       //_slidePanel.layer.transform = rotationAndPerspectiveTransform;
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
            //_slidePanel.layer.transform = rotationAndPerspectiveTransform;
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
    TasksIO *tasks = [[TasksIO alloc] init];
    NSMutableArray *tasksArray = [[tasks loadTasksFromFile] mutableCopy];
    NSString *taskText = [[NSString alloc] initWithFormat:@"Task text %d", [tasksArray count]];
    NSDictionary *newTask = [[NSDictionary alloc] initWithObjectsAndKeys: taskText, @"Task text", nil];
    [tasksArray insertObject:newTask atIndex:0];
    [tasks saveTaskArray:tasksArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil];
}

#pragma mark - SidePanel methods
- (IBAction)openTasks:(id)sender {
    [self.containerViewController swapToTasks];
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.frame = self.view.frame;
        //_slidePanel.layer.transform = rotationAndPerspectiveTransform;
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
        //_slidePanel.layer.transform = rotationAndPerspectiveTransform;
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
        //_slidePanel.layer.transform = rotationAndPerspectiveTransform;
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
        //_slidePanel.layer.transform = rotationAndPerspectiveTransform;
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
    TasksIO *tasks = [[TasksIO alloc] init];
    NSArray *tasksArray = [tasks loadTasksFromFile];
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
    TasksIO *tasks = [[TasksIO alloc] init];
    NSArray *tasksArray = [tasks loadTasksFromFile];
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
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
@end
