//
//  TCUINotificationQueue.h
//  UIPlayground
//
//  Created by Austen Green on 8/7/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCUINotificationQueue : NSObject
{
    NSMutableArray *_notificationQueue;
    NSTimer *timer;
}
@property (nonatomic, assign) NSTimeInterval defaultDisplayDuration;
@property (nonatomic, assign) NSTimeInterval fadeDuration;
@property (nonatomic, readonly, retain) UIView *currentView;

+ (TCUINotificationQueue *)defaultQueue;

- (void)addView:(UIView *)view;
- (void)addView:(UIView *)view displayDuration:(NSTimeInterval)duration;

- (void)flushQueue; // Dismisses the current view without animation
- (void)dismissCurrentView:(BOOL)animated;

@end
