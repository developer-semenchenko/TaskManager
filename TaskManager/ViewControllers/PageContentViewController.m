//
//  PageContentViewController.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/6/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToApp:(id)sender {
    
}
@end
