//
//  PFProductTableViewCell.h
//  Store
//
//  Created by Andrew Wang on 3/5/13.
//  Copyright (c) 2013 Parse Inc. All rights reserved.
//
#import <Parse/Parse.h>


@interface DealTableViewCell : PFTableViewCell

@property (nonatomic, strong) UIButton *sizeButton;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *nameLabel;

- (void)configureDeal:(PFObject *)deal;

@end
