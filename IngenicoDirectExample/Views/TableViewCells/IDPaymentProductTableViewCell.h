//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"

@interface IDPaymentProductTableViewCell : IDTableViewCell

+ (NSString *)reuseIdentifier;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *logo;
@property (assign, nonatomic) BOOL shouldHaveMaximalWidth;
@property (strong, nonatomic) UIColor *limitedBackgroundColor;

@end
