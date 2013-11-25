//
//  TPLocationManager.m
//  TimePill
//
//  Created by yan simon on 13-9-17.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import "TPLocationManager.h"
@implementation LocationObject

@end

@implementation TPLocationManager

static TPLocationManager *instance = nil;

// singleton
+(id)sharedInstance
{
    if (instance == nil) {
        instance = [[TPLocationManager alloc] init];
    }
	return instance;
}

-(id)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000.0f;
    }
    return self;
}

#pragma mark - 定位
-(void)startLocate
{
    [_locationManager startUpdatingLocation];
}

-(void)cancleLocate
{
    [_locationManager stopUpdatingLocation];
}

-(BOOL)isAbleLocate
{
    return YES;
}

#pragma mark - location Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位出错");
    [self.delegate TPLocationManagerDidFailWithError:error];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!newLocation) {
        [self locationManager:manager didFailWithError:(NSError *)NULL];
        return;
    }
    
    if (signbit(newLocation.horizontalAccuracy)) {
		[self locationManager:manager didFailWithError:(NSError *)NULL];
		return;
	}
    
    [manager stopUpdatingLocation];
    
    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    _object.position = newLocation.coordinate;
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error)
     {
         for(CLPlacemark *placemark in placemarks)
         {
             NSLog(@"获取地点成功");
             NSLog(@"address dir %@",placemark.addressDictionary);
             _object.cityName = [placemark.addressDictionary objectForKey:@"City"];
         }
     }];
    
    [self.delegate TPLocationManagerDidReceiveLocation:_object];
    
}

@end
