//
//  PPMapViewController.m
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 20:45 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//


#import "PPMapViewController.h"
#import "PPUserAnnotation.h"


@interface PPMapViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic) MKCoordinateRegion coordinateRegion;
@property (nonatomic, strong) PPUserAnnotation *userAnnotation;
@end


NSString * const kUserAnnonationViewIdentifier = @"UserAnnonationView";
NSString * const kMKUserAnnonationViewIdentifier = @"MKModernUserLocationView";


@implementation PPMapViewController


- (id)init {
	if ((self = [super init])) {
		self.geocoder = [[CLGeocoder alloc] init];
		self.locationManager = [[CLLocationManager alloc] init];
		
		self.location = [[CLLocation alloc] initWithLatitude:kHomePoint.y longitude:kHomePoint.x];
		self.coordinateRegion = MKCoordinateRegionMake(self.location.coordinate, MKCoordinateSpanMake(kMapScaleMiles / 69.0, kMapScaleMiles / ([self _calcScaleFactor] * 69.0)));
		
		if ([CLLocationManager locationServicesEnabled]) {
			self.locationManager.delegate = self;
			self.locationManager.distanceFilter = kMapDistanceMeters;
			[self.locationManager startUpdatingLocation];
		}
	}
	
	return (self);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	
}

- (BOOL)shouldAutorotate {
	return (NO);
}


#pragma mark - Data Calls


#pragma mark - View lifecycle
- (void)loadView {
	ViewControllerLog(@"[:|:] [%@ loadView] [:|:]", self.class);
	[super loadView];
}

- (void)viewDidLoad {
	ViewControllerLog(@"[:|:] [%@ viewDidLoad] [:|:]", self.class);
	[super viewDidLoad];
	
	self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, kNavHeaderHeight, 320.0, self.view.bounds.size.height - (kNavHeaderHeight + kNavFooterHeight))];
	self.mapView.mapType = MKMapTypeStandard;
	self.mapView.delegate = self;
	self.mapView.centerCoordinate = self.location.coordinate;
//	[self.mapView regionThatFits:self.coordinateRegion];
	[self.mapView setRegion:self.coordinateRegion animated:NO];
	[self.view addSubview:self.mapView];
}

- (void)viewWillAppear:(BOOL)animated {
	ViewControllerLog(@"[:|:] [%@ viewWillAppear:%@] [:|:]", self.class, (animated) ? @"YES" : @"NO");
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	ViewControllerLog(@"[:|:] [%@ viewDidAppear:%@] [:|:]", self.class, (animated) ? @"YES" : @"NO");
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	ViewControllerLog(@"[:|:] [%@ viewWillDisappear:%@] [:|:]", self.class, (animated) ? @"YES" : @"NO");
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	ViewControllerLog(@"[:|:] [%@ viewDidDisappear:%@] [:|:]", self.class, (animated) ? @"YES" : @"NO");
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload {
	ViewControllerLog(@"[:|:] [%@ viewDidUnload] [:|:]", self.class);
	[super viewDidUnload];
}


#pragma mark - Navigation



#pragma mark - LocationManager Delegates
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	NSLog(@"**_[%@ locationManager:didUpdateLocations:(%@)]_**", self.class, locations);
	
	self.location = (CLLocation *)[locations firstObject];
	self.coordinateRegion = MKCoordinateRegionMake(self.location.coordinate, MKCoordinateSpanMake(kMapScaleMiles / 69.0, kMapScaleMiles / ([self _calcScaleFactor] * 69.0)));

	self.userAnnotation = [[PPUserAnnotation alloc] initWithCoordinate:self.location.coordinate];
	self.userAnnotation.title = @"HOME";
	self.userAnnotation.subtitle = @"HERE";
	
	self.mapView.showsUserLocation = YES;
	self.mapView.centerCoordinate = self.location.coordinate;
	[self.mapView setRegion:self.coordinateRegion animated:YES];
	[self.mapView addAnnotation:self.userAnnotation];
	
	[self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	NSLog(@"**_[%@ locationManager:didUpdateHeading:(%@)]_**", self.class, newHeading);
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	NSLog(@"**_[%@ locationManagerShouldDisplayHeadingCalibration:]_**", self.class);
	return (YES);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
	NSLog(@"**_[%@ locationManager:didDetermineState:(%d)forRegion:(%@)]_**", self.class, state, region);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
	NSLog(@"**_[%@ locationManager:rangingBeaconsDidFailForRegion:(%@) withError:(%@)]_**", self.class, region, error.description);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
	NSLog(@"**_[%@ locationManager:didEnterRegion:(%@)]_**", self.class, region);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
	NSLog(@"**_[%@ locationManager:didExitRegion:(%@)]_**", self.class, region);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"**_[%@ locationManager:didFailWithError:(%@)]_**", self.class, error.description);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
	NSLog(@"**_[%@ locationManager:monitoringDidFailForRegion:(%@) withError:(%@)]_**", self.class, region, error.description);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	NSLog(@"**_[%@ locationManager:didChangeAuthorizationStatus:(%@)]_**", self.class, (status == 0) ? @"NotDetermined" : (status == 1) ? @"Restricted" : (status == 2) ? @"Denied" : @"Authorized");
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
	NSLog(@"**_[%@ locationManager:didStartMonitoringForRegion:(%@)]_**", self.class, region);
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
	NSLog(@"**_[%@ locationManagerDidPauseLocationUpdates:]_**", self.class);
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
	NSLog(@"**_[%@ locationManagerDidResumeLocationUpdates:]_**", self.class);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
	NSLog(@"**_[%@ locationManager:didFinishDeferredUpdatesWithError:(%@)]_**", self.class, error.description);
}


#pragma mark - MapView Delegates
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
//	NSLog(@"**_[%@ mapView:regionWillChangeAnimated:(%@)]_**", self.class, (animated) ? @"YES" : @"NO");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//	NSLog(@"**_[%@ mapView:regionDidChangeAnimated:(%@)]_**", self.class, (animated) ? @"YES" : @"NO");
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
//	NSLog(@"**_[%@ mapView:mapViewWillStartLoadingMap]_**", self.class);
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
//	NSLog(@"**_[%@ mapView:mapViewDidFinishLoadingMap]_**", self.class);
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
//	NSLog(@"**_[%@ mapView:mapViewDidFailLoadingMap:withError:(%@)]_**", self.class, error.description);
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView {
//	NSLog(@"**_[%@ mapView:mapViewWillStartRenderingMap]_**", self.class);
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
	NSLog(@"**_[%@ mapView:mapViewDidFinishRenderingMap:fullyRendered:(%@)]_**", self.class, (fullyRendered) ? @"YES" : @"NO");
}

/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	NSLog(@"**_[%@ mapView:viewForAnnotation:(%@)]_**", self.class, annotation);
	
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		NSLog(@"	---(MKUserLocation)---");
		MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kUserAnnonationViewIdentifier];
		
		if (annotationView == nil) {
			annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kUserAnnonationViewIdentifier];
			annotationView.backgroundColor = [UIColor greenColor];
			annotationView.image = [UIImage imageNamed:@"settings_nonActive"];
			annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, annotationView.image.size.width, annotationView.image.size.height);
			[annotationView setEnabled:YES];
			[annotationView setDraggable:YES];
			[annotationView setCanShowCallout:NO];
		
		} else
			annotationView.annotation = annotation;
		
		return (annotationView);
	}
	
    return ([[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKAnnotationView"]);
}
*/

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//	NSLog(@"**_[%@ mapView:didAddAnnotationViews:(%@)]_**", self.class, views);
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//	NSLog(@"**_[%@ mapView:didSelectAnnotationView:(%@)]_**", self.class, view);
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
//	NSLog(@"**_[%@ mapView:didDeselectAnnotationView:(%@)]_**", self.class, view);
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
//	NSLog(@"**_[%@ mapView:mapViewWillStartLocatingUser]_**", self.class);
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
//	NSLog(@"**_[%@ mapView:mapViewDidStopLocatingUser]_**", self.class);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//	NSLog(@"**_[%@ mapView:didUpdateUserLocation:(%@)]_**", self.class, userLocation);
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
//	NSLog(@"**_[%@ mapView:didFailToLocateUserWithError:(%@)]_**", self.class, error.description);
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
//	NSLog(@"**_[%@ mapView:annotationView:(%@)didChangeDragState:(%@) fromOldState:(%@)]_**", self.class, view, (newState == 0) ? @"None" : (newState == 1) ? @"Starting" : (newState == 2) ? @"Dragging" : (newState == 3) ? @"Canceling" : @"Ending", (oldState == 0) ? @"None" : (oldState == 1) ? @"Starting" : (oldState == 2) ? @"Dragging" : (oldState == 3) ? @"Canceling" : @"Ending");
		
//	if (newState == MKAnnotationViewDragStateEnding) {
//		CLLocation *location = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
//		
//		if (CLLocationCoordinate2DIsValid(location.coordinate)) {
//			if (location.coordinate.latitude != self.location.coordinate.latitude || location.coordinate.longitude != self.location.coordinate.longitude) {
//				self.location = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
//				self.coordinateRegion = MKCoordinateRegionMake(self.location.coordinate, MKCoordinateSpanMake(kMapScaleMiles / 69.0, kMapScaleMiles / ([self _calcScaleFactor] * 69.0)));
//				
//				self.mapView.centerCoordinate = self.location.coordinate;
//				[self.mapView setRegion:self.coordinateRegion animated:YES];
//			}
//		}
//	}
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
	NSLog(@"**_[%@ mapView:didChangeUserTrackingMode:(%@)]_**", self.class, (mode == 0) ? @"MKUserTrackingModeNone" : (mode == 1) ? @"Follow" : @"FollowWithHeading");
}



#pragma mark - Calculations
- (CGFloat)_calcScaleFactor {
	return (ABS(cos((2.0 * M_PI) * (self.location.coordinate.latitude / 360.0))));
}



@end
