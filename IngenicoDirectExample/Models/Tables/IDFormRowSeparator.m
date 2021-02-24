//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDFormRowSeparator.h"

@implementation IDFormRowSeparator

- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        _text = text;
    }
    return self;
}

@end
