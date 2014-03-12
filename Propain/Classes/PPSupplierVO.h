//
//  PPSupplierVO.h
//  Propain
//
//  Created by Matt Holcombe on 03/11/2014 @ 12:06 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "PPSupplierAnnotation.h"

@interface PPSupplierVO : NSObject
+ (PPSupplierVO *)supplierWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int supplierID;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *companyName;
@property (nonatomic) BOOL isAvailable;
@property (nonatomic) int score;
@property (nonatomic) int completedOrders;
@property (nonatomic, retain) NSDate *addedDate;
@property (nonatomic, retain) NSDate *lastOrderDate;
@property (nonatomic, retain) PPSupplierAnnotation *annotation;
@property (nonatomic) CLLocationDistance distance;
@end
