//
//  TWTRGeoTweet.m
//  LocalTwitter
//
//  Created by Igor Ferreira on 4/19/15.
//  Copyright (c) 2015 Igor Ferreira. All rights reserved.
//

#import "TWTRGeoTweet.h"

@implementation TWTRGeoTweet

@synthesize tweetID = _tweetID;
@synthesize createdAt = _createdAt;
@synthesize text = _text;
@synthesize author = _author;
@synthesize favoriteCount = _favoriteCount;
@synthesize retweetCount = _retweetCount;
@synthesize inReplyToTweetID = _inReplyToTweetID;
@synthesize inReplyToUserID = _inReplyToUserID;
@synthesize inReplyToScreenName = _inReplyToScreenName;
@synthesize permalink = _permalink;
@synthesize isFavorited = _isFavorited;
@synthesize isRetweeted = _isRetweeted;
@synthesize retweetID = _retweetID;
@synthesize retweetedTweet = _retweetedTweet;

-(instancetype)initGeoTweetWithTweet:(TWTRTweet*)tweet andLocation:(CLLocation*)location
{
    self = [super init];
    if(self) {
        _tweetID = tweet.tweetID;
        _createdAt = tweet.createdAt;
        _text = tweet.text;
        _author = tweet.author;
        _favoriteCount = tweet.favoriteCount;
        _retweetCount = tweet.retweetCount;
        _inReplyToTweetID = tweet.inReplyToTweetID;
        _inReplyToUserID = tweet.inReplyToUserID;
        _inReplyToScreenName = tweet.inReplyToScreenName;
        _permalink = tweet.permalink;
        _isFavorited = tweet.isFavorited;
        _isRetweeted = tweet.isRetweeted;
        _retweetID = tweet.retweetID;
        _retweetedTweet = tweet.retweetedTweet;
        _location = location;
    }
    return self;
}

@end
