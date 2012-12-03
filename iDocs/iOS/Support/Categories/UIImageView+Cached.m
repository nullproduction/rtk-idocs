//  UIImageView+Cached.h
//
//  Created by Lane Roathe
//  Copyright 2009 Ideas From the Deep, llc. All rights reserved.

#import "UIImageView+Cached.h"
#import "UIImage+Resize.h"
#import "Constants.h"
#pragma mark --- Threaded & Cached image loading ---

@interface UIImageView (PrivateMethods)

-(void)didFinishLoading:(UIImage *)data;
-(void)startProgressBar;
-(void)stopProgressBar;

@end

@implementation UIImageView (Cached)

#define MAX_CACHED_IMAGES 50	// max # of images we will cache before flushing cache and starting over

// method to return a static cache reference (ie, no need for an init method)
- (NSMutableDictionary *)cache {
	static NSMutableDictionary* _cache = nil;
	
	if(!_cache)
		_cache = [NSMutableDictionary dictionaryWithCapacity:MAX_CACHED_IMAGES];
	
	assert(_cache);
	return _cache;
}

// Loads an image from a URL, caching it for later loads
// This can be called directly, or via one of the threaded accessors
- (void)cacheFromURL:(NSURL*)url {
	UIImage* newImage = [[self cache] objectForKey:url.description];
	if (!newImage) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSError *err = nil;

		[self startProgressBar];
		newImage = [[UIImage imageWithData:[NSData dataWithContentsOfURL:url options:0 error:&err]] retain];
		[self stopProgressBar];
		
		if(newImage) {
			// check to see if we should flush existing cached items before adding this new item
			if ([[self cache] count] >= MAX_CACHED_IMAGES)
				[[self cache] removeAllObjects];
			
			[[self cache] setValue:newImage forKey:url.description];
            [newImage release];
		}
		else {
			NSLog(@"UIImageView:LoadImage Failed: %@", err);
        }
		[pool drain];
	}
	
	if(newImage) {
		[self performSelectorOnMainThread:@selector(didFinishLoading:) withObject:newImage waitUntilDone:NO];
    }
}

// Methods to load and cache an image from a URL on a separate thread
- (void)loadFromURL:(NSURL *)url {
	[self performSelectorInBackground:@selector(cacheFromURL:) withObject:url]; 
}

- (void)loadFromURL:(NSURL*)url afterDelay:(float)delay {
	[self performSelector:@selector(loadFromURL:) withObject:url afterDelay:delay];
}

- (void)didFinishLoading:(UIImage *)data {
	[self setImage:[data thumbnailImage:floor(self.frame.size.width) 
								  transparentBorder:0 cornerRadius:constCornerRadius interpolationQuality:3]];	
}

- (void)startProgressBar {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	CGRect activityIndicatorFrame = [self frame];
	activityIndicator.tag = constImageLoadingActivityIndicator;
	activityIndicator.frame = CGRectMake(activityIndicatorFrame.size.width/2-18, activityIndicatorFrame.size.height/2-18, 37.0f, 37.0f);
	[activityIndicator startAnimating];
	[self addSubview:activityIndicator];	
	[activityIndicator release];
}

- (void)stopProgressBar {
	for (int i = 0; i<[self.subviews count]; i++) {
		UIView *subview = (UIView *)[self.subviews objectAtIndex:i];
		if (subview.tag == constImageLoadingActivityIndicator) {
			[subview removeFromSuperview];
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			return;
		}
	}
}
@end
