//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDViewFactory.h"
#import "IDFormRowErrorMessage.h"

#import <IngenicoDirectSDK/IDPaymentRequest.h>
#import <IngenicoDirectSDK/IDValidationError.h>

@class IDIINDetailsResponse;
@class IDPaymentProductInputData;

@interface IDFormRowsConverter : NSObject

+ (NSString *)errorMessageForError:(IDValidationError *)error withCurrency:(BOOL)forCurrency;

- (NSMutableArray *)formRowsFromInputData:(IDPaymentProductInputData *)inputData viewFactory:(IDViewFactory *)viewFactory confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts;

@end
