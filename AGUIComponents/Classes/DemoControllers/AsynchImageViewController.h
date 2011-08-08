//
//  AsynchImageViewController.h
//  AGUIComponents
//
//  Created by Austen Green on 8/7/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGAsynchronousImageView.h"
#import "ARCLogic.h"

@interface AsynchImageViewController : UIViewController
@property (nonatomic, STRONGRETAIN) AGAsynchronousImageView *imageView;
@property (nonatomic, STRONGRETAIN) NSURL *imageURL;

@end
