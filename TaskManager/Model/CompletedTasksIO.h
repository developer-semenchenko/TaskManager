//
//  CompletedTasksIO.h
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/8/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompletedTasksIO : NSObject

+(NSArray *)loadCompletedTasksFromFile;
+(void)addCompletedTasksToFile:(NSDictionary *) tasksDictionary;
+(void)saveCompletedTaskArray:(NSMutableArray *) taskArray;

@end
