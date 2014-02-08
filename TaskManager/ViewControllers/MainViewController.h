//
//  ViewController.h
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/2/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import "TasksIO.h"
#import "TaskTableViewDelegate.h"
#import <Social/Social.h>
#import "PageContentViewController.h"


@interface MainViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *sidePanel;
@property (nonatomic, weak) ContainerViewController *containerViewController;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UIButton *buttonTasks;
@property (weak, nonatomic) IBOutlet UIButton *buttonCompletedTasks;
@property (weak, nonatomic) IBOutlet UIButton *buttonOptions;
@property (weak, nonatomic) IBOutlet UIButton *buttonAbout;
@property (weak, nonatomic) IBOutlet UIView *topPanel;
@property (weak, nonatomic) IBOutlet UIView *sideButton;
@property (weak, nonatomic) IBOutlet UIView *twButton;
@property (weak, nonatomic) IBOutlet UIView *fbButton;
@property (weak, nonatomic) IBOutlet UIView *addButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) NSArray *pageTitles;

- (IBAction)showSidePanel:(id)sender;
- (IBAction)addTask:(id)sender;
- (IBAction)openTasks:(id)sender;
- (IBAction)openCompletedTasks:(id)sender;
- (IBAction)openOptions:(id)sender;
- (IBAction)openAbout:(id)sender;

- (IBAction)sharingToTwitter:(id)sender;
- (IBAction)sharingToFacebook:(id)sender;
@end
