//
//  Conference.h
//  TEDxAlcatraz
//
//  Created by Peter Ma on 2/13/11.
//  Copyright 2011 Catch.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventLogic : NSObject

+ (NSUInteger)getEventVersion;

+ (NSArray *)getEventSessionsFromWebService;

+ (NSArray *)getEventSessionsFromCache;

+(int)dateDiff:(NSDate*)firstday lastday:(NSDate*)lastday;

+ (NSInteger)getCurrentSession:(NSArray *)sessions;

+ (NSString *)getSessionNameBySessionId:(NSInteger)session data:(NSArray *)sessions;

+ (NSArray *)getSpeakersByEventWebService : (NSString *)requestString EventVersion : (NSInteger)version;

+ (NSArray *)getSpeakersByEventFromCacheSortByLastName;

+ (NSArray *)getSpeakersByEventFromCacheSortBySession : (NSArray *)data;

+ (NSInteger)getRowsBySectionNumber : (NSArray *)data section : (NSInteger)Section;

+ (NSArray *)getSpeakersBySection : (NSArray *)data section : (NSInteger)Section;
@end
