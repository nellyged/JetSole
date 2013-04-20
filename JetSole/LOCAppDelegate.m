//
//  LOCAppDelegate.m
//  JetSole
//
//  Created by Nelson Gedeon on 2/7/13.
//  Copyright (c) 2013 JetSole. All rights reserved.
//

#import "LOCAppDelegate.h"
#import <Parse/Parse.h>
#import "LOCThirdViewController.h"
#import "Login.h"


//@interface LOCAppDelegate () {
//    NSMutableData *_data;
//    BOOL firstLaunch;
//}
//@property (nonatomic, strong) MBProgressHUD *hud;
//
//- (void)setupAppearance;
//- (BOOL)shouldProceedToMainInterface:(PFUser *)user;
//- (BOOL)handleActionURL:(NSURL *)url;
//@end

@implementation LOCAppDelegate

//@synthesize hud;
@synthesize window;
//@synthesize navController;


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"8XlcykeSbihbcBbSppWBNbw7Z2WcgaHgtIqd6wdL"
                  clientKey:@"Sml6lBHAMugpCdYH5nBiQLGBE2NxbB5AxhUUUE0X"];
    //
    // If you are using Facebook, uncomment and fill in with your Facebook App Id:
    // [PFFacebookUtils initializeWithApplicationId:@"your_facebook_app_id"];
    // ****************************************************************************
    
    //[PFUser enableAutomaticUser];
    
    [PFFacebookUtils initializeWithApplicationId:@"442806002472337"];
    [PFTwitterUtils initializeWithConsumerKey:@"your_twitter_consumer_key" consumerSecret:@"your_twitter_consumer_secret"];
    
    // Set defualt ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    LoginViewController *loginViewController = (LoginViewController *)[window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    
    self.window.rootViewController = loginViewController;
    
	[self.window makeKeyAndVisible];
    
    return YES;
}

// Facebook oauth callback
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

@end
