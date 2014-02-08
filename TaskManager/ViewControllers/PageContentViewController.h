//
//  PageContentViewController.h
//  TaskManager
//
//  Created by Vladyslav Semenchenko on 2/6/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *introductionTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *goToAppButton;

@property NSUInteger pageIndex;
@property NSString *labelText;

- (IBAction)goToApp:(id)sender;
@end
