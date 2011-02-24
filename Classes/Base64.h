//
//  Base64.h
//  TEDxAlcatraz
//
//  Created by Nyceane on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Base64 : NSObject {

}

+ (NSString *)encodeBase64WithString:(NSString *)strData;

+ (NSString *)encodeBase64WithData:(NSData *)objData;

+ (NSData *)decodeBase64WithString:(NSString *)strBase64;

@end
