//
//  Conference.h
//  TEDxAlcatraz
//
//  Created by Peter Ma on 2/13/11.
//  Copyright 2011 Catch.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventLogic : NSObject

#pragma mark main Event
+ (NSUInteger)getEventVersion : (NSInteger)eventId;

+ (NSArray *)getEventSessionsFromWebService;

+ (NSArray *)getEventSessionsFromCache;

+ (NSArray *)getSpeakersByEventFromCache;
#pragma mark main SubEvent
+ (NSArray *)getSubEventSessionsFromWebService;

+ (NSArray *)getSubEventSessionsFromCache;

+ (NSArray *)getSpeakersBySubEventWebService : (NSString *)requestString EventVersion : (NSInteger)version;

+ (NSArray *)getSpeakersBySubEventFromCache;
#pragma mark shared
+ (NSInteger)getCurrentSession:(NSArray *)sessions;

+ (NSString *)getSessionNameBySessionId:(NSInteger)session data:(NSArray *)sessions;

+ (NSArray *)getSpeakersByEventWebService : (NSString *)requestString EventVersion : (NSInteger)version;

+ (NSInteger)getRowsBySectionNumber : (NSArray *)data section : (NSInteger)Section;

+ (NSArray *)getSpeakersBySection : (NSArray *)data section : (NSInteger)Section;

+(int)dateDiff:(NSDate*)firstday lastday:(NSDate*)lastday;

@end
