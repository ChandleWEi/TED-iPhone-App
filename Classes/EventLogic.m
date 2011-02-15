//
//  Conference.m
//  TEDxAlcatraz
//
//  Created by Peter Ma on 2/13/11.
//  Copyright 2011 Catch.com. All rights reserved.
//

#import "EventLogic.h"
#import "TEDxAlcatrazGlobal.h"
#import "WebServices.h"
#import "JSON.h"

@implementation EventLogic

+ (NSUInteger)getEventVersion
{
	NSString *Action = WEBSERVICE_GETCONFERENCEVERSION;
	
	NSDictionary *JSONData = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithInteger:[TEDxAlcatrazGlobal eventIdentifier]],		@"EventId",						  
							  nil];
	
	NSDictionary *responseDictionary = [WebServices CallWebServicePOST:JSONData webService:Action];
	
	NSInteger ret = 0;
	
	if ([(NSNumber *)[responseDictionary objectForKey:@"IsSuccessful"] boolValue]) {
		ret = [[responseDictionary objectForKey:@"EventVersion"] intValue];
	}
	
	return ret;
}

+ (NSArray *)getSpeakersByEventWebService : (NSString *)requestString EventVersion : (NSInteger)version
{
	NSData *returnData = [WebServices CallWebServiceGETArray:requestString];
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:returnData] forKey:EVENT_SPEAKER_DATA];
	[[NSUserDefaults standardUserDefaults] setInteger:version forKey:EVENT_VERSION];

	
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	
	DLog(@"Speakers:%@", returnString);
	
	return [returnString JSONValue];
}

+ (NSArray *)getSpeakersByEventFromCacheSortByLastName
{
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:EVENT_SPEAKER_DATA];
	NSData *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];

	DLog(@"Speakers:%@", returnString);
	
	return [returnString JSONValue];
}

+ (NSArray *)getSpeakersByEventFromCacheSortBySession : (NSArray *)data
{
	return nil;
}

+ (NSInteger)getRowsBySectionNumber : (NSArray *)data section : (NSInteger)Section
{
	NSInteger count = 0;
	for (int i = 0; i < [data count]; i++) {
		if ([TEDxAlcatrazGlobal sessionFromJSONData:[data objectAtIndex:i]] == Section + 1) {
			count++;
		}
	}
	return count;
}

+ (NSArray *)getSpeakersBySection : (NSArray *)data section : (NSInteger)Section
{
	NSMutableArray *returnData = [NSMutableArray arrayWithArray:data];
	for (int i = 0; i < [returnData count]; i++) {
		if ([TEDxAlcatrazGlobal sessionFromJSONData:[returnData objectAtIndex:i]] != Section + 1) {			
			[returnData removeObjectAtIndex:i];
			i--;
		}
	}

	return (NSArray *)returnData;
}
@end
