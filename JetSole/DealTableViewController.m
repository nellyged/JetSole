//
//  PAWWallPostsTableViewController.m
//  AnyWall
//
//  Created by Christopher Bowns on 2/6/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

static CGFloat const kPAWWallPostTableViewFontSize = 12.f;
static CGFloat const kPAWWallPostTableViewCellWidth = 310.f; // subject to change.

// Multiline cells:
static CGFloat const kPAWWallPostTableViewCellPadding = 14.f;
static CGFloat const kPAWWallPostTableViewCellUsernameHeight = 15.f;

static NSUInteger const kPAWTableViewMainSection = 0;

#import "DealTableViewController.h"
#import "Deal.h"
#import "LOCAppDelegate.h"
#import "DealTableViewCell.h"
#import <Parse/Parse.h>
#import "PFProducts.h"


#define ROW_MARGIN 6.0f
#define ROW_HEIGHT 173.0f
#define PICKER_HEIGHT 216.0f
#define SIZE_BUTTON_TAG_OFFSET 1000

@interface DealTableViewController ()

// NSNotification callbacks
//- (void)distanceFilterDidChange:(NSNotification *)note;
//- (void)locationDidChange:(NSNotification *)note;
//- (void)postWasCreated:(NSNotification *)note;
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation DealTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.className = @"Deals";
        self.pullToRefreshEnabled = YES;
        [self.tableView registerClass:[DealTableViewCell class] forCellReuseIdentifier:@"Deals"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, PICKER_HEIGHT)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.hidden = YES;
    [self.view addSubview:self.pickerView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tableView.contentOffset = CGPointMake(0.0f, 0.0f);
    self.tableView.scrollEnabled = YES;
    self.pickerView.hidden = YES;
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // When any cell is selected, we dismiss the picker view.
    // If you want the cell selection to do some useful work, you can dismiss the picker view in the callback of a gesture recognizer, or implement an accessory control to the picker view that dismisses it.
    [UIView animateWithDuration:0.1f animations:^{
        self.pickerView.frame = CGRectMake(0.0f, self.pickerView.frame.origin.y + PICKER_HEIGHT, tableView.frame.size.width, PICKER_HEIGHT);
    } completion:^(BOOL finished) {
        self.pickerView.hidden = YES;
        // The table view's scrolling is disabled when the picker view is shown. Re-enable it here.
        self.tableView.scrollEnabled = YES;
        
        // Scroll the table to the bottom if the table view's current offset is beyond the maximum
        // allowable offset sot that it does not leave too much white space at the bottom.
        NSInteger numRows = [self tableView:tableView numberOfRowsInSection:0];
        CGFloat maxOffset = numRows * ROW_HEIGHT - self.view.frame.size.height + 36.0f;
        
        if (self.tableView.contentOffset.y > maxOffset) {
            [self.tableView setContentOffset:CGPointMake(0.0f, maxOffset) animated:YES];
        }
    }];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    //	[[NSNotificationCenter defaultCenter] removeObserver:self name:kPAWFilterDistanceChangeNotification object:nil];
    //	[[NSNotificationCenter defaultCenter] removeObserver:self name:kPAWLocationChangeNotification object:nil];
    //	[[NSNotificationCenter defaultCenter] removeObserver:self name:kPAWPostCreatedNotification object:nil];
}


#pragma mark - PFQueryTableViewController subclass methods

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

//// Override to customize what kind of query to perform on the class. The default is to query for
//// all objects ordered by createdAt descending.
//- (PFQuery *)queryForTable {
//	PFQuery *query = [PFQuery queryWithClassName:@"Deals"];
//    
//	// If no objects are loaded in memory, we look to the cache first to fill the table
//	// and then subsequently do a query against the network.
//    //	if ([self.objects count] == 0) {
//    //		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    //	}
//    //
//    //	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//    //        		if (error) {
//    //        			NSLog(@"error in geo query!"); // todo why is this ever happening?
//    //        		} else {
//    //        			// We need to make new post objects from objects,
//    //        			// and update allPosts and the map to reflect this new array.
//    //        			// But we don't want to remove all annotations from the mapview blindly,
//    //        			// so let's do some work to figure out what's new and what needs removing.
//    //                    //NSString *storeArray[4];
//    //                    // The find succeeded with no blocks now lets check if the city returned results.
//    //                    NSLog(@"Successfully retrieved %d Stores.", objects.count);
//    //                    //Something Return now loop thru and add the objects to the array
//    //                }
//    //            }];
//    
//    //[query whereKey:@"Title" containsString:@"R"];
//    NSLog(@"Successfully retrieved %d Deals.", query.countObjects);
//	return query;
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Deals";
    DealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[DealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    PFObject *deal = self.objects[indexPath.row];
    [cell configureDeal:deal];
    
    [cell.orderButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderButton.tag = indexPath.row;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForNextPageAtIndexPath:indexPath];
	cell.textLabel.font = [cell.textLabel.font fontWithSize:kPAWWallPostTableViewFontSize];
	return cell;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // We show all product names and "Select Size".
    return [PFProducts sizes].count + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return row == 0 ? NSLocalizedString(@"Select Size", @"Select Size") : [PFProducts sizes][row - 1];
}


#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UIButton *sizeButton = (UIButton *)[self.tableView viewWithTag:pickerView.tag + SIZE_BUTTON_TAG_OFFSET];
    NSString *title = [self pickerView:pickerView titleForRow:row forComponent:component];
    [sizeButton setTitle:title forState:UIControlStateNormal];
}


#pragma mark - Event handlers

//- (void)next:(UIButton *)button {
//    UIButton *sizeButton = (UIButton *)[self.tableView viewWithTag:(button.tag + SIZE_BUTTON_TAG_OFFSET)];
//    NSString *size = sizeButton ? [sizeButton titleForState:UIControlStateNormal] : nil;
//    
//    if (self.objects[button.tag][@"hasSize"] && [size isEqualToString:NSLocalizedString(@"Select Size", @"Select Size")]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Size", @"Missing Size") message:NSLocalizedString(@"Please select a size.", @"Please select a size.") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
//        [alertView show];
//    } else {
//        PFShippingViewController *shippingController = [[PFShippingViewController alloc] initWithProduct:self.objects[button.tag] size:size];
//        [self.navigationController pushViewController:shippingController animated:YES];
//    }
//}

- (void)selectSize:(id)sender {
    // This method shows the picker view for size selection.
    NSInteger row = ((UIButton *)sender).tag - SIZE_BUTTON_TAG_OFFSET;
    
    // Scroll to the row so that the picker view does not conceal any input.
    CGFloat offset = (row + 1) * ROW_HEIGHT - self.view.frame.size.height + PICKER_HEIGHT;
    if (offset < 0.0f) {
        offset = 0.0f;
    }
    
    [self.tableView setContentOffset:CGPointMake(0.0f, offset) animated:YES];
    
    // Disable scrolling in the table view so that user stays focused on the picker view.
    self.tableView.scrollEnabled = NO;
    
    // Assign the tag to the picker so that the picker knows which product's size it is selecting.
    self.pickerView.tag = row;
    
    self.pickerView.hidden = NO;
    
    // Default for picker view's initial selection.
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    
    self.pickerView.frame = CGRectMake(0.0f, offset + self.view.frame.size.height, self.tableView.frame.size.width, PICKER_HEIGHT);
    [UIView animateWithDuration:0.1f animations:^{
        self.pickerView.frame = CGRectMake(0.0f, offset + self.view.frame.size.height - PICKER_HEIGHT, self.tableView.frame.size.width, PICKER_HEIGHT);
    }];
}

- (void)openBrowser:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.parse.com/store"]];
}


@end
