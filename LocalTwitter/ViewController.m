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
#import "Constants.h"
#import <GoogleMaps.h>
#import <TwitterKit/TwitterKit.h>
#import "TWTRGeoTweet.h"

@interface ViewController()<GMSMapViewDelegate>

@property (nonatomic, strong) LTLocationManager* locationManager;
@property (nonatomic, strong) GMSMapView* mapView;
@property (nonatomic, strong) NSArray* tweetResume;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LTTwitterHelper start];
    [self startLocationManager];
    [self createMapView];
}

-(void)dealloc {
    [LTLocationManager unRegisterObserver:self forStatus:kLTLocationManagerStatusError];
    [LTLocationManager unRegisterObserver:self forStatus:kLTLocationManagerStatusUpdated];
}

-(void)createMapView {
    if(self.mapView == nil) {
        [GMSServices provideAPIKey:kGoogleAPI];
        self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:[GMSCameraPosition cameraWithLatitude:0.0 longitude:0.0 zoom:14]];
        self.mapView.delegate = self;
        self.view = self.mapView;
    }
}

- (void)startLocationManager {
    [LTLocationManager registerObserver:self selector:@selector(locationUpdated:) forStatus:kLTLocationManagerStatusUpdated];
    [LTLocationManager registerObserver:self selector:@selector(locationError:) forStatus:kLTLocationManagerStatusError];
    
    self.locationManager = [[LTLocationManager alloc] init];
    [self.locationManager start];
}

-(void)drawMarkers {
    [self.mapView clear];
    for(TWTRGeoTweet* tweet in self.tweetResume) {
        GMSMarker* marker = [GMSMarker markerWithPosition:tweet.location.coordinate];
        marker.title = tweet.text;
        marker.snippet = tweet.author.screenName;
        marker.userData = tweet;
        marker.map = self.mapView;
    }
}

-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    TWTRTweet *tweet = marker.userData;
    TWTRTweetTableViewCell* cell = [[TWTRTweetTableViewCell alloc] init];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell configureWithTweet:tweet];
    CGRect frame = cell.frame;
    frame.size.height = [TWTRTweetTableViewCell heightForTweet:tweet width:frame.size.width];
    [cell setFrame:frame];
    return cell;
}

-(void)locationUpdated:(NSNotification*)notification
{
    [self.locationManager stop];
    
    CLLocation* lastLocation = self.locationManager.lastLocation;
    
    [self.mapView animateToCameraPosition:[GMSCameraPosition cameraWithTarget:lastLocation.coordinate zoom:14]];
    
    [[LTTwitterHelper sharedInstance] fetchTweetsOnLocation:lastLocation complete:^(NSArray *tweets) {
        self.tweetResume = tweets;
        [self drawMarkers];
    } error:^(NSError *error) {
        
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
