//
//  PAWWallPostsTableViewController.h
//  AnyWall
//
//  Created by Christopher Bowns on 2/6/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HomeViewController.h"

@interface BrandTableViewController : PFQueryTableViewController <HomeViewControllerHighlight>

- (void)highlightCellForPost:(Store *)store;
- (void)unhighlightCellForPost:(Store *)store;

@end
