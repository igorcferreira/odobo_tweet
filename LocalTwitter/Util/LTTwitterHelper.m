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

@interface LTTwitterHelper()

@property (nonatomic, assign) BOOL loginSuccessful;
@property (nonatomic, strong) STTwitterAPI* twitterAPI;

@end

@implementation LTTwitterHelper

-(void)performLoginWithComplete:(void(^)())completeBlock andError:(void(^)(NSError* error))errorBlock
{
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if(error && errorBlock)
            errorBlock(error);
        else if(error == nil) {
            if(self.twitterAPI == nil)
                self.twitterAPI = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_APP_KEY consumerSecret:TWITTER_APP_SECRET];
            
            [self.twitterAPI verifyCredentialsWithSuccessBlock:^(NSString *username) {
                if(completeBlock)
                    completeBlock();
            } errorBlock:^(NSError *error) {
                if(errorBlock)
                    errorBlock(error);
            }];
        }
    }];
}

@end
