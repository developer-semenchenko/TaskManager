//
//  mySignUpViewController.m
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/10/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "mySignUpViewController.h"

@interface mySignUpViewController ()

@end

@implementation mySignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.signUpView setBackgroundColor:[UIColor colorWithRed:0.163 green:0.280 blue:0.565 alpha:1.000]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    
    // Set field text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:0.304 green:0.494 blue:0.793 alpha:1.000]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:0.304 green:0.494 blue:0.793 alpha:1.000]];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.signUpView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
}


@end
