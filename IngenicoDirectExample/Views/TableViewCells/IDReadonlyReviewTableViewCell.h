//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"

@interface IDReadonlyReviewTableViewCell : IDTableViewCell

@property (nonatomic, retain) NSDictionary<NSString *, NSString *> *data;

+ (NSString *)reuseIdentifier;
+ (CGFloat)cellHeightForData:(NSDictionary<NSString *, NSString *> *)data inWidth:(CGFloat)width;

@end
