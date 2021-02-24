//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"

@class IDSeparatorView;

@interface IDSeparatorTableViewCell : IDTableViewCell

@property (nonatomic, strong) NSString *separatorText;
@property (nonatomic, strong) IDSeparatorView *view;

+ (NSString *)reuseIdentifier;

@end
