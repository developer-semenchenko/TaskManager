//
//  TasksID.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/23/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

// Helper function to get path to myTasks.plist file
NSString *pathToIDFile()
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathToDoc = pathList[0];
    NSString *pathToIDFile = [[NSString alloc] initWithFormat:@"%@/myTasksID.plist", pathToDoc];
    
    // Check if file myTasks.plist exist in Documents folder
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathToIDFile])
    {
        // If not - creting root array and writing to file
        NSNumber *initNumber = [[NSNumber alloc] initWithInt:0];

        NSArray *rootArray = [[NSArray alloc] initWithObjects:initNumber, nil];
        [rootArray writeToFile:pathToIDFile atomically:YES];
    }
    
    return pathToIDFile;
}

#import "TasksID.h"

@implementation TasksID

+(NSArray *)loadTasksID
{
    NSArray *arrayWithTasksID = [[NSArray alloc] initWithContentsOfFile:pathToIDFile()];
    
    return arrayWithTasksID;
}


+(void)saveTaskID:(NSMutableArray *)taskIDArray
{
    [taskIDArray writeToFile:pathToIDFile() atomically:YES];
}

@end
