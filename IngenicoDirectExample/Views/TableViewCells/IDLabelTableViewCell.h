//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"
#import "IDLabel.h"

@class IDFormRowLabel;

@interface IDLabelTableViewCell : IDTableViewCell

@property (assign, nonatomic, getter=isBold) BOOL bold;

+ (CGSize)cellSizeForWidth:(CGFloat)width forFormRow:(IDFormRowLabel *)label;
+ (NSString *)reuseIdentifier;

- (NSString *)label;
- (void)setLabel:(NSString *)label;

@end
