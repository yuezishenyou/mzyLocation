//
//  JBKLocationManager.h
//  mzyLocations
//
//  Created by maoziyue on 2019/1/18.
//  Copyright © 2019 maoziyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kLOCATIONMANAGER   ([JBKLocationManager manager])

@class JBKLocationManager;
@protocol JBKLocationManagerDelegate <NSObject>
@optional;
- (void)ydx_amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode;

@end

@interface JBKLocationManager : NSObject

@property (nonatomic, weak) id<JBKLocationManagerDelegate>delegate;

+ (instancetype) manager;

- (void) startUpdateLocation;

- (void) stopUpdateLocation;






@end

NS_ASSUME_NONNULL_END
