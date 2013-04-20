//
//  HomeViewController.m
//  JetSole
//
//  Created by Nelson Gedeon on 2/7/13.
//  Copyright (c) 2013 JetSole. All rights reserved.
//

#import "HomeViewController.h"
#import "StoreTableViewController.h"
#import "DealTableViewController.h"
#import "BrandTableViewController.h"
#import <Parse/Parse.h>
#import "Store.h"

@interface HomeViewController ()

@property (nonatomic, strong) StoreTableViewController *storeTableViewController;
@property (nonatomic, strong) DealTableViewController *dealTableViewController;
@property (nonatomic, strong) BrandTableViewController *brandTableViewController;

@end

@implementation HomeViewController

@synthesize storeTableViewController;
@synthesize dealTableViewController;
@synthesize brandTableViewController;

//{
//
//NSArray *storeNamesArray;
//
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dealTableViewController = [[DealTableViewController alloc] initWithStyle:UITableViewStylePlain];
	[self addChildViewController:self.dealTableViewController];
	self.dealTableViewController.view.frame = CGRectMake(0, 50, 320, 400);
	[self.view addSubview:self.dealTableViewController.view];
    
//	storeNamesArray = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
//    // Do any additional setup after loading the view, typically from a nib.
//    
////    PFQuery *query = [PFQuery queryWithClassName:@"Stores"];
////    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
////		if (error) {
////			NSLog(@"error in geo query!"); // todo why is this ever happening?
////		} else {
////			// We need to make new post objects from objects,
////			// and update allPosts and the map to reflect this new array.
////			// But we don't want to remove all annotations from the mapview blindly,
////			// so let's do some work to figure out what's new and what needs removing.
////            //NSString *storeArray[4];
////            // The find succeeded with no blocks now lets check if the city returned results.
////            NSLog(@"Successfully retrieved %d Stores.", objects.count);
////            //Something Return now loop thru and add the objects to the array
////            storeNamesArray = objects;
////            int num = 0;
////            for(PFObject *object in objects){
////                NSLog(@"Adding Store To Table.");
////                NSString *storeName;
////                Store *newStore = [[Store alloc] initWithPFObject:object];
////                storeName = newStore.title;
////                NSLog(@"%@",storeName);
////                storeArray[num] = @"Name";
////                num = num+1;
////            }
////            
////            
////            
////        }
////    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [storeNamesArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"StoreCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    
//    cell.textLabel.text = [storeNamesArray objectAtIndex:indexPath.row];
//    return cell;
//}


//will be used to switch between the different tables we display in the home view
- (IBAction)homeTableController:(id)sender {
    switch (((UISegmentedControl *)sender).selectedSegmentIndex)
    {
        case 0:
        {
            //add code show the correct table
            NSLog(@"Deals Picked");
            self.dealTableViewController = [[DealTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self addChildViewController:self.dealTableViewController];
            self.dealTableViewController.view.frame = CGRectMake(0, 50, 320, 400);
            [self.view addSubview:self.dealTableViewController.view];
            break;
        }
        case 1:
        {
            //add code to show the correct table
            NSLog(@"Stores Picked");
            self.storeTableViewController = [[StoreTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self addChildViewController:self.storeTableViewController];
            self.storeTableViewController.view.frame = CGRectMake(0, 50, 320, 400);
            [self.view addSubview:self.storeTableViewController.view];
            break;
        }
        case 2:
        {
            //add code to show the correct table
            NSLog(@"Brands Picked");
            self.brandTableViewController = [[BrandTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self addChildViewController:self.brandTableViewController];
            self.brandTableViewController.view.frame = CGRectMake(0, 50, 320, 400);
            [self.view addSubview:self.brandTableViewController.view];
            break;
        }
    }
}

@end
