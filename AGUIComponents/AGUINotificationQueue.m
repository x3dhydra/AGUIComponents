//
//  TCUINotificationQueue.m
//  UIPlayground
//
//  Created by Austen Green on 8/7/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#import "TCUINotificationQueue.h"

static TCUINotificationQueue *_defaultQueue;

// Encapsulates information for queue
@interface TCNotificationQueueItem : NSObject
@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) NSTimeInterval displayDuration;
+ (TCNotificationQueueItem *)notificationItemWithView:(UIView *)view displayDuration:(NSTimeInterval)duration;
@end

@implementation TCNotificationQueueItem
@synthesize view = _view, displayDuration = _displayDuration;

+ (TCNotificationQueueItem *)notificationItemWithView:(UIView *)view displayDuration:(NSTimeInterval)duration
{
    TCNotificationQueueItem *item = [[[TCNotificationQueueItem alloc] init] autorelease];
    item.view = view;
    item.displayDuration = duration;
    return item;
}

- (void)dealloc
{
    [_view removeFromSuperview];
    [_view release];
    [super dealloc];
}

@end

@interface TCUINotificationQueue ()

@property (nonatomic, readwrite, retain) UIView *currentView;

- (void)displayNextView:(BOOL)animated;

@end

@implementation TCUINotificationQueue
@synthesize currentView = _currentView, fadeDuration = _fadeDuration, defaultDisplayDuration = _defaultDisplayDuration;

// Singleton queue
+ (TCUINotificationQueue *)defaultQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultQueue = [[TCUINotificationQueue alloc] init];
    });
    return _defaultQueue;
}

- (id)copy
{
    return self;
}

#if !__has_feature(objc_arc)
- (oneway void)release {}
- (id)retain {return self;}
- (NSUInteger)retainCount {return NSUIntegerMax;}
#endif

- (id)init
{
    self = [super init];
    if (self) 
    {
        _notificationQueue = [[NSMutableArray alloc] init];
        // Defaults
        _defaultDisplayDuration = 2.0;  
        _fadeDuration = 0.5;            
    } 
    return self;
}

- (void)dealloc
{
    [timer invalidate];
    [_notificationQueue release];
    [_currentView release];
    [super dealloc];
}

// Add view with default display duration
- (void)addView:(UIView *)view
{
    [self addView:view displayDuration:self.defaultDisplayDuration];
}

// Queue the view and display the next view (if needed)
- (void)addView:(UIView *)view displayDuration:(NSTimeInterval)duration
{
    TCNotificationQueueItem *item = [TCNotificationQueueItem notificationItemWithView:view displayDuration:duration];
    [_notificationQueue insertObject:item atIndex:0];
    [self displayNextView:YES];
}

- (void)displayNextView:(BOOL)animated
{
    // Don't display another view if there's already one being displayed
    if (self.currentView)
        return;
    
    // Invalidate the timer
    [timer invalidate];
    timer = nil;
    
    // And return early if there's no item in the queue
    TCNotificationQueueItem *item = [_notificationQueue lastObject];
    if (!item)
        return;
    
    // The notification views go in the middle of the key window
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:item.view];
    item.view.center = window.center;
    
    
    NSTimeInterval duration = animated ? self.fadeDuration : 0.0;
    
    item.view.alpha = 0.0;
    self.currentView = item.view;

    // Don't forget to allow user interaction... it would be annoying if the UI locked every time
    // a notification came into view
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                        item.view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         // Schedule a timer to fire so that the notification will be dismissed
                         timer = [NSTimer scheduledTimerWithTimeInterval:item.displayDuration target:self selector:@selector(dismissView:) userInfo:nil repeats:NO];
                     }];
}

// Dismiss the view due to a timer fire
- (void)dismissView:(NSTimer *)aTimer
{
    [self dismissCurrentView:YES];
}

- (void)dismissCurrentView:(BOOL)animated
{
    // Return early if there is no view to dismiss
    if (!self.currentView)
        return;
    
    // Invalid the timer (in case this method was called by the user)
    [timer invalidate];
    timer = nil;
    
    NSTimeInterval duration = animated ? self.fadeDuration : 0.0;
    
    // Again, make sure to allow user interaction
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                         // Fade out
                       self.currentView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         // Clean up the current view
                         [self.currentView removeFromSuperview];
                         self.currentView = nil;
                         // Remove the item from the queue
                         if ([_notificationQueue count])
                             [_notificationQueue removeLastObject];
                         // And display the next view - displayNextView: will return early if there are no queued items left
                         [self displayNextView:YES];
                     }];
}

- (void)flushQueue
{
    // Get rid of all items in the queue and dismiss the current view
    [_notificationQueue removeAllObjects];
    [self dismissCurrentView:NO];
}

@end
