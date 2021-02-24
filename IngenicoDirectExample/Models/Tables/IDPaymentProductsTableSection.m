//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDPaymentProductsTableSection.h"

@implementation IDPaymentProductsTableSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rows = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
