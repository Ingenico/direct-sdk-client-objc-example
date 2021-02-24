//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDFormRowField.h"
#import "IDFormRowWithInfoButton.h"
#import "IDIntegerTextField.h"
#import "IDFractionalTextField.h"
#import <IngenicoDirectSDK/IDPaymentProductField.h>

@interface IDFormRowCurrency : IDFormRowWithInfoButton

@property (strong, nonatomic) IDFormRowField *integerField;
@property (strong, nonatomic) IDFormRowField *fractionalField;
@property (strong, nonatomic) IDPaymentProductField *paymentProductField;

- (instancetype)initWithPaymentProductField:(IDPaymentProductField *)paymentProductField andIntegerField:(IDFormRowField *)integerField andFractionalField:(IDFormRowField *)fractionalField;

@end
