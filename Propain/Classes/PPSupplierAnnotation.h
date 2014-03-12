//
//  PPSupplierAnnotation.h
//  Propain
//
//  Created by Matt Holcombe on 03/11/2014 @ 10:23 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PPSupplierAnnotation : NSObject <MKAnnotation>
- (id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;
- (NSString *) title;
- (NSString *) subtitle;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
