//
//  SearchViewController.m
//  JetSole
//
//  Created by Nelson Gedeon on 2/7/13.
//  Copyright (c) 2013 JetSole. All rights reserved.
//

#import "SearchViewController.h"
#import "Store.h"
#import "LOCAppDelegate.h"
#import <Parse/Parse.h>
#define METERS_PER_MILE 1609.344

@interface SearchViewController ()

@property (nonatomic, strong) CLLocationManager *_locationManager;
@property (nonatomic, assign) BOOL mapPinsPlaced;

- (void)startStandardUpdates;

//// CLLocationManagerDelegate methods:
//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation;
//
//- (void)locationManager:(CLLocationManager *)manager
//       didFailWithError:(NSError *)error;

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance;

@end

@implementation SearchViewController

@synthesize mapPinsPlaced;
@synthesize mapView;
@synthesize _locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc {
	[_locationManager stopUpdatingLocation];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[_locationManager startUpdatingLocation];
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[_locationManager stopUpdatingLocation];
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[_locationManager stopUpdatingLocation];
    
	self.mapPinsPlaced = NO; // reset this for the next time we show the map.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {

    LOCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //Grab my current location
    [self startStandardUpdates];
    // 1
    //CLLocationCoordinate2D location = [[[mapView userLocation] location] coordinate];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude =
    //appDelegate.currentLocation.coordinate.latitude;
    40.667105;
    zoomLocation.longitude =
    //appDelegate.currentLocation.coordinate.longitude;
    -73.994325;

    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);

    // 3
    [mapView setRegion:viewRegion animated:YES];
    
    [self queryForAllPostsNearLocation:appDelegate.currentLocation
                    withNearbyDistance:1000];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
	NSLog(@"%s", __PRETTY_FUNCTION__);
    
	LOCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	appDelegate.currentLocation = newLocation;
}


//- (void)locationManager:(CLLocationManager *)manager
//       didFailWithError:(NSError *)error {
//	NSLog(@"%s", __PRETTY_FUNCTION__);
//	NSLog(@"Error: %@", [error description]);
//    
//	if (error.code == kCLErrorDenied) {
//		[_locationManager stopUpdatingLocation];
//	} else if (error.code == kCLErrorLocationUnknown) {
//		// todo: retry?
//		// set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
//	} else {
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
//		                                                message:[error description]
//		                                               delegate:nil
//		                                      cancelButtonTitle:nil
//		                                      otherButtonTitles:@"Ok", nil];
//		[alert show];
//	}
//}

- (void)startStandardUpdates {
	if (nil == _locationManager) {
		_locationManager = [[CLLocationManager alloc] init];
	}
    
	_locationManager.delegate = self;
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
	// Set a movement threshold for new events.
	_locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    
	[self._locationManager startUpdatingLocation];
    
	CLLocation *currentLocation = _locationManager.location;
	if (currentLocation) {
		LOCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		appDelegate.currentLocation = currentLocation;
	}
}

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance {
	PFQuery *query = [PFQuery queryWithClassName:@"Stores"];
    
	if (currentLocation == nil) {
		NSLog(@"%s got a nil location!", __PRETTY_FUNCTION__);
	}
    
	// Query for posts sort of kind of near our current location.
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:@"Location" nearGeoPoint:point withinKilometers:10000000000.0];
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"error in geo query!"); // todo why is this ever happening?
		} else {
			// We need to make new post objects from objects,
			// and update allPosts and the map to reflect this new array.
			// But we don't want to remove all annotations from the mapview blindly,
			// so let's do some work to figure out what's new and what needs removing.
            NSMutableArray *storeArray = [[NSMutableArray alloc] initWithCapacity:10];
            // The find succeeded with no blocks now lets check if the city returned results.
            NSLog(@"Successfully retrieved %d Stores.", objects.count);
            //Something Return now loop thru and add the objects to the array
            for(PFObject *object in objects){
                Store *newStore = [[Store alloc] initWithPFObject:object];
                [storeArray addObject:newStore];
            }
            
			// 3. Configure our new posts; these are about to go onto the map.
			for (Store *newStore in storeArray) {
				CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:newStore.coordinate.latitude longitude:newStore.coordinate.longitude];
				// if this post is outside the filter distance, don't show the regular callout.
				CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
				[newStore setTitleAndSubtitleOutsideDistance:( distanceFromCurrent > nearbyDistance ? YES : NO )];
				// Animate all pins after the initial load:
				newStore.animatesDrop = mapPinsPlaced;
			}
            
			// At this point, newAllPosts contains a new list of post objects.
			// We should add everything in newStores to the map, remove everything in postsToRemove,
			// and add newStores to allPosts.
			[mapView addAnnotations:storeArray];
			
            
			self.mapPinsPlaced = YES;
		}
	}];
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
	// Let the system handle user location annotations.
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
    
	static NSString *pinIdentifier = @"CustomPinAnnotation";
    
	// Handle any custom annotations.
	if ([annotation isKindOfClass:[Store class]])
	{
		// Try to dequeue an existing pin view first.
		MKPinAnnotationView *pinView = (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
        
		if (!pinView)
		{
			// If an existing pin view was not available, create one.
			pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
			                                          reuseIdentifier:pinIdentifier];
		}
		else {
			pinView.annotation = annotation;
		}
		pinView.pinColor = [(Store *)annotation pinColor];
		pinView.animatesDrop = [((Store *)annotation) animatesDrop];
		pinView.canShowCallout = YES;
        
		return pinView;
	}
    
	return nil;
}

@end
