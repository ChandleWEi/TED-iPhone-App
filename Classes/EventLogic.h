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
+ (NSInteger)getEventVersion : (NSInteger)eventId;

+ (NSString *)getEventAbout : (NSInteger)eventId;

+ (NSArray *)getEventSessionsFromWebService:(NSInteger)eventId;

+ (NSArray *)getEventSessionsFromCache:(NSInteger)eventId;

+ (NSArray *)getSpeakersByEventFromCache:(NSInteger)eventId;

+ (NSArray *)getSpeakersByEventWebService:(NSInteger)eventId Version:(NSInteger)version;
#pragma mark shared
+ (NSInteger)getCurrentSession:(NSArray *)sessions;

+ (NSString *)getSessionNameBySessionId:(NSInteger)session data:(NSArray *)sessions;

+ (NSInteger)getRowsBySectionNumber : (NSArray *)data section : (NSInteger)Section;

+ (NSArray *)getSpeakersBySection : (NSArray *)data section : (NSInteger)Section;

+(int)dateDiff:(NSDate*)firstday lastday:(NSDate*)lastday;

@end
