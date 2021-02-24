//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDFormRowField.h"
#import "IDFormRowWithInfoButton.h"
#import "IDTextField.h"
#import <IngenicoDirectSDK/IDPaymentProductField.h>

@interface IDFormRowTextField : IDFormRowWithInfoButton

@property (strong, nonatomic) IDPaymentProductField * _Nonnull paymentProductField;
@property (strong, nonatomic) UIImage * _Nullable logo;
@property (strong, nonatomic) IDFormRowField * _Nonnull field;

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull IDPaymentProductField *)paymentProductField field: (nonnull IDFormRowField*)field;

@end
