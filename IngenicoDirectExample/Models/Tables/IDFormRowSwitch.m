//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDFormRowSwitch.h"

@implementation IDFormRowSwitch

- (instancetype)initWithAttributedTitle: (nonnull NSAttributedString*) title isOn: (BOOL)isOn target: (nullable id)target action: (nullable SEL)action paymentProductField:(nullable IDPaymentProductField *)field{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.isOn = isOn;
        self.target = target;
        self.action = action;
        self.field = field;
    }
    
    return self;

}

- (instancetype)initWithTitle: (nonnull NSString*) title isOn: (BOOL)isOn target: (nonnull id)target action: (nonnull SEL)action {
    return [self initWithAttributedTitle:[[NSAttributedString alloc] initWithString:title] isOn:isOn target:target action:action paymentProductField:nil];
}

@end
