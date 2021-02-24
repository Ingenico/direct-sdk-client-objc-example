//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDFormRowCurrency.h"

@implementation IDFormRowCurrency

- (instancetype)initWithPaymentProductField:(IDPaymentProductField *)paymentProductField andIntegerField:(IDFormRowField *)integerField andFractionalField:(IDFormRowField *)fractionalField
{
    self = [super init];
    if (self) {
        self.paymentProductField = paymentProductField;
        self.integerField = integerField;
        self.fractionalField = fractionalField;
    }
    return self;
}

@end
