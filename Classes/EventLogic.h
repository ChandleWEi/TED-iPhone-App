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

+ (NSArray *)getSpeakersByEventWebService : (NSString *)requestString EventVersion : (NSInteger)version;

+ (NSArray *)getSpeakersByEventFromCache;

@end
