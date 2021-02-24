//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"

@class IDSwitchTableViewCell;
@class IDSwitch;

@protocol IDSwitchTableViewCellDelegate

- (void)switchChanged:(IDSwitch *)aSwitch;

@end

@interface IDSwitchTableViewCell : IDTableViewCell

@property (weak, nonatomic) NSObject<IDSwitchTableViewCellDelegate> *delegate;
@property (strong, nonatomic) NSString *errorMessage;
@property (assign, nonatomic, getter=isOn) BOOL on;
@property (assign, nonatomic) BOOL readonly;

+ (NSString *)reuseIdentifier;

- (NSAttributedString *)attributedTitle;
- (void)setAttributedTitle:(NSAttributedString *)attributedTitle;
- (void)setSwitchTarget:(id)target action:(SEL)action;

@end
