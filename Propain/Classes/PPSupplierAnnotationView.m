//
//  PPSupplierAnnotationView.m
//  Propain
//
//  Created by Matt Holcombe on 03/11/2014 @ 13:55 .
//  Copyright (c) 2014 Propain, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PPSupplierAnnotationView.h"

NSString * const kSupplierAnnonationViewIdentifier = @"SupplierAnnonationView";

@interface PPSupplierAnnotationView()
@property (nonatomic, strong) NSTimer *tintTimer;
@property (nonatomic) CGFloat tintCounter;
@property (nonatomic, strong) UIView *tintView;
@end

@implementation PPSupplierAnnotationView
@synthesize supplierVO = _supplierVO;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
		self.image = [UIImage imageNamed:@"supplierAnnotation"];
		
		_tintView = [[UIView alloc] initWithFrame:CGRectOffset(self.frame, self.image.size.width * 0.5, self.image.size.height * 0.5)];
		[self addSubview:_tintView];
	}
	
	return (self);
}

- (void)setSupplierVO:(PPSupplierVO *)supplierVO {
	_supplierVO = supplierVO;
	
	[self _clearTimer];
	[self _clearAvailable];
	[self _clearSelected];
	
	if (_supplierVO.isAvailable)
		_tintTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(_cycleAvailableTint) userInfo:nil repeats:YES];
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	[self _toggleSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	[self _toggleSelected];
}


#pragma mark - UI Presentation
- (void)_clearAvailable {
	self.alpha = (_supplierVO.isAvailable) ? 1.0 : 0.5;
	self.frame = CGRectMake(-8.0, -8.0, 16.0, 16.0);
	_tintView.frame = CGRectOffset(self.frame, 8.0, 8.0);
	
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.33];
	[_tintView setBackgroundColor:[UIColor clearColor]];
	[UIView commitAnimations];
}

- (void)_clearSelected {
	self.frame = CGRectMake(-8.0, -8.0, 16.0, 16.0);
	_tintView.frame = CGRectOffset(self.frame, 8.0, 8.0);
	
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.33];
	[_tintView setBackgroundColor:[UIColor clearColor]];
	[UIView commitAnimations];
}

- (void)_toggleSelected {
	[self _clearTimer];
	[self _clearAvailable];
	[self _clearSelected];
	
	int scale = MAX(0, ((int)self.selected * 6.0) - ((int)!_supplierVO.isAvailable * 6.0));
	self.frame = CGRectMake(-8.0 - (scale * 0.5), -8.0 - (scale * 0.5), 16.0 + scale, 16.0 + scale);
	_tintView.frame = CGRectMake(_tintView.frame.origin.x, _tintView.frame.origin.y, 16.0 + scale, 16.0 + scale);
	
	if (self.selected)
		_tintTimer = [NSTimer scheduledTimerWithTimeInterval:(_supplierVO.isAvailable) ? 0.33 : 0.5 target:self selector:(_supplierVO.isAvailable) ? @selector(_cycleSelectedTint) : @selector(_cycleUnavailableSelectedTint) userInfo:nil repeats:YES];
	
	else {
		if (_supplierVO.isAvailable)
			_tintTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(_cycleAvailableTint) userInfo:nil repeats:YES];
	}
}

- (void)_clearTimer {
	_tintCounter = 0;
	if (_tintTimer != nil) {
		[_tintTimer invalidate];
		_tintTimer = nil;
	}
}


- (void)_cycleAvailableTint {
//	NSLog(@"_cycleAvailableTint:(%f)[%d]", _tintCounter, (int)ABS(roundf(sinf(_tintCounter))));
	_tintCounter = fmodf(_tintCounter + M_PI_2, M_PI);
	
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.5];
	[_tintView setBackgroundColor:((BOOL)ABS(roundf(sinf(_tintCounter)))) ? [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.25] : [UIColor clearColor]];
	[UIView commitAnimations];
}

- (void)_cycleSelectedTint {
//	NSLog(@"_cycleSelectedTint:(%f)[%d]", _tintCounter, (int)ABS(roundf(sinf(_tintCounter))));
	_tintCounter = fmodf(_tintCounter + M_PI_2, M_PI);
	
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.33];
	[_tintView setBackgroundColor:((BOOL)ABS(roundf(sinf(_tintCounter)))) ? [UIColor colorWithWhite:1.0 alpha:0.67] : [UIColor clearColor]];
	[UIView commitAnimations];
}

- (void)_cycleUnavailableSelectedTint {
//	NSLog(@"_cycleUnavailableSelectedTint:(%f)[%d]", _tintCounter, (int)ABS(roundf(sinf(_tintCounter))));
	_tintCounter = fmodf(_tintCounter + M_PI_2, M_PI);
	
	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.5];
	[_tintView setBackgroundColor:((BOOL)ABS(roundf(sinf(_tintCounter)))) ? [UIColor colorWithWhite:0.875 alpha:0.5] : [UIColor clearColor]];
	[UIView commitAnimations];
}

@end
