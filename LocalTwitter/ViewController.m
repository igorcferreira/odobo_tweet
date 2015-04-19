//
//  ViewController.m
//  LocalTwitter
//
//  Created by Igor Ferreira on 4/19/15.
//  Copyright (c) 2015 Igor Ferreira. All rights reserved.
//

#import "ViewController.h"
#import "LTTwitterHelper.h"
#import "LTLocationManager.h"

@interface ViewController()

@property (nonatomic, strong) LTLocationManager* locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LTTwitterHelper start];
    [self startLocationManager];
}

-(void)dealloc {
    [LTLocationManager unRegisterObserver:self forStatus:kLTLocationManagerStatusError];
    [LTLocationManager unRegisterObserver:self forStatus:kLTLocationManagerStatusUpdated];
}

- (void)startLocationManager {
    [LTLocationManager registerObserver:self selector:@selector(locationUpdated:) forStatus:kLTLocationManagerStatusUpdated];
    [LTLocationManager registerObserver:self selector:@selector(locationError:) forStatus:kLTLocationManagerStatusError];
    
    self.locationManager = [[LTLocationManager alloc] init];
    [self.locationManager start];
}

-(void)locationUpdated:(NSNotification*)notification
{
    [self.locationManager stop];
    [[LTTwitterHelper sharedInstance] fetchTweetsOnLocation:self.locationManager.lastLocation complete:^(NSArray *tweets) {
        NSLog(@"%@",tweets);
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)locationError:(NSNotification*)notification
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
