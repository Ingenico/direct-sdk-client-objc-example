//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#ifndef IDPaymentProductSelectionTarget_h
#define IDPaymentProductSelectionTarget_h

#import "IDPaymentType.h"

#import <IngenicoDirectSDK/IDBasicPaymentProduct.h>
#import <IngenicoDirectSDK/IDAccountOnFile.h>

@protocol IDPaymentItem;

@protocol IDPaymentProductSelectionTarget <NSObject>

- (void)didSelectPaymentItem:(NSObject <IDBasicPaymentItem> *)paymentItem accountOnFile:(IDAccountOnFile *)accountOnFile;

@end

#endif /* IDPaymentProductSelectionTarget_h */
