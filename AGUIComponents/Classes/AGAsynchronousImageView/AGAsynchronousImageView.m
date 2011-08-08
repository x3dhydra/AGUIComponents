//
//  AGAsynchronousImageView.m
//  UIPlayground
//
//  Created by Austen Green on 7/31/11.
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

#import "AGAsynchronousImageView.h"

@interface AGAsynchronousImageView ()
@property (nonatomic, retain) NSMutableData *data;
- (void)AG_updateImageForCurrentState;
- (void)setImage:(UIImage *)image forState:(AGImageViewState)state transitionImmediately:(BOOL)transition;

@end

@implementation AGAsynchronousImageView
@synthesize imageURL = _imageURL, data = _data, state = _state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithImageURL:(NSURL *)imageURL
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        [self commonInit];
        [self setImageURL:imageURL];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    NSInteger stateCount = 4;
    _stateImages = [[NSMutableArray alloc] initWithCapacity:stateCount];  // One for each state
    for (int i = 0; i < stateCount; i++)
    {
        [_stateImages addObject:[NSNull null]];
    }
}

- (void)dealloc
{
    [_connection cancel];
    NO_ARC(
    [_connection release];
    
    [_imageURL release];
    [_data release];
    [super dealloc];
    )
}

#pragma mark - ImageURL

- (void)setImageURL:(NSURL *)imageURL
{
    // Don't do anything special if the imageURL is the same
    if ([[imageURL absoluteString] isEqualToString:[_imageURL absoluteString]])
        return;
    
    // Stop the old connection
    [self cancel];
    
    // Change the internal imageURL
    NO_ARC([_imageURL release]);
    _imageURL = IF_ARC(imageURL, [imageURL retain]);
    
    // Start the new connection if the imageURL doesn't have 0 length
    NSString *imageString = [_imageURL absoluteString];
    if ([imageString length])
    {
        [self reload];
    }    
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.data)
        self.data = [[[NSMutableData alloc] init] autorelease];
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self willTransitionToState:AGImageViewStateFailed];
    
    self.data = nil;
    // TODO: Transition to state failed
    
    NO_ARC([_connection release]);
    _connection = nil;
    
    _state = AGImageViewStateFailed;
    [self didTransitionToState:AGImageViewStateFailed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [UIImage imageWithData:self.data];
    self.data = nil;
    
    [_connection release];
    _connection = nil;
    
    [self setImage:image forState:AGImageViewStateLoaded transitionImmediately:YES];
}

#pragma mark - Cancelling

- (void)cancel
{
    [self willTransitionToState:AGImageViewStateStub];
    
    // Don't need to cancel if we're not loading
    if ([self isLoading])
    {
        [self cancelDownloadForURL:_imageURL];
    }
    
    _state = AGImageViewStateStub;
    [self didTransitionToState:AGImageViewStateStub];
}

- (void)cancelDownloadForURL:(NSURL *)url
{
    // Base class just cancels the NSURLConnection
    [_connection cancel];
    [_connection release];
    _connection = nil;
}

#pragma mark - State images

- (void)setImage:(UIImage *)image forState:(AGImageViewState)state
{
    [self setImage:image forState:state transitionImmediately:NO];
}

- (UIImage *)imageForState:(AGImageViewState)state
{
    // Validate state before continuing
    if (state < AGImageViewStateStub || state > AGImageViewStateLoaded)
        [[NSException exceptionWithName:NSInvalidArgumentException 
                                 reason:[NSString stringWithFormat:@"state: %d not a valid AGImageViewState", state]
                               userInfo:nil] raise];
    
    
    UIImage *image = [_stateImages objectAtIndex:state];
    
    // Convert back from NSNull if the image should be nil
    if (image == (UIImage *)[NSNull null])
        image = nil;
    
    return image;
}

- (void)setImage:(UIImage *)image forState:(AGImageViewState)state transitionImmediately:(BOOL)transition
{
    // Validate state before continuing
    if (state < AGImageViewStateStub || state > AGImageViewStateLoaded)
        [[NSException exceptionWithName:NSInvalidArgumentException 
                                 reason:[NSString stringWithFormat:@"state: %d not a valid AGImageViewState", state]
                               userInfo:nil] raise];
    
    if (!image)
        image = (UIImage *)[NSNull null];  // Can't keep nil in the array
    
    [_stateImages replaceObjectAtIndex:state withObject:image];
    
    // If transition == YES, change states and update the view
    if (transition)
    {
        [self willTransitionToState:state];
        _state = state;
        [self didTransitionToState:state];
    }
    
    // Otherwise, check to see if the chaged state image corresponds to the current state, and update if appropriate
    else
    {
        if (self.state == state)
            [self AG_updateImageForCurrentState];
    }
}

- (void)AG_updateImageForCurrentState
{
    [super setImage:[self imageForState:self.state]];
}

#pragma mark - Loading

- (BOOL)isLoading
{
    return _connection != nil;
}

- (void)reload
{
    if ([self isLoading])
        [self cancel];
    
    if ([[_imageURL absoluteString] length])
    {
        [self beginDownloadForURL:_imageURL];
    }
}

- (void)beginDownloadForURL:(NSURL *)url
{
    if (!url)
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:[NSString stringWithFormat:@"%@ url must not be nil", NSStringFromSelector(_cmd)]
                               userInfo:nil] raise];
    
    [self willTransitionToState:AGImageViewStateLoading];
    
    // We assume that the connection has been cancelled at this point
    // so this method doesn't have to worry about releasing the old connection
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _state = AGImageViewStateLoading;
    [self didTransitionToState:AGImageViewStateLoading];
}

#pragma mark - State

- (void)willTransitionToState:(AGImageViewState)state
{
    // For subclasses
}

- (void)didTransitionToState:(AGImageViewState)state
{
    [self AG_updateImageForCurrentState];
}

@end
