//
//  PPServiceRequestVO.m
//  Propain
//
//  Created by Matt Holcombe on 03/11/2014 @ 17:25 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import "PPServiceRequestVO.h"

@implementation PPServiceRequestVO
@synthesize dictionary;
@synthesize serviceRequestID, serviceRequestStatus, supplierID, supplierName, supplierCoordinate, addedDate, updatedDate, endDate;

+ (PPServiceRequestVO *)serviceRequestWithDictionary:(NSDictionary *)dictionary {
	PPServiceRequestVO *vo = [[PPServiceRequestVO alloc] init];
	vo.dictionary = dictionary;
	vo.serviceRequestID = [[dictionary objectForKey:@"id"] intValue];
	vo.serviceRequestStatus = [[dictionary objectForKey:@"status"] intValue];
	vo.supplierID = [[dictionary objectForKey:@"supplier_id"] intValue];
	vo.supplierName = [dictionary objectForKey:@"supplier_name"];
	vo.supplierCoordinate = CLLocationCoordinate2DMake([[[dictionary objectForKey:@"supplier_coords"] objectForKey:@"latitude"] floatValue], [[[dictionary objectForKey:@"supplier_coords"] objectForKey:@"longitude"] floatValue]);
	vo.addedDate = [PPAppDelegate dateForFormattedString:[dictionary objectForKey:@"added"]];
	vo.updatedDate = [PPAppDelegate dateForFormattedString:[dictionary objectForKey:@"updated"]];
	vo.endDate = [PPAppDelegate dateForFormattedString:[dictionary objectForKey:@"ended"]];
	
	return (vo);
}

- (void)dealloc {
	self.dictionary = nil;
	self.supplierName = nil;
	self.updatedDate = nil;
	self.addedDate = nil;
	self.endDate = nil;
}
@end
