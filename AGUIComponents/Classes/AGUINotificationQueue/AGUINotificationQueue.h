//
//  AGUINotificationQueue.h
//  UIPlayground
//
//  Created by Austen Green on 8/7/11.
//  Last Modified by Austen Green on 8/7/11.
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.

#import <UIKit/UIKit.h>

@interface AGUINotificationQueue : NSObject
{
    NSMutableArray *_notificationQueue;
    NSTimer *timer;
}
@property (nonatomic, WEAKASSIGN) NSTimeInterval defaultDisplayDuration;
@property (nonatomic, WEAKASSIGN) NSTimeInterval fadeDuration;
@property (nonatomic, readonly, STRONGRETAIN) UIView *currentView;

+ (AGUINotificationQueue *)defaultQueue;

- (void)addView:(UIView *)view;
- (void)addView:(UIView *)view displayDuration:(NSTimeInterval)duration;

- (void)flushQueue; // Dismisses the current view without animation
- (void)dismissCurrentView:(BOOL)animated;

@end
