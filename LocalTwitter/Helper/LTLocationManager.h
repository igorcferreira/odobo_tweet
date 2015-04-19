//
//  LTLocationManager.h
//  LocalTwitter
//
//  Created by Igor Ferreira on 4/19/15.
//  Copyright (c) 2015 Igor Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

typedef NS_ENUM(int, LTLocationManagerStatus) {
    kLTLocationManagerStatusUnknown,
    kLTLocationManagerStatusStarted,
    kLTLocationManagerStatusEnded,
    kLTLocationManagerStatusUpdated,
    kLTLocationManagerStatusError
};

@interface LTLocationManager : NSObject

@property (nonatomic, readonly, strong) CLLocation* lastLocation;

+(void)registerObserver:(id)observer selector:(SEL)selector forStatus:(LTLocationManagerStatus)status;
+(void)unRegisterObserver:(id)observer forStatus:(LTLocationManagerStatus)status;

-(void)start;
-(void)stop;

@end
