//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDTableSectionConverter.h"

#import "IDTableSectionConverter.h"
#import "IDPaymentProductsTableRow.h"

#import <IngenicoDirectSDK/IDSDKConstants.h>
#import <IngenicoDirectSDK/IDPaymentItems.h>
#import <IngenicoDirectSDK/IDBasicPaymentProductGroup.h>

@implementation IDTableSectionConverter

+ (IDPaymentProductsTableSection *)paymentProductsTableSectionFromAccountsOnFile:(NSArray *)accountsOnFile paymentItems:(IDPaymentItems *)paymentItems
{
    IDPaymentProductsTableSection *section = [[IDPaymentProductsTableSection alloc] init];
    section.type = IDAccountOnFileType;
    for (IDAccountOnFile *accountOnFile in accountsOnFile) {
        id<IDBasicPaymentItem> product = [paymentItems paymentItemWithIdentifier:accountOnFile.paymentProductIdentifier];
        IDPaymentProductsTableRow *row = [[IDPaymentProductsTableRow alloc] init];
        NSString *displayName = [accountOnFile label];
        row.name = displayName;
        row.accountOnFileIdentifier = accountOnFile.identifier;
        row.paymentProductIdentifier = accountOnFile.paymentProductIdentifier;
        row.logo = product.displayHints.logoImage;
        [section.rows addObject:row];
    }
    return section;
}

+ (IDPaymentProductsTableSection *)paymentProductsTableSectionFromPaymentItems:(IDPaymentItems *)paymentItems
{
    NSBundle *sdkBundle = [NSBundle bundleWithPath:kIDSDKBundlePath];
    
    IDPaymentProductsTableSection *section = [[IDPaymentProductsTableSection alloc] init];
    for (NSObject<IDPaymentItem> *paymentItem in paymentItems.paymentItems) {
        section.type = IDPaymentProductType;
        IDPaymentProductsTableRow *row = [[IDPaymentProductsTableRow alloc] init];
        NSString *paymentProductKey = [self localizationKeyWithPaymentItem:paymentItem];
        NSString *paymentProductValue = NSLocalizedStringFromTableInBundle(paymentProductKey, kIDSDKLocalizable, sdkBundle, nil);
        row.name = paymentProductValue;
        row.accountOnFileIdentifier = @"";
        row.paymentProductIdentifier = paymentItem.identifier;
        row.logo = paymentItem.displayHints.logoImage;
        [section.rows addObject:row];
    }
    return section;
}

+ (NSString *)localizationKeyWithPaymentItem:(NSObject<IDBasicPaymentItem> *)paymentItem {
    if ([paymentItem isKindOfClass:[IDBasicPaymentProduct class]]) {
        return [NSString stringWithFormat:@"gc.general.paymentProducts.%@.name", paymentItem.identifier];
    }
    else if ([paymentItem isKindOfClass:[IDBasicPaymentProductGroup class]]) {
        return [NSString stringWithFormat:@"gc.general.paymentProductGroups.%@.name", paymentItem.identifier];
    }
    else {
        return @"";
    }
}

@end
