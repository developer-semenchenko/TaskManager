//
//  CompletedTasksIO.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/8/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "CompletedTasksIO.h"

// Helper function to get path to myTasks.plist file
NSString *pathToCompletedTaskFile()
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathToDoc = pathList[0];
    NSString *pathToTasksFile = [[NSString alloc] initWithFormat:@"%@/myCompletedTasks.plist", pathToDoc];
    
    // Check if file myTasks.plist exist in Documents folder
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathToTasksFile])
    {
        // If not - creting root array and writing to file
        NSArray *rootArray = [[NSArray alloc] init];
        [rootArray writeToFile:pathToTasksFile atomically:YES];
    }
    
    return pathToTasksFile;
}

@implementation CompletedTasksIO

+(NSArray *)loadCompletedTasksFromFile
{
    NSArray *arrayWithTasks = [[NSArray alloc] initWithContentsOfFile:pathToCompletedTaskFile()];
    
    return arrayWithTasks;
}

+(void)addCompletedTasksToFile:(NSDictionary *)tasksDictionary
{
    NSMutableArray *arrayFromFile = [[self loadCompletedTasksFromFile] mutableCopy];
    [arrayFromFile insertObject:tasksDictionary atIndex:0];
    
    [arrayFromFile writeToFile:pathToCompletedTaskFile() atomically:YES];
}

+(void)saveCompletedTaskArray:(NSMutableArray *)taskArray
{
    [taskArray writeToFile:pathToCompletedTaskFile() atomically:YES];
}


@end
