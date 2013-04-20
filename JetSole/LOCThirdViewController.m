//
//  LOCFirstViewController.m
//  JetSole
//
//  Created by Nelson Gedeon on 2/7/13.
//  Copyright (c) 2013 JetSole. All rights reserved.
//

#import "LOCThirdViewController.h"
#import <Parse/Parse.h>

@interface LOCThirdViewController ()

@end

@implementation LOCThirdViewController
@synthesize userName = _userName;
@synthesize nameFieldOutLet;
@synthesize label;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setNameFieldOutLet:nil];
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.nameFieldOutLet) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (IBAction)changeGreeting:(id)sender {
    
    self.userName = self.nameFieldOutLet.text;
    
    NSString *displayName = self.userName;
    
    if ([displayName length] == 0) {
        displayName = @"You didn't enter in a name";
    }
    
    //NSString *greeting = [[NSString alloc] initWithFormat:@"Hola, %@!", displayName];
    
    
    //Code here to find the shop name based on what was entered and retrive from parse
    //PFQuery *query = [PFQuery queryWithClassName:@"Stores"];
    //PFObject *store = [query getObjectWithId:@"rX8jwpVUTZ"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Stores"];
    [query whereKey:@"City" equalTo:displayName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded with no blocks now lets check if the city returned results.
            NSLog(@"Successfully retrieved %d Stores.", objects.count);
            if(objects.count > 0){
                //Something Return
                NSArray* storeArray = [query findObjects];
                PFObject *store = storeArray[0];
                self.label.text = [store objectForKey:@"Name"];
            }else{
                self.label.text = @"City Not Found";
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    
    //NSString *storeName = [store objectForKey:@"Name"];
    //PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //[testObject setObject:@"TeaLoungeTest" forKey:@"foo"];
    //[testObject save];
    
}
@end
