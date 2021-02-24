//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <XCTest/XCTest.h>
#import "IDBasicPaymentProducts.h"
#import "IDBasicPaymentProductsConverter.h"
#import "IDPaymentProductsTableSection.h"
#import "IDPaymentProductsTableRow.h"
#import "IDTableSectionConverter.h"
#import "IDStringFormatter.h"
#import "IDAccountOnFile.h"
#import "IDPaymentItems.h"

@interface IDTableSectionConverterTestCase : XCTestCase

@property (strong, nonatomic) IDBasicPaymentProductsConverter *paymentProductsConverter;
@property (strong, nonatomic) IDStringFormatter *stringFormatter;

@end

@implementation IDTableSectionConverterTestCase

- (void)setUp
{
    [super setUp];
    self.paymentProductsConverter = [[IDBasicPaymentProductsConverter alloc] init];
    self.stringFormatter = [[IDStringFormatter alloc] init];
}

- (void)testPaymentProductsTableSectionFromAccountsOnFile
{
    NSString *paymentProductsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProducts" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductsData = [fileManager contentsAtPath:paymentProductsPath];
    NSDictionary *paymentProductsJSON = [NSJSONSerialization JSONObjectWithData:paymentProductsData options:0 error:NULL];
    IDBasicPaymentProducts *paymentProducts = [self.paymentProductsConverter paymentProductsFromJSON:[paymentProductsJSON objectForKey:@"paymentProducts"]];
    NSArray *accountsOnFile = [paymentProducts accountsOnFile];
    for (IDAccountOnFile *accountOnFile in accountsOnFile) {
        accountOnFile.stringFormatter = self.stringFormatter;
    }

    IDPaymentItems *items = [[IDPaymentItems alloc] init];
    items.paymentItems = paymentProducts.paymentProducts;
    IDPaymentProductsTableSection *tableSection = [IDTableSectionConverter paymentProductsTableSectionFromAccountsOnFile:accountsOnFile paymentItems:items];
    IDPaymentProductsTableRow *row = tableSection.rows[0];
    XCTAssertTrue([row.name isEqualToString:@"**** **** **** 7988 Rob"] == YES, @"Unexpected title of table section");
}

@end
