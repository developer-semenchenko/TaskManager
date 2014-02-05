//
//  TaskTableViewDelegate.h
//  TableView
//
//  Created by Vladyslav Semenchenko on 2/1/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TasksIO.h"

// A protocol that the TaskTableView uses to inform of state change
@protocol TaskTableViewDelegate <NSObject>

// Realod tableView
- (void)reloadTableView;
// Indicates that the given item has been deleted
-(void)taskDeleted:(NSDictionary *)taskItem;

@end

