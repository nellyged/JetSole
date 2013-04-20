#import <Parse/Parse.h>

@interface LoginViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, PF_FBRequestDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;

- (IBAction)logOutButtonTapAction:(id)sender;
- (BOOL)handleActionURL:(NSURL *)url;

@end
