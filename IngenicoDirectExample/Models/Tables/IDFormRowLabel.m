//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDFormRowLabel.h"

@implementation IDFormRowLabel

- (instancetype _Nonnull)initWithText:(nonnull NSString *)text {
    self = [super init];
    
    if (self) {
        self.text = text;
    }
    
    return self;
}

@end
