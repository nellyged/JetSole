//
//  LOCAppDelegate.h
//  JetSole
//
//  Created by Nelson Gedeon on 2/7/13.
//  Copyright (c) 2013 JetSole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface LOCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CLLocation *currentLocation;
//@property (nonatomic, strong) UINavigationController *navController;

//- (void)logOut;

@end
