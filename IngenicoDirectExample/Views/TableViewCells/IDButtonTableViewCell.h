//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"
#import "IDButton.h"

@interface IDButtonTableViewCell : IDTableViewCell

+ (NSString *)reuseIdentifier;

- (BOOL)isEnabled;
- (void)setIsEnabled:(BOOL)enabled;

- (IDButtonType)buttonType;
- (void)setButtonType:(IDButtonType)type;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (void)setClickTarget:(id)target action:(SEL)action;

@end
