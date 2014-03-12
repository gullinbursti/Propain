//
//  PPMapViewController.m
//  Propain
//
//  Created by Matt Holcombe on 03/10/2014 @ 20:45 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//


#import "PPMapViewController.h"
#import "PPSupplierAnnotation.h"
#import "PPSupplierAnnotationView.h"
#import "PPSupplierVO.h"
#import "PPUserAnnotation.h"

const CGFloat kMinThresholdMeters = 1000.0f;
const CGFloat kMapAreaMiles = 5.0f;

const CGPoint kDefaultLocation = {-80.626703f, 24.922894f};

NSString * const kUserAnnonationViewIdentifier = @"UserAnnonationView";


@interface PPMapViewController ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) MKCoordinateRegion coordinateRegion;
@property (nonatomic, strong) NSMutableArray *suppliers;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) PPUserAnnotation *userAnnotation;
@property (nonatomic, strong) CLLocation *supplierLocation;
@property (nonatomic, strong) PPSupplierAnnotation *supplierAnnotation;
@property (nonatomic, strong) PPSupplierVO *selectedSupplierVO;
@end

@implementation PPMapViewController


- (id)init {
	if ((self = [super init])) {
		_geocoder = [[CLGeocoder alloc] init];
		_locationManager = [[CLLocationManager alloc] init];
		_suppliers = [NSMutableArray array];
		
		_userLocation = [[CLLocation alloc] initWithLatitude:kDefaultLocation.y longitude:kDefaultLocation.x];
		_coordinateRegion = MKCoordinateRegionMakeWithDistance(_userLocation.coordinate, kMapAreaMiles * kMetersPerMile, kMapAreaMiles * kMetersPerMile);
		
		if ([CLLocationManager locationServicesEnabled]) {
			_locationManager.delegate = self;
			_locationManager.distanceFilter = kMinThresholdMeters;
			[_locationManager startUpdatingLocation];
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
- (void)_retreiveSuppliers {
	NSArray *names = @[@"Hank Hill",
					   @"Dale Gribble",
					   @"Boomhauer",
					   @"Bill Dauterive",
					   @"Buck Strickland",
					   @"Henry Winkler",
					   @"Bob Jenkins",
					   @"Mark Buckley",
					   @"Jimmy Whichard",
					   @"Joe Jack"];
	
	for (PPSupplierVO *vo in _suppliers)
		[self.mapView removeAnnotation:vo.annotation];
	
	[_suppliers removeAllObjects];
	for (int i=0; i<(arc4random() % 10) + 1; i++) {
		CGPoint randOffset = CGPointMake((((((double)(arc4random() % RAND_MAX)) * 0.0625) / RAND_MAX) - 0.03125), (((((double)(arc4random() % RAND_MAX)) * 0.0625) / RAND_MAX) - 0.03125));
		CLLocation *location = [[CLLocation alloc] initWithLatitude:_userLocation.coordinate.latitude + randOffset.x longitude:_userLocation.coordinate.longitude + randOffset.y];
		CLLocationDistance distance = MKMetersBetweenMapPoints(MKMapPointForCoordinate(_userLocation.coordinate), MKMapPointForCoordinate(location.coordinate)) / kMetersPerMile;
		BOOL isCoinHeads = (BOOL)(((float)(arc4random() % RAND_MAX) / RAND_MAX) >= 0.5f);
		
		PPSupplierAnnotation *annotation = [[PPSupplierAnnotation alloc] initWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
		[annotation setTitle:[names objectAtIndex:i]];
		[annotation setSubtitle:(isCoinHeads) ? [NSString stringWithFormat:@"%.02f mile%@", distance, (distance != 1.00f) ? @"s" : @""] : @"UNAVAILABLE"];
		[annotation setCoordinate:location.coordinate];
		
		[_suppliers addObject:[PPSupplierVO supplierWithDictionary:@{@"id"			: [NSString stringWithFormat:@"%d", (i + 1)],
																	 @"name"		: [names objectAtIndex:i],
																	 @"company"		: @"Strickland Propane",
																	 @"available"	: [NSString stringWithFormat:@"%d", (int)isCoinHeads],
																	 @"score"		: [NSString stringWithFormat:@"%d", (arc4random() % 4) + 1],
																	 @"completed"	: [NSString stringWithFormat:@"%d", (arc4random() % 30) + 5],
																	 @"added"		: [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", 2014, (arc4random() % 3) + 1, (arc4random() % 28) + 1, (arc4random() % 24), (arc4random() % 59), (arc4random() % 59)],
																	 @"last"		: [[NSString stringWithFormat:@"%d-%d-%d", 2014, (arc4random() % 3) + 1, (arc4random() % 28) + 1] stringByAppendingString:@" 00:00:00"],
																	 @"annotation"	: annotation,
																	 @"distance"	: [NSString stringWithFormat:@"%f", distance]}]];
	}
	
	int i = 0;
	for (PPSupplierVO *vo in _suppliers) {
		[self performSelector:@selector(_goSelector:) withObject:vo afterDelay:3.0 + (0.25 * i)];
		i++;
	}
}

#pragma mark - View lifecycle
- (void)loadView {
	ViewControllerLog(@"[:|:] [%@ loadView] [:|:]", self.class);
	[super loadView];
}

- (void)viewDidLoad {
	ViewControllerLog(@"[:|:] [%@ viewDidLoad] [:|:]", self.class);
	[super viewDidLoad];
	
	UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, (self.view.bounds.size.height - (kNavHeaderHeight + kNavFooterHeight)) + 1.0)];
	bgView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
	[self.view addSubview:bgView];
	
	self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, self.view.bounds.size.height - (kNavHeaderHeight + kNavFooterHeight))];
	self.mapView.mapType = MKMapTypeStandard;
	self.mapView.delegate = self;
	[self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
	[self.mapView setRegion:_coordinateRegion animated:NO];
	[self.view addSubview:self.mapView];
}


#pragma mark - Public APIs
- (void)updateUserLocation {
	if ([PPAppDelegate serviceRequestFromUserDefaults].serviceRequestStatus >= PPServiceRequestStatusCompleted) {
		for (id<MKAnnotation> annotation in self.mapView.selectedAnnotations)
			[self.mapView deselectAnnotation:annotation animated:YES];
		
		for (id<MKAnnotation> annotation in self.mapView.annotations)
			[self.mapView removeAnnotation:annotation];
	}
	
	[self.mapView deselectAnnotation:_userAnnotation animated:YES];
	[self.mapView removeAnnotation:_userAnnotation];
	
	_userAnnotation = nil;
	[_locationManager startUpdatingLocation];
}

- (void)requestService {
	if ([PPAppDelegate serviceRequestFromUserDefaults].serviceRequestStatus < PPServiceRequestStatusCompleted) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Request in Progress!"
															message:[NSString stringWithFormat:@"You have %@ on-route to your location. Do you wish to cancel?", _selectedSupplierVO.fullName]
														   delegate:self
												  cancelButtonTitle:@"No"
												  otherButtonTitles:@"Yes", nil];
		[alertView setTag:PPMapAlertTypeCancelServiceRequest];
		[alertView show];
	
	} else {
		if (_supplierAnnotation != nil) {
			NSString *title = @"Select %@?";
			for (PPSupplierVO *vo in _suppliers) {
				if ([vo.annotation isEqual:_supplierAnnotation]) {
					title = [NSString stringWithFormat:title, vo.fullName];
					break;
				}
			}
			
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
																message:@"Tapping Yes will dispatch this supplier to your location."
															   delegate:self
													  cancelButtonTitle:@"No"
													  otherButtonTitles:@"Yes", nil];
			[alertView setTag:PPMapAlertTypeOverrideNearestSupplier];
			[alertView show];
		
		} else
			[self _calcNearestSupplier];
	}
}


#pragma mark - Navigation
- (void)_goSelectSupplier {
	[PPAppDelegate writeServiceRequestToUserDefaults:@{@"id"				: [NSString stringWithFormat:@"%@", [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]] stringValue]],
													   @"status"			: [NSString stringWithFormat:@"%d", PPServiceRequestStatusPendingSupplier],
													   @"supplier_id"		: [NSString stringWithFormat:@"%d", _selectedSupplierVO.supplierID],
													   @"supplier_name"		: _selectedSupplierVO.fullName,
													   @"supplier_coords"	: @{@"latitude"		: [NSString stringWithFormat:@"%f", _selectedSupplierVO.annotation.coordinate.latitude],
																				@"longitude"	: [NSString stringWithFormat:@"%f", _selectedSupplierVO.annotation.coordinate.longitude]},
													   @"added"				: @"2014-03-11 14:32:00",
													   @"updated"			: @"2014-03-11 14:32:00",
													   @"ended"				: @"0000-00-00 00:00:00"}];
	
	[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ is on the way!", _selectedSupplierVO.fullName]
														message:@"Check the map for real-time updates"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil] show];
	
	CLLocation *location = [[CLLocation alloc] initWithLatitude:_userAnnotation.coordinate.latitude + ((_supplierAnnotation.coordinate.latitude - _userAnnotation.coordinate.latitude) * 0.5) longitude:_userAnnotation.coordinate.longitude + ((_supplierAnnotation.coordinate.longitude - _userAnnotation.coordinate.longitude) * 0.5)];
	_coordinateRegion = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(ABS(_userAnnotation.coordinate.latitude - _supplierAnnotation.coordinate.latitude) * 2.0, ABS(_userAnnotation.coordinate.longitude - _supplierAnnotation.coordinate.longitude) * 2.0));
	[self.mapView setRegion:_coordinateRegion animated:YES];
}



#pragma mark - UI Presentation
- (void)_goSelector:(id)sender {
//	NSLog(@"\\-[%@ _goSelector:(%@)]-//", self.class, (PPSupplierAnnotation *)sender);
	[self.mapView addAnnotation:((PPSupplierVO *)sender).annotation];
}

- (void)_updateMap {
	NSLog(@"\\-[%@ _updateMap:(%@)]-//", self.class, _userLocation);
	_coordinateRegion = MKCoordinateRegionMakeWithDistance(_userLocation.coordinate, kMapAreaMiles * kMetersPerMile, kMapAreaMiles * kMetersPerMile);
	[self.mapView setRegion:_coordinateRegion animated:YES];
	
	[_geocoder reverseGeocodeLocation:_userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
		CLPlacemark *placemark = (CLPlacemark *)[placemarks firstObject];
		NSString *address = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];
		NSString *cityStateZip = [NSString stringWithFormat:@"%@, %@ %@", placemark.locality, placemark.administrativeArea, placemark.postalCode];
//		NSLog(@"**_[%@ geocoder:reverseGeocodeLocation:(%@ // %@)]_**", self.class, address, cityStateZip);
		
		[_userAnnotation setTitle:address];
		[_userAnnotation setSubtitle:cityStateZip];
	}];
	
	[_userAnnotation setCoordinate:_userLocation.coordinate];
	
	
	if ([PPAppDelegate serviceRequestFromUserDefaults].serviceRequestStatus >= PPServiceRequestStatusCompleted) {
		_supplierAnnotation = nil;
		[self _retreiveSuppliers];
	
	} else {
		[_suppliers removeAllObjects];
		CLLocation *supplierLocation = [[CLLocation alloc] initWithLatitude:[PPAppDelegate serviceRequestFromUserDefaults].supplierCoordinate.latitude longitude:[PPAppDelegate serviceRequestFromUserDefaults].supplierCoordinate.longitude];
		CLLocationDistance distance = MKMetersBetweenMapPoints(MKMapPointForCoordinate(_userLocation.coordinate), MKMapPointForCoordinate(supplierLocation.coordinate)) / kMetersPerMile;
		
		_supplierAnnotation = [[PPSupplierAnnotation alloc] initWithLatitude:supplierLocation.coordinate.latitude andLongitude:supplierLocation.coordinate.longitude];
		[_supplierAnnotation setTitle:[PPAppDelegate serviceRequestFromUserDefaults].supplierName];
		[_supplierAnnotation setSubtitle:[NSString stringWithFormat:@"%.02f mile%@", distance, (distance != 1.00f) ? @"s" : @""]];
		[_supplierAnnotation setCoordinate:supplierLocation.coordinate];
		
		[_suppliers addObject:[PPSupplierVO supplierWithDictionary:@{@"id"			: [NSString stringWithFormat:@"%d", [PPAppDelegate serviceRequestFromUserDefaults].serviceRequestID],
																	 @"name"		: [PPAppDelegate serviceRequestFromUserDefaults].supplierName,
																	 @"company"		: @"Strickland Propane",
																	 @"available"	: [NSString stringWithFormat:@"%d", (int)YES],
																	 @"score"		: [NSString stringWithFormat:@"%d", (arc4random() % 4) + 1],
																	 @"completed"	: [NSString stringWithFormat:@"%d", (arc4random() % 30) + 5],
																	 @"added"		: [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", 2014, (arc4random() % 3) + 1, (arc4random() % 28) + 1, (arc4random() % 24), (arc4random() % 59), (arc4random() % 59)],
																	 @"last"		: [[NSString stringWithFormat:@"%d-%d-%d", 2014, (arc4random() % 3) + 1, (arc4random() % 28) + 1] stringByAppendingString:@" 00:00:00"],
																	 @"annotation"	: _supplierAnnotation,
																	 @"distance"	: [NSString stringWithFormat:@"%f", distance]}]];
		[self.mapView addAnnotation:_supplierAnnotation];
		
		CLLocation *location = [[CLLocation alloc] initWithLatitude:_userAnnotation.coordinate.latitude + ((_supplierAnnotation.coordinate.latitude - _userAnnotation.coordinate.latitude) * 0.5) longitude:_userAnnotation.coordinate.longitude + ((_supplierAnnotation.coordinate.longitude - _userAnnotation.coordinate.longitude) * 0.5)];
		_coordinateRegion = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(ABS(_userAnnotation.coordinate.latitude - _supplierAnnotation.coordinate.latitude) * 2.0, ABS(_userAnnotation.coordinate.longitude - _supplierAnnotation.coordinate.longitude) * 2.0));
		[self.mapView setRegion:_coordinateRegion animated:YES];
		
		[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ is on the way!", [PPAppDelegate serviceRequestFromUserDefaults].supplierName]
									message:@"Check the map for real-time updates"
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	}
}


#pragma mark - LocationManager Delegates
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	NSLog(@"**_[%@ locationManager:didUpdateLocations:(%@)]_**", self.class, locations);
	
	_userLocation = (CLLocation *)[locations firstObject];
	
	if (_userAnnotation == nil) {
		_userAnnotation = [[PPUserAnnotation alloc] initWithLatitude:_userLocation.coordinate.latitude andLongitude:_userLocation.coordinate.longitude];
		[self.mapView addAnnotation:_userAnnotation];
	}
	
	[self _updateMap];
	[_locationManager stopUpdatingLocation];
}


#pragma mark - MapView Delegates
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//	NSLog(@"**_[%@ mapView:viewForAnnotation:(%@)]_**", self.class, annotation);

	if ([annotation isKindOfClass:[PPUserAnnotation class]]) {
		MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kUserAnnonationViewIdentifier];
		
		if (annotationView == nil) {
			annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kUserAnnonationViewIdentifier];
			annotationView.pinColor = MKPinAnnotationColorRed;
			annotationView.canShowCallout = YES;
			annotationView.animatesDrop = YES;
			annotationView.draggable = YES;
		
		} else
			annotationView.annotation = annotation;
		
		return (annotationView);
		
	} else if ([annotation isKindOfClass:[PPSupplierAnnotation class]]) {
		PPSupplierAnnotationView *annotationView = (PPSupplierAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kSupplierAnnonationViewIdentifier];
		
		if (annotationView == nil) {
			annotationView = [[PPSupplierAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kSupplierAnnonationViewIdentifier];
			annotationView.canShowCallout = YES;
			annotationView.draggable = NO;
		
		} else
			annotationView.annotation = annotation;
		
		for (PPSupplierVO *vo in _suppliers) {
			if ([vo.annotation isEqual:annotation]) {
				annotationView.supplierVO = vo;
				break;
			}
		}
		
		if ([annotation isEqual:_supplierAnnotation])
			[annotationView setSelected:YES animated:YES];
		
		return (annotationView);
	}

	return (nil);
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//	NSLog(@"**_[%@ mapView:didAddAnnotationViews:(%@)]_**", self.class, views);
	
	for (MKAnnotationView *annotationView in views) {
		if ([annotationView.annotation isEqual:_supplierAnnotation]) {
			[self.mapView selectAnnotation:annotationView.annotation animated:YES];
			break;
		}
	}
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//	NSLog(@"**_[%@ mapView:didSelectAnnotationView:(%@)]_**", self.class, view);
	
	if ([view isKindOfClass:[PPSupplierAnnotationView class]]) {
		if (((PPSupplierAnnotationView *)view).supplierVO.isAvailable) {
			_selectedSupplierVO = ((PPSupplierAnnotationView *)view).supplierVO;
			_supplierAnnotation = _selectedSupplierVO.annotation;
		}
	}
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
//	NSLog(@"**_[%@ mapView:didDeselectAnnotationView:(%@)]_**", self.class, view);
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
//	NSLog(@"**_[%@ mapView:annotationView:(%@)didChangeDragState:(%@) fromOldState:(%@)]_**", self.class, view, (newState == 0) ? @"None" : (newState == 1) ? @"Starting" : (newState == 2) ? @"Dragging" : (newState == 3) ? @"Canceling" : @"Ending", (oldState == 0) ? @"None" : (oldState == 1) ? @"Starting" : (oldState == 2) ? @"Dragging" : (oldState == 3) ? @"Canceling" : @"Ending");
	
	[self.mapView deselectAnnotation:view.annotation animated:YES];
	
	if (oldState == MKAnnotationViewDragStateEnding && newState == MKAnnotationViewDragStateNone) {
		CLLocation *location = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
		if (CLLocationCoordinate2DIsValid(location.coordinate) && (location.coordinate.latitude != _userLocation.coordinate.latitude || location.coordinate.longitude != _userLocation.coordinate.longitude)) {
			_userLocation = location;
			[self _updateMap];
		}
	}
}


#pragma mark - AlertView Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == PPMapAlertTypeOverrideNearestSupplier) {
		if (buttonIndex == 0) {
			[self.mapView deselectAnnotation:_supplierAnnotation animated:NO];
			
			for (PPSupplierVO *vo in _suppliers)
				[self.mapView addAnnotation:vo.annotation];
			
		} else {
			for (PPSupplierVO *vo in _suppliers)
				[self.mapView removeAnnotation:vo.annotation];
			
			[self.mapView addAnnotation:_supplierAnnotation];
			[self _goSelectSupplier];
		}
		
	} else if (alertView.tag == PPMapAlertTypeUserNearestSupplier) {
		if (buttonIndex == 0) {
			[self.mapView deselectAnnotation:_supplierAnnotation animated:YES];
			
			for (PPSupplierVO *vo in _suppliers)
				[self.mapView addAnnotation:vo.annotation];
		}
		
		else {
			for (PPSupplierVO *vo in _suppliers)
				[self.mapView removeAnnotation:vo.annotation];
			
			[self.mapView addAnnotation:_supplierAnnotation];
			[self _goSelectSupplier];
		}
		
	} else if (alertView.tag == PPMapAlertTypeCancelServiceRequest) {
		if (buttonIndex == 0) {
			
		} else {
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			
			NSMutableDictionary *sericeRequest = [NSMutableDictionary dictionaryWithDictionary:[PPAppDelegate serviceRequestFromUserDefaults].dictionary];
			[sericeRequest setObject:[NSString stringWithFormat:@"%d", PPServiceRequestStatusUserCanceled] forKey:@"status"];
			[sericeRequest setObject:[dateFormat stringFromDate:[NSDate date]] forKey:@"updated"];
			[sericeRequest setObject:[dateFormat stringFromDate:[NSDate date]] forKey:@"ended"];
			[PPAppDelegate writeServiceRequestToUserDefaults:[sericeRequest copy]];
			
			_supplierAnnotation = nil;
			_selectedSupplierVO = nil;
			
			[self updateUserLocation];
		}
	}
}


#pragma mark - Calculations
- (CGFloat)_calcScaleFactor {
	return (ABS(cos((2.0 * M_PI) * (_userLocation.coordinate.latitude / 360.0))));
}

- (void)_calcNearestSupplier {
	_supplierAnnotation = nil;
	_selectedSupplierVO = nil;
	
	for (id<MKAnnotation> annotation in self.mapView.selectedAnnotations)
		[self.mapView deselectAnnotation:annotation animated:YES];
	
	int ind = -1;
	CLLocationDistance distance = 1000.0;
	for (PPSupplierVO *vo in _suppliers) {
		if (vo.distance < distance && vo.isAvailable) {
			ind = vo.supplierID;
			distance = vo.distance;
		}
		
		[self.mapView removeAnnotation:vo.annotation];
	}
	
	for (PPSupplierVO *vo in _suppliers) {
		if (ind == vo.supplierID) {
			_selectedSupplierVO = vo;
			break;
		}
	}
	
	if (_selectedSupplierVO != nil) {
		_supplierAnnotation = _selectedSupplierVO.annotation;
		
		if (_supplierAnnotation != nil)
			[self.mapView addAnnotation:_supplierAnnotation];
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Select %@?", _selectedSupplierVO.fullName]
															message:@"Tapping Yes will dispatch this supplier to your location."
														   delegate:self
												  cancelButtonTitle:@"No"
												  otherButtonTitles:@"Yes", nil];
		[alertView setTag:PPMapAlertTypeUserNearestSupplier];
		[alertView show];
		
	} else {
		for (PPSupplierVO *vo in _suppliers)
			[self.mapView addAnnotation:vo.annotation];
		
		[[[UIAlertView alloc] initWithTitle:@"No Service!"
									message:@"No one is currently available in your area to provide service, try again later."
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	}
}



/**
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

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
	NSLog(@"**_[%@ mapView:didChangeUserTrackingMode:(%@)]_**", self.class, (mode == 0) ? @"None" : (mode == 1) ? @"Follow" : @"FollowWithHeading");
}

**/


@end
