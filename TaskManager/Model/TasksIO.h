//
//  TasksIO.h
//  TaskModel
//
//  Created by Vladyslav Semenchenko on 2/1/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TasksIO : NSObject

//@property(strong, nonatomic) NSMutableArray *tasksArray;

+(NSArray *)loadTasksFromFile;
+(void)addTasksToFile:(NSDictionary *) tasksDictionary;
+(void)saveTaskArray:(NSMutableArray *) taskArray;

@end
