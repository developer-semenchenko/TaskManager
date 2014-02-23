//
//  TasksViewController.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/2/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "TasksViewController.h"

@interface TasksViewController ()
{
    // An array of tasks
    NSMutableArray* taskItems;
}

@end

@implementation TasksViewController

#pragma mark - Helper methods

-(void)reloadTableView {

    taskItems = [[TasksIO loadTasksFromFile] mutableCopy];
    
    [self.tableView reloadData];
}

-(void)lockTableView{
    [self.tableView setUserInteractionEnabled:NO];
}

-(void)unlockTableView{
    [self.tableView setUserInteractionEnabled:YES];
}

#pragma  mark - Defaul View life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"reloadTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockTableView) name:@"lockTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockTableView) name:@"unlockTableView" object:nil];

    // Load tasks from file
    taskItems = [[NSMutableArray alloc] init];
    taskItems = [[TasksIO loadTasksFromFile] mutableCopy];
    
    // Set cells class to TaskTablViewCell class
    [self.tableView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.118f green:0.157f blue:0.208f alpha:1.0f];
    
    // Hide unused cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TaskTableViewDelegate methods
-(void)taskDeleted:(id)taskItem {
    
    // Removing one object from array
    int n=[taskItems indexOfObject:taskItem];
    
    if(n<[taskItems count]){
        [taskItems removeObjectAtIndex:n];
    }
    
    // Find the visible cells
    NSArray* visibleCells = [self.tableView visibleCells];
    
    // Iterate over all of the cells
    for(TaskTableViewCell* cell in visibleCells) {
        
        // If you have reached the item that was deleted, start animating
        if (cell.taskItem == taskItem) {
            
            // delete cell from tableView
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            // Delete location manager monitored region if deleted tasks text = region text
            AddTaskViewController *sharedLocManager = [AddTaskViewController sharedLocationController];
            
            for (CLRegion *monitored in [sharedLocManager.locationManager monitoredRegions]){
                if ([monitored.identifier isEqualToString:cell.textLabel.text]){
                    [sharedLocManager.locationManager stopMonitoringForRegion:monitored];
                }
            }
        }
    }
    
    // Saving tasks to file
    [TasksIO saveTaskArray:taskItems];
    
}

-(void)taskCompleted:(id)taskItem {
    
    
    // Add completed task to file
    [CompletedTasksIO addCompletedTasksToFile:taskItem];
    
    // Removing one object from array
    int n=[taskItems indexOfObject:taskItem];
    
    if(n<[taskItems count]){
        [taskItems removeObjectAtIndex:n];
    }
    
    // Find the visible cells
    NSArray* visibleCells = [self.tableView visibleCells];
    
    // Iterate over all of the cells
    for(TaskTableViewCell* cell in visibleCells) {
                
        // If you have reached the item that was deleted, start animating
        if (cell.taskItem == taskItem) {
            
            // delete cell from tableView
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            
            // Delete location manager monitored region if deleted tasks text = region text
            AddTaskViewController *sharedLocManager = [AddTaskViewController sharedLocationController];
            
            for (CLRegion *monitored in [sharedLocManager.locationManager monitoredRegions]){
                if ([monitored.identifier isEqualToString:cell.textLabel.text]){
                    [sharedLocManager.locationManager stopMonitoringForRegion:monitored];
                }
            }

        }
    }
    
    [TasksIO saveTaskArray:taskItems];
    
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithRed:0.3 green:0.35 blue:0.4 alpha:1.0];
}

#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return taskItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"cell";
    
    // Re-use or create a cell
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    
    // Find the task item for this index
    int index = [indexPath row];
    NSDictionary *taskDictionary = [taskItems objectAtIndex:index];
    NSString *taskText = [taskDictionary objectForKey:@"Task text"];
    NSNumber *taskId = [taskDictionary objectForKey:@"Id"];

    // Set the text and other customization
    cell.textLabel.text = taskText;
    cell.cellID = taskId;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    // Set delegate to self
    cell.delegate = self;
    cell.taskItem = taskDictionary;
    
    return cell;
}

@end
