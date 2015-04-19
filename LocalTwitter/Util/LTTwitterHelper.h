//
//  LTTwitterHelper.h
//  LocalTwitter
//
//  Created by Igor Ferreira on 4/19/15.
//  Copyright (c) 2015 Igor Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface LTTwitterHelper : NSObject

+(void)start;
+(instancetype)sharedInstance;
-(void)fetchTweetsOnLocation:(CLLocation*)location
                    complete:(void(^)(NSArray* tweets))completeBlock
                       error:(void(^)(NSError* error))errorBlock;

@end
