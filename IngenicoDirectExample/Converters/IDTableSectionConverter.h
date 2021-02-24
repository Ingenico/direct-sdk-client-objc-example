//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDPaymentProductsTableSection.h"
#import <IngenicoDirectSDK/IDBasicPaymentProducts.h>
#import <IngenicoDirectSDK/IDPaymentItems.h>

@interface IDTableSectionConverter : NSObject

+ (IDPaymentProductsTableSection *)paymentProductsTableSectionFromAccountsOnFile:(NSArray *)accountsOnFile paymentItems:(IDPaymentItems *)paymentItems;
+ (IDPaymentProductsTableSection *)paymentProductsTableSectionFromPaymentItems:(IDPaymentItems *)paymentItems;

@end
