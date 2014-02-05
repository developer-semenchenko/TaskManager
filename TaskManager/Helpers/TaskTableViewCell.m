//
//  TaskTableViewCell.m
//  TableView
//
//  Created by Vladyslav Semenchenko on 2/1/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "TaskTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

// Constants
CGPoint _originalCenter;
BOOL _deleteOnDragRelease;
BOOL _completeOnDragRelease;
const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;

@implementation TaskTableViewCell
{
    UILabel *_tickLabel;
	UILabel *_crossLabel;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // For showing cues
        [self.contentView.superview setClipsToBounds:NO];
        
        // add a tick and cross
        _tickLabel = [self createCueLabel];
        _tickLabel.text = @"\u2713";
        _tickLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tickLabel];
        _crossLabel = [self createCueLabel];
        _crossLabel.text = @"\u2717";
        _crossLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_crossLabel];
        
        // Add gesture recognizer to cell
        UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

// utility method for creating the contextual cues
-(UILabel*) createCueLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    _tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0,
                                  UI_CUES_WIDTH, self.bounds.size.height);
    _crossLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0,
                                   UI_CUES_WIDTH, self.bounds.size.height);
}

#pragma mark - horizontal pan gesture methods
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    
    // Check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        // If the gesture has just started, record the current centre location
        _originalCenter = self.center;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        // Translate the center
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        
        // Determine whether the item has been dragged far enough to initiate a delete / complete
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 2;
        _completeOnDragRelease = self.frame.origin.x > self.frame.size.width / 2;
        
        // fade the contextual cues
        float cueAlpha = fabsf(self.frame.origin.x) / (self.frame.size.width / 2);
        _tickLabel.alpha = cueAlpha;
        _crossLabel.alpha = cueAlpha;
        
        // indicate when the item have been pulled far enough to invoke the given action
        _tickLabel.textColor = _completeOnDragRelease ?
        [UIColor greenColor] : [UIColor whiteColor];
        _crossLabel.textColor = _deleteOnDragRelease ?
        [UIColor redColor] : [UIColor whiteColor];
    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        // The frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        
        // If task completed
        if (_completeOnDragRelease) {
            
            // mark the item as complete and update the UI state
            NSLog(@"Completed");
        }
        
        // If task deleted
        if (!_deleteOnDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        else{
                // notify the delegate that this item should be deleted
                [self.delegate taskDeleted:self.taskItem];
        }
    }
    
    
}

@end