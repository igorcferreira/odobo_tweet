//
//  TWTRGeoTweet.h
//  LocalTwitter
//
//  Created by Igor Ferreira on 4/19/15.
//  Copyright (c) 2015 Igor Ferreira. All rights reserved.
//

#import <TwitterKit/TwitterKit.h>

@class CLLocation;

@interface TWTRGeoTweet : TWTRTweet

@property (nonatomic, strong) CLLocation *location;

-(instancetype)initGeoTweetWithTweet:(TWTRTweet*)tweet andLocation:(CLLocation*)location;

@end
