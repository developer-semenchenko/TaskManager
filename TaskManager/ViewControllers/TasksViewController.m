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

    //float delay = 0.0;
    // Remove the task from  task array
    //[taskItems removeObject:taskItem];
    
    // Removing one object from array
    int n=[taskItems indexOfObject:taskItem];
    
    if(n<[taskItems count]){
        [taskItems removeObjectAtIndex:n];
    }
    
    // Find the visible cells
    NSArray* visibleCells = [self.tableView visibleCells];
    
    //UIView* lastView = [visibleCells lastObject];
    //bool startAnimating = true;
    
    // Iterate over all of the cells
    for(TaskTableViewCell* cell in visibleCells) {
        //if (startAnimating) {
            /*[UIView animateWithDuration:0.3
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 if (cell == lastView) {
                                     //[self.tableView reloadData];
                                     
                                     // Animate the table view reload
                                     [UIView transitionWithView: self.tableView duration:0.35f options: UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
                                         [self.tableView reloadData];*/
                                     
                                     
                                     //} completion:^(BOOL isFinished){
                                         // TODO: Whatever you want here
                                    //}];
                                     
                                // }
                             //}];
            //delay+=0.03;
        //}
        
        // If you have reached the item that was deleted, start animating
        if (cell.taskItem == taskItem) {
            //startAnimating = false;
            //cell.hidden = YES;

            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            //[_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
            
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [self animateCells];
            
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

-(void)animateCells{
    
    /*NSArray* newVisibleCells = [self.tableView visibleCells];
    float delay = 0.0;
    int i = 0;

    
    
        for(TaskTableViewCell* cell in newVisibleCells) {
            
                [UIView animateWithDuration:0.3
                                      delay:delay
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     if (i > 0){
                                         
                                         cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                                     }
                                 }
                                 completion:^(BOOL finished){
                                 }];
                
                delay+=0.03;
            i++;
            
        
    }*/


}
-(void)taskCompleted:(id)taskItem {
    
    float delay = 0.0;
    
    // Add completed task to file
    [CompletedTasksIO addCompletedTasksToFile:taskItem];
    
    // Remove the model object
    [taskItems removeObject:taskItem];
    
    // Find the visible cells
    NSArray* visibleCells = [self.tableView visibleCells];
    
    UIView* lastView = [visibleCells lastObject];
    bool startAnimating = false;
    
    // Iterate over all of the cells
    for(TaskTableViewCell* cell in visibleCells) {
        //NSLog(@"Cell id's = %@", cell.cellID);
        if (startAnimating) {
            [UIView animateWithDuration:0.3
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 if (cell == lastView) {
                                     //[self.tableView reloadData];
                                     
                                     /* Animate the table view reload */
                                     [UIView transitionWithView: self.tableView duration:0.35f options: UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
                                         [self.tableView reloadData];
                                     } completion:^(BOOL isFinished){
                                         /* TODO: Whatever you want here */
                                     }];
                                 }
                             }];
            delay+=0.03;
        }
        
        // If you have reached the item that was deleted, start animating
        if (cell.taskItem == taskItem) {
            startAnimating = true;
            cell.hidden = YES;
        }
    }
    
    [TasksIO saveTaskArray:taskItems];
    
    //NSLog(@"Tasks arrays after completing:\n allTasks = %@;\ncompletedTasks = %@", [TasksIO loadTasksFromFile], [CompletedTasksIO loadCompletedTasksFromFile]);
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
    
    NSLog(@"Cell id %@", cell.cellID);
    // Set delegate to self
    cell.delegate = self;
    cell.taskItem = taskDictionary;
    
    return cell;
}

@end
