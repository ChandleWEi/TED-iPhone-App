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
//  WebServices.m
//  TED App
//
//  Created by Peter Ma on 2/13/11.
//  Copyright 2011 Catch.com. All rights reserved.
//

#import "WebServices.h"
#import "TEDxAlcatrazGlobal.h"
#import "JSON.h"

@implementation WebServices

+ (NSDictionary *)CallWebServicePOST:(NSDictionary *)JSONData
						  webService:(NSString *)webService
{
	NSMutableString *url = [NSMutableString string];
	[url appendString: WEBSERVICE_ADDRESS];
	[url appendString: webService];
	
	NSString *JSONDataString = [JSONData JSONRepresentation];
	NSData *requestData = [NSData dataWithBytes:[JSONDataString UTF8String] length:[JSONDataString length]];	
	NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSString *postLength = [NSString stringWithFormat:@"%d", [requestData length]];
	[URLRequest setHTTPMethod:@"POST"];
	[URLRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[URLRequest setHTTPBody:requestData];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	//Data returned by Web Service
	NSData *returnData = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:nil error:nil];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	DLog(@"WebService:%@", returnString);
	NSDictionary *responseDictionary = [returnString JSONValue];
	return responseDictionary;
}

+ (NSData *)CallWebServiceGETArray:(NSString *)requestString
{	
	NSURLRequest *URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
	
	//Data returned by Web Service
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:nil error:nil];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	return returnData;
}

@end
