//
//  PPSupplierVO.m
//  Propain
//
//  Created by Matt Holcombe on 03/11/2014 @ 12:06 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import "PPSupplierVO.h"

@implementation PPSupplierVO
@synthesize dictionary;
@synthesize supplierID, fullName, companyName, isAvailable, score, completedOrders, addedDate, lastOrderDate, annotation, distance;

+ (PPSupplierVO *)supplierWithDictionary:(NSDictionary *)dictionary {
	PPSupplierVO *vo = [[PPSupplierVO alloc] init];
	vo.dictionary = dictionary;
	
	vo.supplierID = [[dictionary objectForKey:@"id"] intValue];
	vo.fullName = [dictionary objectForKey:@"name"];
	vo.companyName = [dictionary objectForKey:@"company"];
	vo.isAvailable = (BOOL)[[dictionary objectForKey:@"available"] intValue];
	vo.score = [[dictionary objectForKey:@"score"] intValue];
	vo.completedOrders = [[dictionary objectForKey:@"completed"] intValue];
	vo.addedDate = [PPAppDelegate dateForFormattedString:[dictionary objectForKey:@"added"]];
	vo.lastOrderDate = [PPAppDelegate dateForFormattedString:[dictionary objectForKey:@"last"]];
	vo.annotation = (PPSupplierAnnotation *)[dictionary objectForKey:@"annotation"];
	vo.distance = [[dictionary objectForKey:@"distance"] intValue];
	
	return (vo);
}

- (void)dealloc {
	self.dictionary = nil;
	self.fullName = nil;
	self.companyName = nil;
	self.addedDate = nil;
	self.lastOrderDate = nil;
	self.annotation = nil;
}

@end
