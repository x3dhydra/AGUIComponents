//
//  AsynchImageViewController.m
//  AGUIComponents
//
//  Created by Austen Green on 8/7/11.
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

#import "AsynchImageViewController.h"

@implementation AsynchImageViewController
@synthesize imageURL = _imageURL, imageView = _imageView;

#pragma mark - View lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
        _imageURL = [[NSURL alloc] initWithString: @"http://placekitten.com/320/320"];
        _imageView = [[AGAsynchronousImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 320)];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStyleBordered target:self action:@selector(loadImage)];
        self.navigationItem.rightBarButtonItem = item;
        NO_ARC([item release];)
    }
    return self;
}

- (void)dealloc
{
    NO_ARC(
    [_imageURL release];
    [_imageView release];
    [super dealloc];
    )
}
    

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    NO_ARC([view release]);
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.imageView = nil;
}

- (void)loadImage
{
   [self.imageView cancel];
    // If the [imageURL absoluteString] is the same as the one the image view already has,
    // it doesn't reload.
    if ([[self.imageView.imageURL absoluteString] isEqualToString:[self.imageURL absoluteString]])
        [self.imageView reload];
    else
        self.imageView.imageURL = self.imageURL;
}

@end
