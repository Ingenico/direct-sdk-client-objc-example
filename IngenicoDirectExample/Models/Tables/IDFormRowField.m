//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDFormRowField.h"

@implementation IDFormRowField

- (instancetype _Nonnull)initWithText: (nonnull NSString *)text placeholder: (nonnull NSString *)placeholder keyboardType: (UIKeyboardType)keyboardType isSecure: (BOOL)isSecure {
    self = [super init];
    
    if (self) {
        self.text = text;
        self.placeholder = placeholder;
        self.keyboardType = keyboardType;
        self.isSecure = isSecure;
    }
    
    return self;
}

@end
