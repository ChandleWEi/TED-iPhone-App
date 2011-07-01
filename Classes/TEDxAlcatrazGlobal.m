/*
 The MIT License
 
 Copyright (c) 2010 Peter Ma
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
/*
 *  TEDxAlcatrazGlobal.m
 *  TEDxAlcatraz
 *
 *  Created by Michael May on 03/01/2011.
 *  Copyright 2011 Michael May. All rights reserved.
 *
 */

#import "TEDxAlcatrazGlobal.h"

@implementation TEDxAlcatrazGlobal

#define kImageFileNameFormat @"%d.dat"
#define kImageCacheDirectoryName @"imagecache"

+(void)createTempPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *tempPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:kImageCacheDirectoryName]];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:tempPath] == NO) {
		NSError *error;
		BOOL createdDir = [[NSFileManager defaultManager] createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:&error];
		
		NSLog(@"Created Directory: %@ (Success:%d)", tempPath, createdDir);
	}
}

+(NSString*)descriptionFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"Description"] isKindOfClass:[NSString class]], @"Description is not a string");
	
	return [JSONDictionary objectForKey:@"Description"];	
}

+ (NSDate*) getDateFromJSON:(NSString *)dateString
{

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *ret = [df dateFromString: dateString];

    return ret;
}

+(UIImage*)imageForSpeaker:(NSDictionary*)speaker {
	NSString* path = [self tempPathForSpeakerImage:speaker];
	UIImage *image = nil;
	
	if([[NSFileManager defaultManager] fileExistsAtPath:path] == YES) {		
		image = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
		
		DLog(@"Found image for speaker:Path:%@ (Image:%@)", path, image);
	}
	
	return image;
}

+(NSString*)nameStringFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"FirstName"] isKindOfClass:[NSString class]], @"FirstName is not a string");
	DAssert([[JSONDictionary objectForKey:@"LastName"] isKindOfClass:[NSString class]], @"LastName Id is not a string");
	
	//get the speaker name
	return [NSString stringWithFormat:
            @"%@ %@",
            [JSONDictionary objectForKey:@"FirstName"],
            [JSONDictionary objectForKey:@"LastName"]];	
}

+(NSString*)photoURLFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"PhotoUrl"] isKindOfClass:[NSString class]], @"PhotoURL is not a string");
	
	return [JSONDictionary objectForKey:@"PhotoUrl"];	
}

+(NSInteger)sessionFromJSONData:(NSDictionary*)JSONDictionary {    
	return [[JSONDictionary objectForKey:@"Session"] intValue];
}

+(NSInteger)sessionIdFromJSONData:(NSDictionary*)JSONDictionary {
    return [[JSONDictionary objectForKey:@"SessionId"] intValue];
}

+(NSString *)sessionNameFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"SessionName"] isKindOfClass:[NSString class]], @"SessionName is not a string");
	
	return [JSONDictionary objectForKey:@"SessionName"];
}

+(NSDate *)sessionTimeFromJSONData:(NSDictionary*)JSONDictionary {	
    DAssert([[JSONDictionary objectForKey:@"SessionTime"] isKindOfClass:[NSString class]], @"SessionTime is not a string");

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *ret = [df dateFromString: [JSONDictionary objectForKey:@"SessionTime"]];
    
	return ret;
}


+(NSInteger)speakerIdFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"SpeakerId"] isKindOfClass:[NSNumber class]], @"SpeakerId is not a number");
	
	return [[JSONDictionary objectForKey:@"SpeakerId"] intValue];
}

+(NSString*)tempPathForSpeakerImage:(NSDictionary*)speaker {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *tempPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:kImageCacheDirectoryName]];
	
	tempPath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:kImageFileNameFormat, [TEDxAlcatrazGlobal speakerIdFromJSONData:speaker]]];
	
	return tempPath;
}

+(NSString*)titleFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"Title"] isKindOfClass:[NSString class]], @"Title is not a string");
	
	return [JSONDictionary objectForKey:@"Title"];	
}

+(NSString*)twitterFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"Twitter"] isKindOfClass:[NSString class]], @"Description is not a string");
	
	return [JSONDictionary objectForKey:@"Twitter"];	
}

+(NSString*)webSiteFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"Website"] isKindOfClass:[NSString class]], @"Description is not a string");
	
	return [JSONDictionary objectForKey:@"Website"];	
}


#pragma mark - Local InfoList items
+(NSString*)emailAddress {
	NSDictionary* TEDxVenueDetails = [TEDxAlcatrazGlobal venueDictionary];
	NSString *emailAddress = [TEDxVenueDetails objectForKey:@"EmailAddress"];
	
	DAssert(emailAddress != nil, @"The email address is nil");
	
	return emailAddress;
}

+(NSString*)eventHashTag {
    int rowid = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_EVENT_ROWID];
    
    NSArray *archivedArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Archive"];
    
    NSDictionary *row = [[NSDictionary alloc] initWithDictionary:[archivedArray objectAtIndex:rowid]];
    
    return [row valueForKey:@"EventHashTag"];
}

+(NSUInteger)eventIdentifier {
    
    int rowid = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_EVENT_ROWID];
    NSArray *archivedArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Archive"];
    
    NSDictionary *row = [[NSDictionary alloc] initWithDictionary:[archivedArray objectAtIndex:rowid]];
    
    return [[row valueForKey:@"EventId"] intValue];
}

+(NSString *)eventName{
    int rowid = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_EVENT_ROWID];
    
    NSArray *archivedArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Archive"];
    
    NSDictionary *row = [[NSDictionary alloc] initWithDictionary:[archivedArray objectAtIndex:rowid]];
    
    return [row valueForKey:@"TEDConference"];
}

+(NSInteger)eventVersion : (NSInteger)eventId{
	return [[NSUserDefaults standardUserDefaults] integerForKey: [NSString stringWithFormat:@"%@%d", EVENT_VERSION, eventId]];
}

+(NSString *)eventLocationAdddress{
    int rowid = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_EVENT_ROWID];
    
    NSArray *archivedArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Archive"];
    
    NSDictionary *row = [[NSDictionary alloc] initWithDictionary:[archivedArray objectAtIndex:rowid]];
    
    return [row valueForKey:@"Address"];
}

+(NSString *)eventLocationName{
    int rowid = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_EVENT_ROWID];
    
    NSArray *archivedArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Archive"];
    
    NSDictionary *row = [[NSDictionary alloc] initWithDictionary:[archivedArray objectAtIndex:rowid]];
    
    return [row valueForKey:@"Name"];
}

+(NSNumber *)eventLocationLatitude{
    int rowid = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_EVENT_ROWID];
    
    NSArray *archivedArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Archive"];
    
    NSDictionary *row = [[NSDictionary alloc] initWithDictionary:[archivedArray objectAtIndex:rowid]];
    
    return [row valueForKey:@"Latitude"];
}

+(NSNumber *)eventLocationLongitude{
    int rowid = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_EVENT_ROWID];
    
    NSArray *archivedArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Archive"];
    
    NSDictionary *row = [[NSDictionary alloc] initWithDictionary:[archivedArray objectAtIndex:rowid]];
    
    return [row valueForKey:@"Longitude"];
}

+(NSDictionary*)fusionTableDictionary{
	NSDictionary *FusionTableCalls = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FusionTableCalls"];
	
	DAssert(FusionTableCalls != nil, @"the fusion table is missing from the Info.plist");
	
	return FusionTableCalls;    
}


+(void)setEventIds:(int)RowId
{
    [[NSUserDefaults standardUserDefaults] setInteger:RowId forKey:CURRENT_EVENT_ROWID];
}

+(NSUInteger)subEventIdentifier{

    int rowid = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_EVENT_ROWID];
    NSArray *archivedArray = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Archive"];
        
    NSDictionary *row = [[NSDictionary alloc] initWithDictionary:[archivedArray objectAtIndex:rowid]];
        
    return [[row valueForKey:@"SubEventId"] intValue];
}

+(NSDictionary*)venueDictionary {
	NSDictionary *TEDxVenue = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TEDVenue"];
	
	DAssert(TEDxVenue != nil, @"the venue dictionary is missing from the Info.plist");
	
	return TEDxVenue;
}

@end

