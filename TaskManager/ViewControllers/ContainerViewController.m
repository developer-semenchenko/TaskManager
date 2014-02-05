//
//  ContainerViewController.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/2/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "ContainerViewController.h"
#import "TasksViewController.h"
#import "CompletedTasksViewController.h"
#import "OptionsViewController.h"
#import "AboutViewController.h"

#define SegueIdentifierFirst @"embedTasks"
#define SegueIdentifierSecond @"embedCompleteTasks"
#define SegueIdentifierThird @"embedOptions"
#define SegueIdentifierFourth @"embedAbout"

@interface ContainerViewController ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) TasksViewController *tasksViewController;
@property (strong, nonatomic) CompletedTasksViewController *completedTasksViewController;
@property (strong, nonatomic) OptionsViewController *optionsViewController;
@property (strong, nonatomic) AboutViewController *aboutViewController;
@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierFirst;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if (([segue.identifier isEqualToString:SegueIdentifierFirst]) /*&& !self.tasksViewController*/) {
        self.tasksViewController = segue.destinationViewController;
    }

    if (([segue.identifier isEqualToString:SegueIdentifierSecond]) /*&& !self.completedTasksViewController*/) {
        self.completedTasksViewController = segue.destinationViewController;
    }
    
    if (([segue.identifier isEqualToString:SegueIdentifierThird]) /*&& !self.optionsViewController*/) {
        self.optionsViewController = segue.destinationViewController;
    }
    
    if (([segue.identifier isEqualToString:SegueIdentifierFourth]) /*&& !self.aboutViewController*/) {
        self.aboutViewController = segue.destinationViewController;
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierFirst]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.tasksViewController];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:SegueIdentifierSecond]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.completedTasksViewController];
    }
    else if ([segue.identifier isEqualToString:SegueIdentifierThird]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.optionsViewController];
    }
    else if ([segue.identifier isEqualToString:SegueIdentifierFourth]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.aboutViewController];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];

    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

- (void)swapToTasks
{
    if (self.transitionInProgress) {
        return;
    }

    self.transitionInProgress = YES;
    self.currentSegueIdentifier = SegueIdentifierFirst;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)swapToCompletedTasks
{
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueIdentifier = SegueIdentifierSecond;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)swapToOptions
{
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueIdentifier = SegueIdentifierThird;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)swapToAbout
{
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueIdentifier = SegueIdentifierFourth;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}
@end
