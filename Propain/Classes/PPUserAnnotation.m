//
//  PPUserAnnotationView.m
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 22:56 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//


#import "PPUserAnnotation.h"


@interface PPUserAnnotation ()
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@end

@implementation PPUserAnnotation
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude {
	if ((self = [super init])) {
		_latitude = latitude;
		_longitude = longitude;
	}
	
    return (self);
}


#pragma mark - Public APIs
- (CLLocationCoordinate2D)coordinate {
	CLLocation *location = [[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude];
    return (location.coordinate);
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
	_latitude = coordinate.latitude;
	_longitude = coordinate.longitude;
}


@end
