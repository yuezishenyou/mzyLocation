//
//  JBKLocationManager.m
//  mzyLocations
//
//  Created by maoziyue on 2019/1/18.
//  Copyright © 2019 maoziyue. All rights reserved.
//

#import "JBKLocationManager.h"


@interface JBKLocationManager ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) CGFloat minSpeed;     //最小速度
@property (nonatomic, assign) CGFloat minFilter;    //最小范围
@property (nonatomic, assign) CGFloat minInteval;   //更新间隔




@end

@implementation JBKLocationManager

+ (instancetype) manager {
    static JBKLocationManager *_instance = nil;
    if (_instance == nil) {
        _instance = [[JBKLocationManager alloc] init];
        
        _instance.minSpeed = 3;
        _instance.minFilter = 50;
        _instance.minInteval = 10;
        
    }
    return _instance;
}


- (AMapLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = self.minFilter;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return  _locationManager;
}

- (void) startUpdateLocation {
    
    [self.locationManager startUpdatingLocation];
}

- (void) stopUpdateLocation {
    
    [self.locationManager stopUpdatingLocation];
}






#pragma mark --------------------------- AMapLocationManager代理 -----------------------------------

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    
    /**
     *  定位
        location.timestamp           //时间戳
        location.horizontalAccuracy  //精度
        location.altitude            //海拔
        location.speed               //速度
        location.course              //角度
        location.coordinate          //经纬度
     */

    //horizontalAccuracy 负值无效, 越大越不精确
    if (0 < location.horizontalAccuracy && location.horizontalAccuracy < 100 ) {
        
        [self adjustDistanceFilter:location];

        if ([self.delegate respondsToSelector:@selector(ydx_amapLocationManager:didUpdateLocation:reGeocode:)]) {
            [self.delegate ydx_amapLocationManager:manager didUpdateLocation:location reGeocode:reGeocode];
        }
    }
}






/**
 *  规则: 如果速度小于minSpeed m/s 则把触发范围设定为50m
 *  否则将触发范围设定为minSpeed*minInteval
 *  此时若速度变化超过10% 则更新当前的触发范围(这里限制是因为不能不停的设置distanceFilter,
 *  否则uploadLocation会不停被触发)
 */

/**
 *
 1. 用户位置持续变化，则隔一段时间上报一次
 2. 用户移动速度很慢，则隔一段距离上报一次
 3. 用户位置没有变化，则不继续上报或隔很长时间上报一次
 4. 切换到后台也要能定位上报
 5. app因各种原因终止运行(用户主动关闭,系统杀掉) 也要能定位上报
 

 如果速度小于 minSpeed(3), 则隔50米上报一个次   minFilter
 如果速度大于 minSpeed(3), 10秒就上传一次      speed * interval
 
 */


- (void)adjustDistanceFilter:(CLLocation *)location {
    
    if (location.speed < self.minSpeed) {
        if (fabs(self.locationManager.distanceFilter - self.minFilter) > 0.1f) {
            self.locationManager.distanceFilter = self.minFilter;
        }
    }
    else {
        CGFloat lastSpeed = self.locationManager.distanceFilter / self.minInteval;
        if (((fabs(lastSpeed - location.speed) / lastSpeed) > 0.1f ) || (lastSpeed < 0)) {
            CGFloat newSpeed  = (int)(location.speed+0.5f);
            CGFloat newFilter = newSpeed*self.minInteval;
            self.locationManager.distanceFilter = newFilter;
        }
    }
}













@end
