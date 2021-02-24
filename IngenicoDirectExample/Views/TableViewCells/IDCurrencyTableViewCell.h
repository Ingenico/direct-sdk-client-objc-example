//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"
#import "IDIntegerTextField.h"
#import "IDFractionalTextField.h"
#import "IDFormRowField.h"

@interface IDCurrencyTableViewCell : IDTableViewCell {
    BOOL _readonly;
}

+ (NSString *)reuseIdentifier;

@property (strong, nonatomic) IDFormRowField * integerField;
@property (strong, nonatomic) IDFormRowField * fractionalField;
@property (strong, nonatomic) NSString * currencyCode;
@property (assign, nonatomic) BOOL readonly;
@property(nonatomic,weak) id<UITextFieldDelegate> delegate;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setIntegerField:(IDFormRowField *)integerField;
- (void)setFractionalField:(IDFormRowField *)fractionalField;

@end
