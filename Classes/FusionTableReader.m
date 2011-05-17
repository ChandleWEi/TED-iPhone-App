/**
 Copyright 2011 Catch.com, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License
 */

#import "FusionTableReader.h"
#import "JSON.h"

@implementation FusionTableReader

/**
 * This function is meant for Array of objects from the query
 * @param Url
 * @param type
 * @return
 */
+ (NSData *) getSearchResultsByUrl:(NSString *)requestString type:(NSString *)type
{
	NSURLRequest *URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", requestString, type]]];
	
	//Data returned by Web Service
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSData *unstructuredData = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:nil error:nil];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString *fusionstring = [[[NSString alloc] initWithData:unstructuredData encoding:NSUTF8StringEncoding] autorelease];
                                      
    NSDictionary *fusionret = [[[[fusionstring substringToIndex: [fusionstring length] - 2] substringFromIndex:[type length] + 1] autorelease] JSONValue];
    
    NSDictionary *table = [[fusionret valueForKey:@"table"] autorelease];
        
    NSArray *cols = [[table valueForKey:@"cols"] autorelease];
    
    NSArray *rows = [[table valueForKey:@"rows"] autorelease];
    
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];

    for(int i = 0; i < [rows count]; i++)
    {
        [array addObject:[self AddObject:cols Rows:[rows objectAtIndex:i]]];
    }
        
    NSData *ret = [NSKeyedArchiver archivedDataWithRootObject:array];
	return ret;
}

+ (NSDictionary *) AddObject:(NSArray *)cols Rows:(NSArray *)rows
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [cols count]; i++)
    {
        [ret setObject:[rows objectAtIndex:i] forKey:[cols objectAtIndex:i]];
    }
    
    return [[NSDictionary alloc] initWithDictionary:ret];
}

@end
