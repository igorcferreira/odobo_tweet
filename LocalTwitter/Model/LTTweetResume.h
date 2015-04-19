//
//  LTTweetResume.h
//  LocalTwitter
//
//  Created by Igor Ferreira on 4/19/15.
//  Copyright (c) 2015 Igor Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface LTTweetResume : NSObject

@property (nonatomic, readonly, strong) NSNumber*   tweetId;
@property (nonatomic, readonly, strong) CLLocation* location;
@property (nonatomic, readonly, strong) NSString*   text;
@property (nonatomic, readonly, strong) NSString*   userName;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
