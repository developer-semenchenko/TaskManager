//
//  PageContentViewController.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/6/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "PageContentViewController.h"
#import <Parse/Parse.h>

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.pageIndex == 3){
        [UIView animateWithDuration:0.5 animations:^(){
            self.goToAppButton.alpha = 1.0;
        }completion:^(BOOL finished){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.goToAppButton setEnabled:YES];
            
        }];
    }
    
    self.introductionTextLabel.text = self.labelText;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
