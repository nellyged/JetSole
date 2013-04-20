//
//  HomeViewController.h
//  JetSole
//
//  Created by Nelson Gedeon on 2/7/13.
//  Copyright (c) 2013 JetSole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)homeTableController:(id)sender;

@end

@protocol HomeViewControllerHighlight <NSObject>

- (void)highlightCellForPost:(Store *)store;
- (void)unhighlightCellForPost:(Store *)store;

@end