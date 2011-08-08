//
//  TCNotificationView.h
//  TopChef
//
//  Created by Austen Green on 8/1/11.
//  Copyright 2011 Bottle Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCNotificationView : UIView
{
	UIImageView *imageView;
}

@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, assign) BOOL displayCheckmark;

@end
