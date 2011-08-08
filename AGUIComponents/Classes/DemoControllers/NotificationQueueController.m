//
//  NotificationQueueController.m
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

#import "NotificationQueueController.h"
#import "AGUINotificationQueue.h"
#import "AGNotificationView.h"

@implementation NotificationQueueController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [AGUINotificationQueue defaultQueue];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Queue" style:UIBarButtonItemStyleBordered target:self action:@selector(queueUp)] autorelease];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Flush" style:UIBarButtonItemStyleDone target:[AGUINotificationQueue defaultQueue] action:@selector(flushQueue)] autorelease];
    }
    return self;
}

- (void)queueUp
{
    AGNotificationView *view = [[[AGNotificationView alloc] init] autorelease];
    view.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg", viewCount]];
    //view.textLabel.text = [NSString stringWithFormat:@"This is test: %d and then a a lot more extra text to pad out the bottom.", viewCount];
    view.textLabel.text = @"Foursquare post complete!";
    [[AGUINotificationQueue defaultQueue] addView:view displayDuration: (CGFloat)viewCount * 0.5];
    viewCount++;
    if (viewCount > 7)
        viewCount = 0;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
