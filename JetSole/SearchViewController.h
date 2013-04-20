//
//  SearchViewController.h
//  JetSole
//
//  Created by Nelson Gedeon on 2/7/13.
//  Copyright (c) 2013 JetSole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SearchViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
