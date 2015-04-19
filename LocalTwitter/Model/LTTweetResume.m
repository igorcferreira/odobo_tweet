//
//  LTTweetResume.m
//  LocalTwitter
//
//  Created by Igor Ferreira on 4/19/15.
//  Copyright (c) 2015 Igor Ferreira. All rights reserved.
//

#import "LTTweetResume.h"
#import <CoreLocation/CoreLocation.h>

@implementation LTTweetResume

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if(self) {
        
        _tweetId = dictionary[@"id"];
        
        id temp = dictionary[@"geo"];
        if(temp && [temp isKindOfClass:[NSDictionary class]]) {
            temp = temp[@"coordinates"];
            if(temp && [temp isKindOfClass:[NSArray class]]) {
                _location = [[CLLocation alloc] initWithLatitude:[temp[0] doubleValue] longitude:[temp[1] doubleValue]];
            }
        }
        
        _text = dictionary[@"text"];
        
        temp = dictionary[@"user"];
        if(temp && [temp isKindOfClass:[NSDictionary class]]) {
            _userName = temp[@"screen_name"];
        }
    }
    return self;
}

@end
