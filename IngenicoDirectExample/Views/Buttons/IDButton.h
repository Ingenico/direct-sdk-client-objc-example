//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

typedef enum  {
    IDButtonTypePrimary = 0,
    IDButtonTypeSecondary = 1,
    IDButtonTypeDestructive = 2
} IDButtonType;

@interface IDButton : UIButton

@property (assign, nonatomic) IDButtonType type;

@end
