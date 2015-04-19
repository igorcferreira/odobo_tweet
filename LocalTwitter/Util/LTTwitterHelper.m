//
//  LTTwitterHelper.m
//  LocalTwitter
//
//  Created by Igor Ferreira on 4/19/15.
//  Copyright (c) 2015 Igor Ferreira. All rights reserved.
//

#import "LTTwitterHelper.h"
#import "Constants.h"
#import <STTwitterAPI.h>
#import <TwitterKit/TwitterKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Twitter/Twitter.h>
#import <TwitterKit/TwitterKit.h>
#import "TWTRGeoTweet.h"

@interface LTTwitterHelper()

@property (nonatomic, assign) BOOL loginSuccessful;
@property (nonatomic, strong) STTwitterAPI* twitterAPI;

@end

@implementation LTTwitterHelper

+(void)start
{
    [LTTwitterHelper sharedInstance];
}

+(instancetype)sharedInstance
{
    static LTTwitterHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LTTwitterHelper alloc] init];
    });
    
    if(helper && !helper.loginSuccessful) {
        [helper performLoginWithComplete:^{
            helper.loginSuccessful = YES;
        } andError:^(NSError *error) {
            helper.loginSuccessful = NO;
        }];
    }
    
    return helper;
}

-(void)performLoginWithComplete:(void(^)())completeBlock andError:(void(^)(NSError* error))errorBlock
{
    if(self.loginSuccessful) {
        if(completeBlock) {
            completeBlock();
        }
        return;
    }
    
    __weak LTTwitterHelper *weakSelf = self;
    
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if(error && errorBlock)
            errorBlock(error);
        else if(error == nil) {
            if(weakSelf.twitterAPI == nil)
                weakSelf.twitterAPI = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_APP_KEY consumerSecret:TWITTER_APP_SECRET];
            
            [weakSelf.twitterAPI verifyCredentialsWithSuccessBlock:^(NSString *username) {
                weakSelf.loginSuccessful = YES;
                if(completeBlock)
                    completeBlock();
            } errorBlock:^(NSError *error) {
                weakSelf.loginSuccessful = NO;
                if(errorBlock)
                    errorBlock(error);
            }];
        }
    }];
}

-(void)fetchTweetsOnLocation:(CLLocation*)location
                    complete:(void(^)(NSArray* tweets))completeBlock
                       error:(void(^)(NSError* error))errorBlock {
    
    [self performLoginWithComplete:^{
        [self.twitterAPI getSearchTweetsWithQuery:@""
                                          geocode:[NSString stringWithFormat:@"%f,%f,1km",location.coordinate.latitude, location.coordinate.longitude]
                                             lang:[[NSLocale preferredLanguages] objectAtIndex:0]
                                           locale:nil
                                       resultType:@"mixed"
                                            count:nil
                                            until:nil
                                          sinceID:nil
                                            maxID:nil
                                  includeEntities:@(NO)
                                         callback:nil
                                     successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                         NSMutableArray* ids = [[NSMutableArray alloc] initWithCapacity:statuses.count];
                                         
                                         __block NSMutableDictionary* elements = [[NSMutableDictionary alloc] init];
                                         
                                         for(NSDictionary* status in statuses) {
                                             NSString* element = [NSString stringWithFormat:@"%@",[status objectForKey:@"id"]];
                                             CLLocation* location = [self locationForStatus:status];
                                             if(location) {
                                                 [ids addObject:element];
                                                 [elements setObject:location forKey:element];
                                             }
                                         }
                                         
                                         [[[Twitter sharedInstance] APIClient] loadTweetsWithIDs:ids completion:^(NSArray *tweets, NSError *error) {
                                             if(error) {
                                                 if(errorBlock) {
                                                     errorBlock(error);
                                                 }
                                                 return;
                                             }
                                             
                                             if([tweets count]) {
                                                 NSMutableArray* geoTweets = [[NSMutableArray alloc] initWithCapacity:tweets.count];
                                                 for(TWTRTweet *tweet in tweets) {
                                                     TWTRGeoTweet *geo = [[TWTRGeoTweet alloc] initGeoTweetWithTweet:tweet andLocation:elements[tweet.tweetID]];
                                                     [geoTweets addObject:geo];
                                                 }
                                                 
                                                 if(completeBlock) {
                                                     completeBlock([NSArray arrayWithArray:geoTweets]);
                                                 }
                                             }
                                             
                                         }];
                                     }
                                       errorBlock:^(NSError *error) {
                                           if(errorBlock) {
                                               errorBlock(error);
                                           }
                                       }];
    } andError:^(NSError *error) {
        if(errorBlock) {
            errorBlock(error);
        }
    }];
}

-(CLLocation*)locationForStatus:(NSDictionary*)status
{
    id temp = status[@"geo"];
    if(temp && [temp isKindOfClass:[NSDictionary class]]) {
        temp = temp[@"coordinates"];
        if(temp && [temp isKindOfClass:[NSArray class]]) {
            return [[CLLocation alloc] initWithLatitude:[temp[0] doubleValue] longitude:[temp[1] doubleValue]];
        }
    }
    return nil;
}

@end
