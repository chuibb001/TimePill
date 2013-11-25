//
//  TPLocationManager.h
//  TimePill
//
//  Created by yan simon on 13-9-17.
//  Copyright (c) 2013年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class LocationObject;
@protocol TPLocationDelegate <NSObject>

-(void)TPLocationManagerDidReceiveLocation:(LocationObject *)lc;

-(void)TPLocationManagerDidFailWithError:(NSError *)error;

@end

@interface LocationObject : NSObject

@property (nonatomic,assign) CLLocationCoordinate2D position;
@property (nonatomic, strong) NSString *cityName;

@end


@interface TPLocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    LocationObject *_object;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) LocationObject *object;
@property (nonatomic, assign) id<TPLocationDelegate> delegate;

+ (id)sharedInstance;

- (void)startLocate;

- (void)cancleLocate;

- (BOOL)isAbleLocate;

@end
