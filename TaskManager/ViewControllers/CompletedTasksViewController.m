//
//  CompletedTasksViewController.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/2/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "CompletedTasksViewController.h"

@interface CompletedTasksViewController ()
{
    NSArray *completedTasks;
}
@end

@implementation CompletedTasksViewController

#pragma mark - Helper methods
-(void)lockTableView{
    [self.tableView setUserInteractionEnabled:NO];
}

-(void)unlockTableView{
    [self.tableView setUserInteractionEnabled:YES];
}

#pragma mark - Default methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockTableView) name:@"lockTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockTableView) name:@"unlockTableView" object:nil];
    
    completedTasks = [CompletedTasksIO loadCompletedTasksFromFile];
    self.textLabel.text = [[NSString alloc] initWithFormat:@"Total completed tasks: %d", [completedTasks count]];
    
    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.118f green:0.157f blue:0.208f alpha:1.0f];
    
    // Hide unused cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // For show last cell
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return completedTasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Re-use or create a cell    
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Find the task item for this index
    int index = [indexPath row];
    NSDictionary *taskDictionary = [completedTasks objectAtIndex:index];
    NSString *taskText = [taskDictionary objectForKey:@"Task text"];
    
    // Set the text and other customization
    cell.textLabel.text = taskText;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

@end
