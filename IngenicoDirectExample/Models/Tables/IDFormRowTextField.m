//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDFormRowTextField.h"

@implementation IDFormRowTextField

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull IDPaymentProductField *)paymentProductField field: (nonnull IDFormRowField*)field {
    self = [super init];
    
    if (self) {
        self.paymentProductField = paymentProductField;
        self.field = field;
    }
    
    return self;
}

@end
