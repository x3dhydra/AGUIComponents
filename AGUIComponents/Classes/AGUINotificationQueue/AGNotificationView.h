//
//  AGNotificationView.h
//  AGUIComponents
//
//  Created by Austen Green on 8/1/11.
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

// Convenience view for AGUINotificationQueue.  200 pts wide,
// dynamic height to account for image and text
@interface AGNotificationView : UIView
@property (nonatomic, readonly, STRONGRETAIN) UILabel *textLabel;
@property (nonatomic, readonly, STRONGRETAIN) UIImageView *imageView;

+ (AGNotificationView *)notificationViewWithText:(NSString *)text image:(UIImage *)image;

@end
