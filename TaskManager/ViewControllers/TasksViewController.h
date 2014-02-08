//
//  TasksViewController.h
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/2/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasksIO.h"
#import "CompletedTasksIO.h"
#import "TaskTableViewCell.h"

@interface TasksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TaskTableViewDelegate>
{
    TasksIO *tasks;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)disableTableViewInteraction;
-(void)enableTableViewInteraction;

- (void)reloadTableView;

@end
