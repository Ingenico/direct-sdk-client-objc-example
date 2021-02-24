//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"
#import "IDTextField.h"
#import "IDFormRowField.h"

@interface IDTextFieldTableViewCell : IDTableViewCell

@property (strong, nonatomic) IDFormRowField *field;
@property (assign, nonatomic) BOOL readonly;

+ (NSString *)reuseIdentifier;

- (UIView *)rightView;
- (void)setRightView:(UIView *)view;

- (NSString *)error;
- (void)setError:(NSString *)error;

- (NSObject<UITextFieldDelegate> *)delegate;
- (void)setDelegate:(NSObject<UITextFieldDelegate> *)delegate;

@end
