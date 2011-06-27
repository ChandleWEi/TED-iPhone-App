/*Copyright 2011 Catch.com
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.*/
//
//  SubEventSpeakersResultController.m
//  TEDxAlcatraz
//
//  Created by Nyceane on 2/17/11.
//  Copyright 2011 Catch.com. All rights reserved.
//

#import "SubEventSpeakersResultController.h"
#import "TEDxAlcatrazAppDelegate.h"
#import "SpeakersResultTableViewCell.h"
#import "SpeakerDetailController.h"
#import "JSON.h"
#import "TEDxAlcatrazGlobal.h"
#import "EventLogic.h"

#define kPages		1
#define kSessions	3
#define SectionHeaderHeight 15

@implementation SubEventSpeakersResultController

@synthesize switchFilter;

#pragma mark -

#define kImageFileNameFormat @"%d.dat"
#define kImageCacheDirectoryName @"imagecache"

-(void)createTempPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *tempPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:kImageCacheDirectoryName]];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:tempPath] == NO) {
		NSError *error;
		BOOL createdDir = [[NSFileManager defaultManager] createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:&error];
		
		NSLog(@"Created Directory: %@ (Success:%d)", tempPath, createdDir);
	}
}

-(NSString*)tempPathForSpeakerImage:(NSDictionary*)speaker {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *tempPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:kImageCacheDirectoryName]];
	
	tempPath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:kImageFileNameFormat, [TEDxAlcatrazGlobal speakerIdFromJSONData:speaker]]];
	
	return tempPath;
}

-(UIImage*)imageForSpeaker:(NSDictionary*)speaker {
	NSString* path = [self tempPathForSpeakerImage:speaker];
	UIImage *image = nil;
	
	if([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {		
		image = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
		
		DLog(@"Found image for speaker:Path:%@ (Image:%@)", path, image);
	}
	
	return image;
}

-(NSDictionary*)getSpeakerByIndexPath:(NSIndexPath*)indexPath
{
	NSDictionary *speaker;
	switch (switchFilter.selectedSegmentIndex) {
		case 1:
			speaker = [[EventLogic getSpeakersBySection:speakers section:indexPath.section] objectAtIndex:[indexPath row]];
			break;
		default:
			speaker = [speakers objectAtIndex:[indexPath row]];
			break;
	}
	return speaker;
}

-(void)setImage:(UIImage*)image forSpeaker:(NSDictionary*)speaker {
	NSString* path = [self tempPathForSpeakerImage:speaker];
	
	BOOL success = [[NSFileManager defaultManager] createFileAtPath:path 
														   contents:UIImagePNGRepresentation(image)
														 attributes:nil];
	
	DLog(@"Set Image:Path:%@ Success:%d", path, success);
}

#pragma mark -
#pragma mark getting data

-(void)getSpeakersInBackground {	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[speakers release];
	
	
	NSInteger eventVersion = [EventLogic getEventVersion:[TEDxAlcatrazGlobal subEventIdentifier]];

	if([TEDxAlcatrazGlobal eventVersion] == eventVersion || eventVersion == 0)
	{
		speakers = [[EventLogic getSpeakersByEventFromCache:[TEDxAlcatrazGlobal subEventIdentifier]] retain];
		sessions = [[EventLogic getEventSessionsFromCache:[TEDxAlcatrazGlobal subEventIdentifier]] retain];
	}
	else {
        speakers = [[EventLogic getSpeakersByEventWebService:[TEDxAlcatrazGlobal subEventIdentifier] Version:eventVersion] retain];
		sessions = [[EventLogic getEventSessionsFromWebService:[TEDxAlcatrazGlobal subEventIdentifier]] retain];
	}
	
	[[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [pool drain];

}

// this is a stop-gap solution as we really need to be caching these images, not downloading them each time
-(void)getImageInBackgroundForIndexPath:(NSIndexPath*)indexPath {
	if(speakers) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSDictionary *speaker = [self getSpeakerByIndexPath:indexPath];
		
		[self createTempPath];
		
		UIImage* image = [self imageForSpeaker:speaker];
		
		if(image == nil) {
			DLog(@"Getting data for %@ (speaker:%d)", indexPath, [TEDxAlcatrazGlobal speakerIdFromJSONData:speaker]);		
			
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];		
			
			NSData *receivedData =  [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[TEDxAlcatrazGlobal photoURLFromJSONData:speaker]]];
			
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			
			image = [[[UIImage alloc] initWithData:receivedData] autorelease];
			
			[receivedData release];
			
			[self setImage:image forSpeaker:speaker];
		}
		
		UITableViewCell *cell = nil;
		@try {
			cell = [[self tableView] cellForRowAtIndexPath:indexPath];
		}
		@catch (NSException * e) {
			cell = nil;
		}
		
		if(cell) {
			DLog(@"Setting Image (%@) for Cell with IndexPath:%@", [cell imageView], indexPath);
			
			[[cell imageView] performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
			[[cell imageView] setFrame:CGRectMake(0, 0, 70, 70)];
			[cell setNeedsLayout];
			
			DLog(@"Set image:%@", [cell imageView]);
		}
		
		[pool drain];
	}
}

#pragma mark -
#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if(switchFilter.selectedSegmentIndex != 0)
	{
		return SectionHeaderHeight;
	}
	else {
		return 0;
	}
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	switch (switchFilter.selectedSegmentIndex) {
		case 1:
			return kSessions;
		default:
			return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (switchFilter.selectedSegmentIndex) {
		case 0:
			return [speakers count];
		case 1:
			return [EventLogic getRowsBySectionNumber:speakers section:section];
		default:
			return 1;
	}
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if(switchFilter.selectedSegmentIndex != 0)
	{
		NSString *sectionTitle = [EventLogic getSessionNameBySessionId:section + 1 data:sessions];
		// Create label with section title
		UILabel *label = [[[UILabel alloc] init] autorelease];
		label.frame = CGRectMake(0, 0, 320, 15);
		label.backgroundColor = [UIColor grayColor];
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:12];
		label.text = sectionTitle;
		
		// Create header view and add label as a subview
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SectionHeaderHeight)];
		[view autorelease];
		[view addSubview:label];
		
		return view;
	}
	else return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TEDxSpeakerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SpeakersResultTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *speaker = [self getSpeakerByIndexPath:indexPath];
	
	// Configure the cell...
	
	UIImage* image = [self imageForSpeaker:speaker];
	cell.imageView.image = image;	
	
	cell.textLabel.text = [TEDxAlcatrazGlobal nameStringFromJSONData:speaker];		// speakers name
	cell.detailTextLabel.text = [TEDxAlcatrazGlobal titleFromJSONData:speaker];		// speakers profession
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	if(image == nil) {
		[self performSelectorInBackground:@selector(getImageInBackgroundForIndexPath:) withObject:indexPath];
	}
	
    return cell;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"TEDU Speakers";
	
	self.tableView.rowHeight = kSpeakersTableRowHeight;
	
	[self performSelectorInBackground:@selector(getSpeakersInBackground) withObject:nil];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *speaker = [self getSpeakerByIndexPath:indexPath];
	
	if(speaker) {
		SpeakerDetailController *speakerDetailController = [[SpeakerDetailController alloc] initWithSpeaker:speaker];
		[self.navigationController pushViewController:speakerDetailController animated:YES];
		[speakerDetailController release];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)switchFilter_Clicked
{
	[self.tableView reloadData];
}

- (IBAction)btnCurrent_Clicked
{
	switchFilter.selectedSegmentIndex = 1;
	[self.tableView reloadData];
	
	NSInteger currentSection = [EventLogic getCurrentSession:sessions] - 1;
	
	NSIndexPath *current = [NSIndexPath indexPathForRow:0 inSection:currentSection];
	[self.tableView scrollToRowAtIndexPath:current 
						  atScrollPosition:UITableViewScrollPositionTop
								  animated:YES];
}
#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	
	[speakers release], speakers = nil;
	[sessions release], sessions = nil;
	self.switchFilter = nil;
}


- (void)dealloc {
	[speakers release];
	[sessions release];
	[switchFilter release];
    [super dealloc];
}


@end

