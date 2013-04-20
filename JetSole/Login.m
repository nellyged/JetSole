#import "Login.h"
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"
#import "HomeViewController.h"
#import "LOCAppDelegate.h"
#import "Utility.h"

@implementation LoginViewController

@synthesize welcomeLabel;

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    if ([PFUser currentUser]) {
        [welcomeLabel setText:[NSString stringWithFormat:@"Welcome %@!",[[PFUser currentUser] username]]];
    } else {
        [welcomeLabel setText:@"Not logged in"];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Create the log in view controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self];
    
    //[logInViewController.logInView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    //Login buttons seen
    [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
    [logInViewController setFields:PFLogInFieldsDefault | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsDismissButton];
    
    //Log and dismiss setup
    [logInViewController.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo2.png"]]];
    [logInViewController.logInView.dismissButton setHidden:YES];
    [logInViewController.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
    
    // Set field text color
    //[logInViewController.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    //[logInViewController.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    //Set field box color
    //[logInViewController.logInView.usernameField setBackgroundColor:[UIColor colorWithRed:190 green:190 blue:190 alpha:190]];
    //[logInViewController.logInView.passwordField setBackgroundColor:[UIColor colorWithRed:190 green:190 blue:190 alpha:190]];
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:NO completion:NULL];
    
}

#pragma mark - Logout button handler

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    // user has logged in - we need to fetch all of their Facebook data before we let them in
    if (![self shouldProceedToMainInterface:user]) {
        NSLog(@"User Logged In");
        //self.hud = [MBProgressHUD showHUDAddedTo:self.navController.presentedViewController.view animated:YES];
        //[self.hud setLabelText:@"Loading"];
        //[self.hud setDimBackground:YES];
        PF_FBRequest *request = [PF_FBRequest requestForGraphPath:@"me/?fields=name,picture"];
        [request setDelegate:self];
        [request startWithCompletionHandler:NULL];
        
        // Subscribe to private push channel
        if (user) {
            NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
            [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
            [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:@"channels"];
            [[PFInstallation currentInstallation] saveEventually];
            [user setObject:privateChannelName forKey:@"channel"];
        }
    
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    //Determine if the user logged in using FB/Twitter or Direct.Based on that we determine if the user is in
    NSLog(@"User Logged In");
    //Present the HomeViewController Since User Logged
    LOCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    HomeViewController *homeViewController = (HomeViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TabController"];
    appDelegate.window.rootViewController = homeViewController;
    
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handledActionURL = [self handleActionURL:url];
    
    if (handledActionURL) {
        return YES;
    }
    
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)shouldProceedToMainInterface:(PFUser *)user {
    if ([Utility userHasValidFacebookData:[PFUser currentUser]]) {
        NSLog(@"User has valid Facebook data, granting permission to use app.");
        //[MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
        //[self presentTabBarController];
        //[self.navController dismissModalViewControllerAnimated:YES];
        return YES;
    }
    
    return NO;
}

- (BOOL)handleActionURL:(NSURL *)url {
//    if ([[url host] isEqualToString:kPAPLaunchURLHostTakePicture]) {
//        if ([PFUser currentUser]) {
//            return [self.tabBarController shouldPresentPhotoCaptureController];
//        }
//    }
    
    return NO;
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


@end
