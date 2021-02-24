//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDFormRow.h"
#import "IDSwitch.h"
#import "IDFormRowWithInfoButton.h"

@interface IDFormRowSwitch : IDFormRowWithInfoButton

@property (nonatomic, assign) BOOL isOn;
@property (strong, nonatomic) NSAttributedString * _Nonnull title;
@property (strong, nonatomic) id _Nullable target;
@property (assign, nonatomic) SEL _Nullable action;
@property (strong, nonatomic) IDPaymentProductField * _Nullable field;

- (instancetype _Nonnull)initWithTitle: (nonnull NSString *) title isOn: (BOOL)isOn target: (nonnull id)target action: (nonnull SEL)action;
- (instancetype _Nonnull )initWithAttributedTitle: (nonnull NSAttributedString*) title isOn: (BOOL)isOn target: (nullable id)target action: (nullable SEL)action paymentProductField:(nullable IDPaymentProductField *)field;

@end
