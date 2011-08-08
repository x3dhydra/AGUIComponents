//
//  TCNotificationView.m
//  TopChef
//
//  Created by Austen Green on 8/1/11.
//  Copyright 2011 Bottle Rocket Apps. All rights reserved.
//

#import "TCNotificationView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TCNotificationView
@synthesize textLabel = _textLabel, displayCheckmark = _displayCheckmark;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.layer.cornerRadius = 7.0;
		self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
		
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_textLabel.textColor = [UIColor whiteColor];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.font = [UIFont systemFontOfSize:20.0];
		_textLabel.numberOfLines = 0;
		_textLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_textLabel];
		
	}
	return self;
}

- (void)dealloc
{
	[imageView release];
	[_textLabel release];
	[super dealloc];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self sizeToFit];
}

- (void)layoutSubviews
{
	CGRect textFrame = CGRectInset(self.bounds, 10.0, 0.0);
	
	if (imageView)
	{
		imageView.center = CGPointMake(CGRectGetMidX(self.bounds), 30);
		textFrame.origin.y = CGRectGetMaxY(imageView.frame) + 10;
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
	
	if (imageView)
		size.height += 60;
		
	return size;
}

- (void)setDisplayCheckmark:(BOOL)displayCheckmark
{
	if (_displayCheckmark == displayCheckmark)
		return;
	
	_displayCheckmark = displayCheckmark;
	
	if (_displayCheckmark)
	{
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
		[self addSubview:imageView];
		[self setNeedsLayout];
	}
	else
	{
		[imageView removeFromSuperview];
		[imageView release];
		imageView = nil;
	}
}

@end
