//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDFormRow.h"
#import <IngenicoDirectSDK/IDPaymentProductField.h>

@interface IDFormRowTooltip : IDFormRow

@property (strong, nonatomic) IDPaymentProductField *paymentProductField;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *text;

@end
