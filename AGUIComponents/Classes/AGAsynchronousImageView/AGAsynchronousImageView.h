//
//  AGAsynchronousImageView.h
//  UIPlayground
//
//  Created by Austen Green on 7/31/11.
//  Copyright 2011 Austen Green Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef enum AGImageViewState
{
    AGImageViewStateStub,
    AGImageViewStateLoading,
    AGImageViewStateFailed,
    AGImageViewStateLoaded
} AGImageViewState;

// AGAsynchronousImageView is designed to be subclassed so that it can be coupled with
// some sort of image cache.  However, its base implementation uses NSURLConnection
// and the informal protocol associated with NSURLConnection.  The following methods
// from the NSURLConnection informal protocol are implemented by AGAsynchronousImageView:
//
//   connection:didReceiveData:
//   connection:didFailWithError:
//   connectionDidFinishLoading:
//

@interface AGAsynchronousImageView : UIImageView
{
    NSURLConnection *_connection;
    NSMutableData *_data;
    NSMutableArray *_stateImages;
}
@property (nonatomic, STRONGRETAIN) NSURL *imageURL;

// Subclasses that change how the image data is gathered should override isLoading.  
// Several of the subclass hooks provided by AGAsynchronousImageView use the value of this method
// to determine if other methods need to be called
@property (nonatomic, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, readonly) AGImageViewState state;

- (id)initWithImageURL:(NSURL *)imageURL;

// calls cancelDownloadForURL: if [self isLoading] == YES
- (void)cancel; 

// Cancels the current connection and reloads with the same image URL
- (void)reload; 

- (void)setImage:(UIImage *)image forState:(AGImageViewState)state;
- (UIImage *)imageForState:(AGImageViewState)state;

@end

@interface AGAsynchronousImageView (Subclasses)

- (void)commonInit; // Should be called by all init methods

- (void)willTransitionToState:(AGImageViewState)state; // Default implementation is empty
- (void)didTransitionToState:(AGImageViewState)state;  // Default implementation updates the current image

// Subclasses that override beginDownloadForURL: and cancelDownloadForURL: and do not call super are responsible for
// 1. calling willTransitionToState:self.state
// 2. setting self.state to the new state
// 3. calling didTransitionToState:self.state

// beginDownloadForURL: is the appropriate method for checking an image cache to see if an image is available
// for the given url before going to fetch it from the internet.  If a cached image would be available, then
// the subclass should call willTransistionToState:AGImageViewStateLoaded instead of the usual AGImageViewStateLoading
- (void)beginDownloadForURL:(NSURL *)url;  // Begins loading the url and transitions to AGImageViewStateLoading
- (void)cancelDownloadForURL:(NSURL *)url; // Cancels loading the url and transitions to AGImageViewStateStub

@end
