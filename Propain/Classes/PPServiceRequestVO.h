//
//  PPServiceRequestVO.h
//  Propain
//
//  Created by Matt Holcombe on 03/11/2014 @ 17:25 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import <MapKit/MapKit.h>

typedef enum {
	PPServiceRequestStatusPendingSupplier = 0,
	PPServiceRequestStatusOnRoute,
	PPServiceRequestStatusOnSite,
	PPServiceRequestStatusCompleted,
	PPServiceRequestStatusUserCanceled,
	PPServiceRequestStatusSupplierCanceled,
	PPServiceRequestStatusCannotComplete,
	PPServiceRequestStatusInvalid
} PPServiceRequestStatus;

@interface PPServiceRequestVO : NSObject
+ (PPServiceRequestVO *)serviceRequestWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int serviceRequestID;
@property (nonatomic) int supplierID;
@property (nonatomic, retain) NSString *supplierName;
@property (nonatomic) CLLocationCoordinate2D supplierCoordinate;
@property (nonatomic) PPServiceRequestStatus serviceRequestStatus;
@property (nonatomic, retain) NSDate *addedDate;
@property (nonatomic, retain) NSDate *updatedDate;
@property (nonatomic, retain) NSDate *endDate;
@end
