//
//  FlickrViewController.m
//  TEDxAlcatraz
//
//  Created by Peter Ma on 8/9/11.
//  Copyright (c) 2011 Catch.com. All rights reserved.
//

#import "FlickrViewController.h"
#import "JSON.h"
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

- (IBAction)loadLargeImage:(id)sender{
    
    //UIButton* btn = (UIButton *) sender;
    
    networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    [self.navigationController pushViewController:networkGallery animated:YES];
    [networkGallery release];        
    
    /*
    NSInteger eventId = btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(loadEventDetail:)]) {
        [self.delegate loadEventDetail:eventId];
	}*/
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    // Store incoming data into a string
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //debug(@"CALLING:%@", jsonString);  
    
    // Create a dictionary from the JSON string
	NSDictionary *results = [jsonString JSONValue];
	
    // Build an array from the dictionary for easy access to each entry
	NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    
    [scrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, ceilf([photos count]/4 + 3)*60)];

    // Loop through each entry in the dictionary...
	//for (NSDictionary *photo in photos)
    for(int i = 0; i < [photos count]; i++)
    {
        NSDictionary *photo = [photos objectAtIndex:i];
        // Get title of the image
		NSString *title = [photo objectForKey:@"title"];
        
        // Save the title to the photo titles array
		[networkCaptions addObject:(title.length > 0 ? title : @"Untitled")];
		

        // The performance (scrolling) of the table will be much better if we
        // build an array of the image data here, and then add this data as
        // the cell.image value (see cellForRowAtIndexPath:)
		//[photoSmallImageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
        
        dispatch_async(queue, ^{
            // Build the URL to where the image is stored (see the Flickr API)
            // In the format http://farmX.static.flickr.com/server/id/secret
            // Notice the "_s" which requests a "small" image 75 x 75 pixels
            NSString *photoURLString = [[NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]] autorelease];
            [thumbImages addObject:photoURLString];
            
            
            // Build and save the URL to the large image so we can zoom
            // in on the image if requested
            NSString *largeUrl = [[NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]] autorelease];
            [networkImages addObject:largeUrl];
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]];
            
            UIImageView *imageView =  [[[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]] autorelease];
            [imageView setFrame:CGRectMake(0, 0, flickrImageWidth, flickrImageWidth)];
            
            UIButton *imageButton = [[[UIButton alloc] initWithFrame:CGRectMake(((i+4)%4 + 1)*space + ((i+4)%4*flickrImageWidth), space * (floorf(i/4) + 1) + flickrImageWidth * floorf(i/4), flickrImageWidth, flickrImageWidth)] autorelease];
            [imageButton addSubview:imageView];
            [imageButton addTarget:self action:@selector(loadLargeImage:) forControlEvents:UIControlEventTouchUpInside];

            dispatch_sync(dispatch_get_main_queue(), ^{
                [scrollView addSubview:imageButton];
            });
        });
	}
    
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
    thumbImages = [[NSMutableArray alloc] init];
    networkImages = [[NSMutableArray alloc] init];
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


#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
	return [networkImages count];
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    caption = [networkCaptions objectAtIndex:index];
	return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    if(size == FGalleryPhotoSizeThumbnail)
    {
        return [thumbImages objectAtIndex:index];
    }
    else
    {
        return [networkImages objectAtIndex:index];
    }
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
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
    [networkCaptions release];
    [thumbImages release];
    [networkImages release];
    [activityIndicator release];
    
    dispatch_release(queue);

	[super dealloc];
}

@end
