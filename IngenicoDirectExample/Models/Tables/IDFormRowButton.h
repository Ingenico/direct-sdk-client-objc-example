//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDFormRow.h"
#import "IDButton.h"

@interface IDFormRowButton : IDFormRow

@property (strong, nonatomic) NSString * _Nonnull title;
@property (strong, nonatomic) id _Nonnull target;
@property (assign, nonatomic) IDButtonType buttonType;
@property (assign, nonatomic) SEL _Nonnull action;

- (instancetype _Nonnull)initWithTitle: (nonnull NSString *) title target: (nonnull id)target action: (nonnull SEL)action;

@end
