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

+(NSString*)nameStringFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"FirstName"] isKindOfClass:[NSString class]], @"FirstName is not a string");
	DAssert([[JSONDictionary objectForKey:@"LastName"] isKindOfClass:[NSString class]], @"LastName Id is not a string");
	
	//get the speaker name
	return [NSString stringWithFormat:
					  @"%@ %@",
					  [JSONDictionary objectForKey:@"FirstName"],
					  [JSONDictionary objectForKey:@"LastName"]];	
}

+ (NSDate*) getDateFromJSON:(NSString *)dateString
{
    // Expect date in this format "/Date(1268123281843)/"
    int startPos = [dateString rangeOfString:@"("].location+1;
    int endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

+(NSString*)titleFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"Title"] isKindOfClass:[NSString class]], @"Title is not a string");
	
	return [JSONDictionary objectForKey:@"Title"];	
}

+(NSString*)photoURLFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"PhotoUrl"] isKindOfClass:[NSString class]], @"PhotoURL is not a string");
	
	return [JSONDictionary objectForKey:@"PhotoUrl"];	
}

+(NSString*)descriptionFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"Description"] isKindOfClass:[NSString class]], @"Description is not a string");
	
	return [JSONDictionary objectForKey:@"Description"];	
}

+(NSString*)webSiteFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"WebSite"] isKindOfClass:[NSString class]], @"Description is not a string");
	
	return [JSONDictionary objectForKey:@"WebSite"];	
}

+(NSString*)twitterFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"Twitter"] isKindOfClass:[NSString class]], @"Description is not a string");
	
	return [JSONDictionary objectForKey:@"Twitter"];	
}

+(NSInteger)speakerIdFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"SpeakerId"] isKindOfClass:[NSNumber class]], @"Speaker Id is not a number");
	
	return [[JSONDictionary objectForKey:@"SpeakerId"] intValue];
}

+(NSInteger)sessionFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"Session"] isKindOfClass:[NSNumber class]], @"Session is not a number");
	
	return [[JSONDictionary objectForKey:@"Session"] intValue];
}

+(NSString *)sessionNameFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[JSONDictionary objectForKey:@"SessionName"] isKindOfClass:[NSString class]], @"SessionName is not a string");
	
	return [JSONDictionary objectForKey:@"SessionName"];
}

+(NSDate *)sessionTimeFromJSONData:(NSDictionary*)JSONDictionary {
	DAssert([[self getDateFromJSON:[JSONDictionary objectForKey:@"SessionTime"]] isKindOfClass:[NSDate class]], @"SessionTime is not a date");
	
	return [self getDateFromJSON:[JSONDictionary objectForKey:@"SessionTime"]];
}

#pragma mark -

+(NSDictionary*)venueDictionary {
	NSDictionary *TEDxVenue = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TEDVenue"];
	
	DAssert(TEDxVenue != nil, @"the venue dictionary is missing from the Info.plist");
	
	return TEDxVenue;
}

+(NSUInteger)eventIdentifier {
	NSDictionary* TEDxVenueDetails = [TEDxAlcatrazGlobal venueDictionary];
	NSNumber *eventIdNumber = [TEDxVenueDetails objectForKey:@"EventId"];
	
	DAssert(eventIdNumber != nil, @"The event id is nil");
	
	return [eventIdNumber integerValue];
}

+(NSString*)emailAddress {
	NSDictionary* TEDxVenueDetails = [TEDxAlcatrazGlobal venueDictionary];
	NSString *emailAddress = [TEDxVenueDetails objectForKey:@"EmailAddress"];
	
	DAssert(emailAddress != nil, @"The email address is nil");
	
	return emailAddress;
}

+(NSInteger)eventVersion {
	return [[NSUserDefaults standardUserDefaults] integerForKey:EVENT_VERSION];
}

@end

