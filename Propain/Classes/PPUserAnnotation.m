//
//  PPUserAnnotationView.m
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 22:56 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//


#import "PPUserAnnotation.h"


@interface PPUserAnnotation ()
@end

@implementation PPUserAnnotation
@synthesize coordinate = _cooordinare;
@synthesize title = _title;
@synthesize subtitle = _subtitle;


- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate2D {
	if ((self = [super init]))
		self.coordinate2D = coordinate2D;
	
    return (self);
}


#pragma mark - Public APIs
+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate2D {
    return ([[[self class] alloc] initWithCoordinate:coordinate2D]);
}


@end
