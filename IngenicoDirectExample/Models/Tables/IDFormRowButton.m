//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDFormRowButton.h"

@implementation IDFormRowButton

- (instancetype _Nonnull)initWithTitle: (nonnull NSString *) title target: (nonnull id)target action: (nonnull SEL)action {
    self = [super init];
    
    if (self) {
        self.buttonType = IDButtonTypePrimary;
        self.title = title;
        self.target = target;
        self.action = action;
    }
    
    return self;
}


@end
