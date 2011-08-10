//
//  FlickrViewController.m
//  TEDxAlcatraz
//
//  Created by Peter Ma on 8/9/11.
//  Copyright (c) 2011 Catch.com. All rights reserved.
//

#import "FlickrViewController.h"
#import "JSON.h"
#import "ZoomedImageView.h"
#import "TEDxAlcatrazGlobal.h"
#import <QuartzCore/QuartzCore.h>

#define debug(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);
#define flickrImageWidth 57
#define space 18
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface FlickrViewController(private)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)slideViewOffScreen;
@end

//#error 
// Replace this with your Flickr key
NSString *const FlickrAPIKey = @"b48ec44427c1dc3327d14e31ab055b9b";


@implementation FlickrViewController

@synthesize scrollView;
/**************************************************************************
 *
 * Private implementation section
 *
 **************************************************************************/

#pragma mark -
#pragma mark Private Methods

- (void) loadScrollView
{
    [scrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, ceilf([photoSmallImageData count]/4 + 3)*60)];

    for(int i = 0; i < [photoSmallImageData count]; i++)
    {
        dispatch_async(queue, ^{
            NSData *imageData = [photoSmallImageData objectAtIndex:i];
            UIImageView *imageView =  [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
            [imageView setFrame:CGRectMake(((i+4)%4 + 1)*space + ((i+4)%4*flickrImageWidth), space * (floorf(i/4) + 1) + flickrImageWidth * floorf(i/4), flickrImageWidth, flickrImageWidth)];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [scrollView addSubview:imageView];
            });
        });
    }
}
                                                                                   

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    // Store incoming data into a string
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    debug(@"CALLING:%@", jsonString);  
    
    // Create a dictionary from the JSON string
	NSDictionary *results = [jsonString JSONValue];
	
    // Build an array from the dictionary for easy access to each entry
	NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    
    // Loop through each entry in the dictionary...
	for (NSDictionary *photo in photos)
    {
        // Get title of the image
		NSString *title = [photo objectForKey:@"title"];
        
        // Save the title to the photo titles array
		[photoTitles addObject:(title.length > 0 ? title : @"Untitled")];
		
        // Build the URL to where the image is stored (see the Flickr API)
        // In the format http://farmX.static.flickr.com/server/id/secret
        // Notice the "_s" which requests a "small" image 75 x 75 pixels
		NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        
        // The performance (scrolling) of the table will be much better if we
        // build an array of the image data here, and then add this data as
        // the cell.image value (see cellForRowAtIndexPath:)
		[photoSmallImageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
        
        // Build and save the URL to the large image so we can zoom
        // in on the image if requested
		photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
		[photoURLsLargeImage addObject:[NSURL URLWithString:photoURLString]];        
	}
    
    // Update the table with data
    [self loadScrollView];
    
    // Stop the activity indicator
    [activityIndicator stopAnimating];
    
	[jsonString release];  
}

/**************************************************************************
 *
 * Class implementation section
 *
 **************************************************************************/

#pragma mark -
#pragma mark Initialization

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (id)init
{
    // Create activity indicator
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(220, 110, 15, 15)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                              UIViewAutoresizingFlexibleRightMargin |
                                              UIViewAutoresizingFlexibleTopMargin |
                                              UIViewAutoresizingFlexibleBottomMargin);
    [activityIndicator sizeToFit];
    activityIndicator.hidesWhenStopped = YES; 
    [self.view addSubview:activityIndicator];
        
    // Initialize our arrays
    photoTitles = [[NSMutableArray alloc] init];
    photoSmallImageData = [[NSMutableArray alloc] init];
    photoURLsLargeImage = [[NSMutableArray alloc] init];
        
	return self;
    
}

#pragma mark -
#pragma mark View Mgmt

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)viewDidLoad 
{
	[super viewDidLoad];
    self.navigationItem.title = @"Flickr";
    
    queue = dispatch_queue_create("Flickr.Loader", nil);
    dispatch_queue_t lowPriority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_set_target_queue(queue, lowPriority);
    
    [photoTitles removeAllObjects];
    [photoSmallImageData removeAllObjects];
    [photoURLsLargeImage removeAllObjects];
    [activityIndicator startAnimating];
    
    // Build the string to call the Flickr API
	NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&user_id=62773263@N00&per_page=32&format=json&nojsoncallback=1", FlickrAPIKey, [TEDxAlcatrazGlobal eventName]];
    
    // Create NSURL string from formatted string, by calling the Flickr API
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
    debug(@"%@", url);  
    
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection release];
    [request release];
}

#pragma mark -
#pragma mark Cleanup

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)dealloc 
{
    [scrollView release];
	[photoTitles release];
	[photoSmallImageData release];
    [photoURLsLargeImage release];
    [activityIndicator release];
    
    // Remove from view (and release)
    if ([fullImageViewController superview])
        [fullImageViewController removeFromSuperview];
    dispatch_release(queue);

	[super dealloc];
}

@end
