//
//  TasksID.h
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/23/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TasksID : NSObject

+(NSArray *)loadTasksID;
+(void)saveTaskID:(NSMutableArray *)taskIDArray;
@end
