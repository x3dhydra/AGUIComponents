//
//  AGNotificationView.m
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

#import "AGNotificationView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AGNotificationView
@synthesize textLabel = _textLabel, imageView = _imageView;

+ (AGNotificationView *)notificationViewWithText:(NSString *)text image:(UIImage *)image
{
    AGNotificationView *view = [[AGNotificationView alloc] init];
    view.textLabel.text = text;
    view.imageView.image = image;
    NO_ARC([view autorelease]);
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.layer.cornerRadius = 7.0;
		self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
		
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_textLabel.textColor = [UIColor whiteColor];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.font = [UIFont systemFontOfSize:20.0];
		_textLabel.numberOfLines = 0;
		_textLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_textLabel];
		
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
	}
	return self;
}

- (void)dealloc
{
    NO_ARC(
	[_imageView release];
	[_textLabel release];
	[super dealloc];
    )
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
        return;
    
    [self.imageView sizeToFit];
    [self sizeToFit];
}
- (void)layoutSubviews
{
	CGRect textFrame = CGRectInset(self.bounds, 10.0, 0.0);
	
	if (CGRectGetHeight(self.imageView.bounds) > 0.0)
	{
        self.imageView.layer.anchorPoint = CGPointMake(0.5, 0.0);
		self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), 10);
		textFrame.origin.y = CGRectGetMaxY(self.imageView.frame) + 10;
	}
	
	CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:textFrame.size];
	textFrame.size.height = size.height;
	self.textLabel.frame = textFrame;
}

- (CGSize)sizeThatFits:(CGSize)aSize
{

	CGRect textFrame = CGRectMake(0, 0, 180, 480);
	CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:textFrame.size];
	size.width = 200;
	
	if (CGRectGetHeight(self.imageView.bounds) > 0.0)
		size.height += CGRectGetHeight(self.imageView.bounds) + 20; // 10 pt border on top / bottom of imageView
		
	return size;
}

@end
