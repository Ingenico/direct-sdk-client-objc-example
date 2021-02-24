//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"
#import "IDFormRowTooltip.h"

@interface IDTooltipTableViewCell : IDTableViewCell

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) UIImage *tooltipImage;

+ (CGSize)cellSizeForWidth:(CGFloat)width forFormRow:(IDFormRowTooltip *)label;
+ (NSString *)reuseIdentifier;

@end
