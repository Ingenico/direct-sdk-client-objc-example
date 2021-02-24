//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDButton.h"
#import "IDAppConstants.h"

@implementation IDButton

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.type = IDButtonTypePrimary;
        self.layer.cornerRadius = 5;
    }
    
    return self;
}


- (void)setType:(IDButtonType)type {
    _type = type;
    switch (type) {
        case IDButtonTypePrimary:
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.backgroundColor = kIDPrimaryColor;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
            break;
        case IDButtonTypeSecondary:
            [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.backgroundColor = [UIColor clearColor];
            self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
            break;
        case IDButtonTypeDestructive:
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.backgroundColor = kIDDestructiveColor;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
            break;

    }
}

- (void)setEnabled:(BOOL)enabled {
    super.enabled = enabled;
    self.alpha = enabled ? 1 : 0.3;
}

@end
