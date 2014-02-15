//
//  CompletedTasksViewController.h
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/2/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompletedTasksIO.h"

@interface CompletedTasksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
