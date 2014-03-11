//
//  PPUserAnnotationView.h
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 22:56 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PPUserAnnotation : NSObject <MKAnnotation>
+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate2D;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate2D;

@property (nonatomic) CLLocationCoordinate2D coordinate2D;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
