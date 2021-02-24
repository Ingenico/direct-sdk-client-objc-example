//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDFormRowList.h"

@implementation IDFormRowList

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull IDPaymentProductField *)paymentProductField {
    self = [super init];
    
    if (self) {
        self.items = [[NSMutableArray alloc]init];
        self.paymentProductField = paymentProductField;
    }
    
    return self;
}

@end
