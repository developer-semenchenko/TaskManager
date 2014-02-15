//
//  myLogInViewController.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/10/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "myLogInViewController.h"

@implementation myLogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.logInView setBackgroundColor:[UIColor colorWithRed:0.163 green:0.280 blue:0.565 alpha:1.000]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    
    // Add login field background
    fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.logInView insertSubview:fieldsBackground atIndex:1];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:0.304 green:0.494 blue:0.793 alpha:1.000]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:0.304 green:0.494 blue:0.793 alpha:1.000]];
    
    // Hiding dismiss button
    [self.logInView.dismissButton setHidden:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
    [fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
}


@end
