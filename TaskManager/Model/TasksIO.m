//
//  TasksIO.m
//  TaskModel
//
//  Created by Vladyslav Semenchenko on 2/1/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

// Helper function to get path to myTasks.plist file
NSString *pathToTaskFile()
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathToDoc = pathList[0];
    NSString *pathToTasksFile = [[NSString alloc] initWithFormat:@"%@/myTasks.plist", pathToDoc];
    
    // Check if file myTasks.plist exist in Documents folder
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathToTasksFile])
    {
        // If not - creting root array and writing to file
        NSArray *rootArray = [[NSArray alloc] init];
        [rootArray writeToFile:pathToTasksFile atomically:YES];
    }
    
    return pathToTasksFile;
}

#import "TasksIO.h"

@implementation TasksIO

+(NSArray *)loadTasksFromFile
{
    NSArray *arrayWithTasks = [[NSArray alloc] initWithContentsOfFile:pathToTaskFile()];
    
    return arrayWithTasks;
}

+(void)addTasksToFile:(NSDictionary *)tasksDictionary
{
    NSMutableArray *arrayFromFile = [[self loadTasksFromFile] mutableCopy];
    [arrayFromFile addObject:tasksDictionary];
    
    [arrayFromFile writeToFile:pathToTaskFile() atomically:YES];
}

+(void)saveTaskArray:(NSMutableArray *)taskArray
{
    [taskArray writeToFile:pathToTaskFile() atomically:YES];
}

@end
