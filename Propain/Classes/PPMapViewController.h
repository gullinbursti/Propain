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

extern NSString * const kUserAnnonationViewIdentifier;
extern NSString * const kMKUserAnnonationViewIdentifier;

@protocol PPMapViewControllerDelegate;
@interface PPMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, assign) id <PPMapViewControllerDelegate> delegate;
@property (nonatomic, retain) MKMapView *mapView;
@end

@protocol PPMapViewControllerDelegate <NSObject>
- (void)mapViewController:(PPMapViewController *)mapViewController didUpdateLocation:(CLLocationCoordinate2D *)locationCoordinate2D;
@end