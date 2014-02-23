//
//  TaskTableViewCell.h
//  TableView
//
//  Created by Vladyslav Semenchenko on 2/1/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasksIO.h"
#import "TaskTableViewDelegate.h"

@interface TaskTableViewCell : UITableViewCell

// The item that this cell renders.
@property (nonatomic) NSDictionary *taskItem;
@property (nonatomic) NSNumber *cellID;

// The object that acts as delegate for this cell.
@property (nonatomic, assign) id<TaskTableViewDelegate> delegate;

@end
