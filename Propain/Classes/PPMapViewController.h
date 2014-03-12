//
//  PPMapViewController.h
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 20:45 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

typedef enum {
	PPMapAlertTypeOverrideNearestSupplier = 0,
	PPMapAlertTypeUserNearestSupplier,
	PPMapAlertTypeCancelServiceRequest
} PPMapAlertType;


extern const CGFloat kMinThresholdMeters;
extern const CGFloat kMapAreaMiles;

extern const CGPoint kDefaultLocation;

extern NSString * const kUserAnnonationViewIdentifier;


@protocol PPMapViewControllerDelegate;
@interface PPMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate>
- (void)updateUserLocation;
- (void)requestService;

@property (nonatomic, assign) id<PPMapViewControllerDelegate> delegate;
@property (nonatomic, retain) MKMapView *mapView;
@end


@protocol PPMapViewControllerDelegate <NSObject>
- (void)mapViewController:(PPMapViewController *)mapViewController didUpdateLocation:(CLLocationCoordinate2D *)locationCoordinate2D;
@end