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
#import "FusionTableReader.h"

@implementation EventLogic

+ (NSInteger)getEventVersion : (NSInteger)eventId
{
    NSDictionary *fusiontablecalls = [TEDxAlcatrazGlobal fusionTableDictionary];
                                    
    NSString *fusionquery = [NSString stringWithFormat:[fusiontablecalls objectForKey:@"GetEventVersion"], eventId];
    NSString *fusionquerycallback = [fusiontablecalls objectForKey:@"GetEventVersionCallBack"];    
	
    NSData *data = [FusionTableReader getSearchResultsByUrl:fusionquery type:fusionquerycallback];     

    NSArray *responseDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSUInteger ret = 0;
	if (responseDictionary != nil) {
		ret = [[[responseDictionary objectAtIndex:0] objectForKey:@"EventVersion"] intValue];
	}

	return ret;
}

+ (NSArray *)getEventSessionsFromWebService
{
	NSString *Action = WEBSERVICE_GETEVENTSESSIONBYEVENTID;
	
	NSDictionary *JSONData = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithInteger:[TEDxAlcatrazGlobal eventIdentifier]],		@"EventId",						  
							  nil];
	
	NSDictionary *responseDictionary = [WebServices CallWebServicePOST:JSONData webService:Action];
	
	NSArray *ret = [[NSArray alloc] autorelease];
	
	if ([(NSNumber *)[responseDictionary objectForKey:@"IsSuccessful"] boolValue]) {
		ret = [responseDictionary objectForKey:@"Sessions"];
		[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:ret] forKey:EVENT_SESSION_DATA];
	}
	
	DLog(@"EventSession:%@", ret);

	return ret;
}

+ (NSArray *)getEventSessionsFromCache
{
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:EVENT_SESSION_DATA];
	NSArray *returnString = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	DLog(@"EventSession:%@", returnString);
	
	return returnString;
}


+ (NSArray *)getSpeakersByEventWebService:(NSInteger)eventId Version:(NSInteger)version
{ 
    
    NSDictionary *fusiontablecalls = [TEDxAlcatrazGlobal fusionTableDictionary];
    
    NSString *fusionquery = [NSString stringWithFormat:[fusiontablecalls objectForKey:@"GetEventSpeakers"], eventId];
    NSString *fusionquerycallback = [fusiontablecalls objectForKey:@"GetEventSpeakersCallBack"];    
	
    NSData *data = [FusionTableReader getSearchResultsByUrl:fusionquery type:fusionquerycallback];     
    
    NSArray *responseDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:responseDictionary] forKey:EVENT_SPEAKER_DATA];
	[[NSUserDefaults standardUserDefaults] setInteger:version forKey:EVENT_VERSION];
    
    DLog(@"Speakers:%@", responseDictionary);
    
	return responseDictionary;
}

+ (NSArray *)getSpeakersByEventFromCache
{
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:EVENT_SPEAKER_DATA];
	NSArray *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
	DLog(@"Speakers:%@", returnData);
	
	return returnData;
}

#pragma mark subEvent -- The reason why I am not reusing the method here is because subEvent isn't being used in majority of the cases
#pragma mark subEvent -- This might be changed

+ (NSArray *)getSubEventSessionsFromWebService
{
	NSString *Action = WEBSERVICE_GETEVENTSESSIONBYEVENTID;
	
	NSDictionary *JSONData = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithInteger:[TEDxAlcatrazGlobal subEventIdentifier]],		@"EventId",						  
							  nil];
	
	NSDictionary *responseDictionary = [WebServices CallWebServicePOST:JSONData webService:Action];
	
	NSArray *ret = [[NSArray alloc] autorelease];
	
	if ([(NSNumber *)[responseDictionary objectForKey:@"IsSuccessful"] boolValue]) {
		ret = [responseDictionary objectForKey:@"Sessions"];
		[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:ret] forKey:SUB_EVENT_SESSION_DATA];
	}
	
	DLog(@"EventSession:%@", ret);
	
	return ret;
	
}

+ (NSArray *)getSubEventSessionsFromCache
{
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SUB_EVENT_SESSION_DATA];
	NSArray *returnString = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	DLog(@"EventSession:%@", returnString);
	
	return returnString;
}

+ (NSArray *)getSpeakersBySubEventWebService : (NSString *)requestString EventVersion : (NSInteger)version
{
	NSData *returnData = [WebServices CallWebServiceGETArray:requestString];
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:returnData] forKey:SUB_EVENT_SPEAKER_DATA];
	[[NSUserDefaults standardUserDefaults] setInteger:version forKey:SUB_EVENT_VERSION];
	
	
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	
	DLog(@"Speakers:%@", returnString);
	
	return [returnString JSONValue];
}

+ (NSArray *)getSpeakersBySubEventFromCache
{
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SUB_EVENT_SPEAKER_DATA];
	NSData *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	
	DLog(@"Speakers:%@", returnString);
	
	return [returnString JSONValue];
}



+(int)dateDiff:(NSDate*)firstday lastday:(NSDate*)lastday {
	NSDate *startDate = firstday;
	NSDate *endDate = lastday;
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	int days = [components day];
	return days;
}


+ (NSInteger)getCurrentSession:(NSArray *)sessions
{
	NSDate *currentTime = [NSDate date];
	
	NSInteger ret = 1;
	
	for(int i = 0; i<[sessions count]; i++)
	{
		if ([currentTime compare:[TEDxAlcatrazGlobal sessionTimeFromJSONData:[sessions objectAtIndex:i]]] > 0) {
			ret = [TEDxAlcatrazGlobal sessionFromJSONData:[sessions objectAtIndex:i]];
		}
	}
	
	return ret;
}

+ (NSString *)getSessionNameBySessionId:(NSInteger)session data:(NSArray *)sessions
{
	NSMutableString *ret = [NSMutableString stringWithFormat:@"Session %d", session];
	
	if(sessions != nil)
	{
		for (int i = 0; i < [sessions count]; i++) {
			if (session == [TEDxAlcatrazGlobal sessionFromJSONData:[sessions objectAtIndex:i]]) {
				[ret appendString: @": "];
				[ret appendString: [TEDxAlcatrazGlobal sessionNameFromJSONData:[sessions objectAtIndex:i]]];
			}
		}
	}
	
	return [NSString stringWithFormat:@"%@",ret];
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
