//
//  PPSupplierAnnotationView.h
//  Propain
//
//  Created by Matt Holcombe on 03/11/2014 @ 13:55 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "PPSupplierVO.h"

extern NSString * const kSupplierAnnonationViewIdentifier;

@interface PPSupplierAnnotationView : MKAnnotationView
@property (nonatomic, retain) PPSupplierVO *supplierVO;
@end
