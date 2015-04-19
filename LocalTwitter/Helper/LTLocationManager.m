//
//  LTLocationManager.m
//  LocalTwitter
//
//  Created by Igor Ferreira on 4/19/15.
//  Copyright (c) 2015 Igor Ferreira. All rights reserved.
//

#import "LTLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LTLocationManager()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, assign) BOOL isMonitoring;
@property (nonatomic, assign) BOOL calledStart;
@property (nonatomic, assign) LTLocationManagerStatus status;
@end

@implementation LTLocationManager

+(void)registerObserver:(id)observer selector:(SEL)selector forStatus:(LTLocationManagerStatus)status
{
    [LTLocationManager unRegisterObserver:observer forStatus:status];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:[LTLocationManager statusAsString:status] object:nil];
}

+(void)unRegisterObserver:(id)observer forStatus:(LTLocationManagerStatus)status
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:[LTLocationManager statusAsString:status] object:nil];
}

+(void)dispatchStatus:(LTLocationManagerStatus)status forLocationManager:(LTLocationManager*)manager
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[LTLocationManager statusAsString:status] object:manager];
}

+(NSString*)statusAsString:(LTLocationManagerStatus)status
{
    NSString* response;
    switch (status) {
        case kLTLocationManagerStatusStarted:
            response = @"kLTLocationManagerStatusStarted";
            break;
        case kLTLocationManagerStatusUpdated:
            response = @"kLTLocationManagerStatusUpdated";
            break;
        case kLTLocationManagerStatusEnded:
            response = @"kLTLocationManagerStatusEnded";
            break;
        case kLTLocationManagerStatusError:
            response = @"kLTLocationManagerStatusError";
            break;
        default:
            response = @"kLTLocationManagerStatusUnknown";
            break;
    }
    return response;
}

-(instancetype)init
{
    self = [super init];
    if(self) {
        [self configManager];
        [self.locationManager requestWhenInUseAuthorization];
        self.calledStart = NO;
    }
    return self;
}

-(void)updateStatus:(LTLocationManagerStatus)status
{
    self.status = status;
    [LTLocationManager dispatchStatus:status forLocationManager:self];
}

-(void)configManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

-(void)start
{
    if(!self.isMonitoring) {
        if(CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorized || CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationManager startUpdatingLocation];
            self.isMonitoring = YES;
            self.calledStart = NO;
            [LTLocationManager dispatchStatus:kLTLocationManagerStatusStarted forLocationManager:self];
        } else {
            self.calledStart = YES;
        }
    }
}

-(void)stop
{
    [self stopAndDispatch:YES];
}

-(void)stopAndDispatch:(BOOL)dispatch
{
    [self.locationManager stopUpdatingLocation];
    self.isMonitoring = NO;
    if(CLLocationManager.authorizationStatus != kCLAuthorizationStatusNotDetermined) {
        self.calledStart = NO;
    }
    if(dispatch) {
        [LTLocationManager dispatchStatus:kLTLocationManagerStatusEnded forLocationManager:self];
    }
}

-(void)dealloc
{
    [self stopAndDispatch:NO];
}

-(void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status != kCLAuthorizationStatusAuthorized && status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self stopAndDispatch:NO];
        [LTLocationManager dispatchStatus:kLTLocationManagerStatusError forLocationManager:self];
    } else if(self.calledStart) {
        [self start];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _lastLocation = [locations lastObject];
    [LTLocationManager dispatchStatus:kLTLocationManagerStatusUpdated forLocationManager:self];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    self.isMonitoring = NO;
    [LTLocationManager dispatchStatus:kLTLocationManagerStatusError forLocationManager:self];
}

-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    self.isMonitoring = NO;
}

-(void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    self.isMonitoring = YES;
}

@end
