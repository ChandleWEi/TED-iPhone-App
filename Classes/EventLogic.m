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

+ (NSArray *)getSpeakersByEventFromCache
{
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:EVENT_SPEAKER_DATA];
	NSData *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];

	DLog(@"Speakers:%@", returnString);
	
	return [returnString JSONValue];
}
@end
