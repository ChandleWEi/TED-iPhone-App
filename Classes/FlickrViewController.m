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
#define debug(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);

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

/**************************************************************************
 *
 * Private implementation section
 *
 **************************************************************************/

#pragma mark -
#pragma mark Private Methods

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
    [theTableView reloadData];
    
    // Stop the activity indicator
    [activityIndicator stopAnimating];
    
	[jsonString release];  
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)showZoomedImage:(NSIndexPath *)indexPath
{
    // Remove from view (and release)
    if ([fullImageViewController superview])
        [fullImageViewController removeFromSuperview];
    
    fullImageViewController = [[ZoomedImageView alloc] initWithURL:[photoURLsLargeImage objectAtIndex:indexPath.row]];
    
    [self.view addSubview:fullImageViewController];
    
    // Slide this view off screen
    CGRect frame = fullImageViewController.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.45];
    
    // Slide the image to its new location (onscreen)
    frame.origin.x = 0;
    fullImageViewController.frame = frame;
    
    [UIView commitAnimations];
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
    // Create table view
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 240, 320, 220)];
    [theTableView setDelegate:self];
    [theTableView setDataSource:self];
    [theTableView setRowHeight:80];
    [self.view addSubview:theTableView];
    [theTableView setBackgroundColor:[UIColor grayColor]];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
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
#pragma mark Table Mgmt

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [photoTitles count];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    // If we've created this VC before...
    if (fullImageViewController != nil)
    {
        // Slide this view off screen
        CGRect frame = fullImageViewController.frame;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.45];
        
        // Off screen location
        frame.origin.x = -320;
        fullImageViewController.frame = frame;
        
        [UIView commitAnimations];
        
    }
    
    [self performSelector:@selector(showZoomedImage:) withObject:indexPath afterDelay:0.1];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cachedCell"];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cachedCell"] autorelease];
    //    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"cachedCell"] autorelease];
    
#if __IPHONE_3_0
    cell.textLabel.text = [photoTitles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
#else
    cell.text = [photoTitles objectAtIndex:indexPath.row];
    cell.font = [UIFont systemFontOfSize:13.0];
#endif
	
	NSData *imageData = [photoSmallImageData objectAtIndex:indexPath.row];
    
#if __IPHONE_3_0
    cell.imageView.image = [UIImage imageWithData:imageData];
#else
	cell.image = [UIImage imageWithData:imageData];
#endif
	
	return cell;
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
    
    
    [photoTitles removeAllObjects];
    [photoSmallImageData removeAllObjects];
    [photoURLsLargeImage removeAllObjects];
    [activityIndicator startAnimating];
    
    // Build the string to call the Flickr API
	NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&user_id=62773263@N00&per_page=25&format=json&nojsoncallback=1", FlickrAPIKey, [TEDxAlcatrazGlobal eventName]];
    
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
    [theTableView release];
	[photoTitles release];
	[photoSmallImageData release];
    [photoURLsLargeImage release];
    [activityIndicator release];
    
    // Remove from view (and release)
    if ([fullImageViewController superview])
        [fullImageViewController removeFromSuperview];
    
	[super dealloc];
}

@end
