//
//  JBKTestController.m
//  mzyLocations
//
//  Created by maoziyue on 2019/1/18.
//  Copyright © 2019 maoziyue. All rights reserved.
//

#import "JBKTestController.h"
#import "JBKLocationManager.h"

@interface JBKTestController ()<JBKLocationManagerDelegate>

@end

@implementation JBKTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"定位稀释";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    

    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    kLOCATIONMANAGER.delegate = self;
    [kLOCATIONMANAGER startUpdateLocation];

    
}




- (void)ydx_amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    
    NSLog(@"------------loc:(%.6f,%.6f)------------",location.coordinate.latitude,location.coordinate.longitude);
    
}












@end
