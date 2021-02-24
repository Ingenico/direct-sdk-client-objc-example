//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDFormRow.h"
#import "IDPickerView.h"
#import <IngenicoDirectSDK/IDValueMappingItem.h>
#import <IngenicoDirectSDK/IDPaymentProductField.h>

@interface IDFormRowList : IDFormRow

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull IDPaymentProductField *)paymentProductField;

@property (strong, nonatomic) NSMutableArray<IDValueMappingItem *> * _Nonnull items;
@property (nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) IDPaymentProductField * _Nonnull paymentProductField;

@end
