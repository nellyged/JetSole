//
//  PAWPost.m
//  AnyWall
//
//  Created by Christopher Bowns on 2/8/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import "Store.h"
//#import "PAWAppDelegate.h"

@interface Store ()

// Redefine these properties to make them read/write for internal class accesses and mutations.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geopoint;
//@property (nonatomic, strong) PFUser *user;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;

@end

@implementation Store

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

@synthesize object;
@synthesize geopoint;
//@synthesize user;
@synthesize animatesDrop;
@synthesize pinColor;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle {
	self = [super init];
	if (self) {
		self.coordinate = aCoordinate;
		self.title = aTitle;
		self.subtitle = aSubtitle;
		self.animatesDrop = NO;
	}
	return self;
}

- (id)initWithPFObject:(PFObject *)anObject {
	self.object = anObject;
	self.geopoint = [anObject objectForKey:@"Location"];
	//self.user = [anObject objectForKey:kPAWParseUserKey];
    
	[anObject fetchIfNeeded];
	CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
	NSString *aTitle = [anObject objectForKey:@"Name"];
	NSString *aSubtitle = [anObject objectForKey:@"Name"];
    
	return [self initWithCoordinate:aCoordinate andTitle:aTitle andSubtitle:aSubtitle];
}

- (BOOL)equalToStore:(Store *)aStore {
	if (aStore == nil) {
		return NO;
	}
    
	if (aStore.object && self.object) {
		// We have a PFObject inside the Store, use that instead.
		if ([aStore.object.objectId compare:self.object.objectId] != NSOrderedSame) {
			return NO;
		}
		return YES;
	} else {
		// Fallback code:
		NSLog(@"%s Testing equality of PAWPosts where one or both objects lack a backing PFObject", __PRETTY_FUNCTION__);
        
		if ([aStore.title    compare:self.title]    != NSOrderedSame ||
			[aStore.subtitle compare:self.subtitle] != NSOrderedSame ||
			aStore.coordinate.latitude  != self.coordinate.latitude ||
			aStore.coordinate.longitude != self.coordinate.longitude ) {
			return NO;
		}
        
		return YES;
	}
}

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside {
	if (outside) {
		self.subtitle = nil;
		self.title = @"Can’t view post! Get closer.";
		self.pinColor = MKPinAnnotationColorRed;
	} else {
		self.title = [self.object objectForKey:@"Name"];
		self.subtitle = [self.object objectForKey:@"Name"];
		self.pinColor = MKPinAnnotationColorGreen;
	}
}

@end
