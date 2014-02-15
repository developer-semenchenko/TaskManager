//
//  EmptyViewController.h
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/9/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "myLogInViewController.h"
#import "mySignUpViewController.h"

@interface EmptyViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

-(void)goToIntroViewController;

@end
