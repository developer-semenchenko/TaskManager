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
-(void)disableTableViewInteraction
{
    [self.tableView setUserInteractionEnabled:NO];
}

-(void)enableTableViewInteraction
{
    [self.tableView setUserInteractionEnabled:YES];
}

-(void)reloadTableView {
    tasks = [[TasksIO alloc] init];
    taskItems = [[tasks loadTasksFromFile] mutableCopy];
    [self.tableView reloadData];
}

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
	// Do any additional setup after loading the view.
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"reloadTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockTableView) name:@"lockTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockTableView) name:@"unlockTableView" object:nil];

    // Load tasks from file
    taskItems = [[NSMutableArray alloc] init];
    tasks = [[TasksIO alloc] init];
    taskItems = [[tasks loadTasksFromFile] mutableCopy];
    
    // Set cells class to TaskTablViewCell class
    [self.tableView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.118f green:0.157f blue:0.208f alpha:1.0f];
    
    // Hide unused cells
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TaskTableViewDelegate methods
-(void)taskDeleted:(id)taskItem {
    // use the UITableView to animate the removal of this row
    /*NSUInteger index = [taskItems indexOfObject:taskItem];
    [self.tableView beginUpdates];
    [taskItems removeObject:taskItem];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [tasks saveTaskArray:taskItems];
    [self.tableView endUpdates];*/
    
    float delay = 0.0;
    
    // remove the model object
    [taskItems removeObject:taskItem];
    
    // find the visible cells
    NSArray* visibleCells = [self.tableView visibleCells];
    
    UIView* lastView = [visibleCells lastObject];
    bool startAnimating = false;
    
    // iterate over all of the cells
    for(TaskTableViewCell* cell in visibleCells) {
        if (startAnimating) {
            [UIView animateWithDuration:0.3
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 if (cell == lastView) {
                                     [self.tableView reloadData];
                                 }
                             }];
            delay+=0.03;
        }
        
        // if you have reached the item that was deleted, start animating
        if (cell.taskItem == taskItem) {
            startAnimating = true;
            cell.hidden = YES;
        }
    }
    [tasks saveTaskArray:taskItems];
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithRed:0.3 green:0.35 blue:0.4 alpha:1.0];}

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
    
    // Set the text and other customization
    cell.textLabel.text = taskText;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    // Set delegate to self
    cell.delegate = self;
    cell.taskItem = taskDictionary;
    
    return cell;
}

@end
