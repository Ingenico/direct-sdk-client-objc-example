//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDAppConstants.h"
#import "IDPaymentProductsViewController.h"
#import "IDPaymentProductTableViewCell.h"
#import "IDPaymentProductsTableSection.h"
#import "IDPaymentProductsTableRow.h"
#import "IDTableSectionConverter.h"
#import "IDSummaryTableHeaderView.h"
#import "IDMerchantLogoImageView.h"

#import <IngenicoDirectSDK/IDPaymentItems.h>
#import <IngenicoDirectSDK/IDSDKConstants.h>

@interface IDPaymentProductsViewController ()

@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) IDSummaryTableHeaderView *header;
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation IDPaymentProductsViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sdkBundle = [NSBundle bundleWithPath:kIDSDKBundlePath];

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.titleView = [[IDMerchantLogoImageView alloc] init];

    [self initializeHeader];
    
    self.sections = [[NSMutableArray alloc] init];
    //TODO: Accounts on file
    if ([self.paymentItems hasAccountsOnFile] == YES) {
        IDPaymentProductsTableSection *accountsSection =
        [IDTableSectionConverter paymentProductsTableSectionFromAccountsOnFile:[self.paymentItems accountsOnFile] paymentItems:self.paymentItems];
        accountsSection.title = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductSelection.accountsOnFileTitle", kIDSDKLocalizable, self.sdkBundle, @"Title of the section that displays stored payment products.");
        [self.sections addObject:accountsSection];
    }
    IDPaymentProductsTableSection *productsSection = [IDTableSectionConverter paymentProductsTableSectionFromPaymentItems:self.paymentItems];
    productsSection.title = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductSelection.pageTitle", kIDSDKLocalizable, self.sdkBundle, @"Title of the section that shows all available payment products.");
    [self.sections addObject:productsSection];
    
    [self.tableView registerClass:[IDPaymentProductTableViewCell class] forCellReuseIdentifier:[IDPaymentProductTableViewCell reuseIdentifier]];
}

- (void)initializeHeader {
    self.header = (IDSummaryTableHeaderView *)[self.viewFactory tableHeaderViewWithType:IDSummaryTableHeaderViewType frame:CGRectMake(0, 0, self.tableView.frame.size.width, 70)];
    self.header.summary = [NSString stringWithFormat:@"%@:", NSLocalizedStringFromTableInBundle(@"gc.app.general.shoppingCart.total", kIDSDKLocalizable, self.sdkBundle, @"Description of the amount header.")];
    NSNumber *amountAsNumber = [[NSNumber alloc] initWithFloat:self.amount / 100.0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:self.currencyCode];
    NSString *amountAsString = [numberFormatter stringFromNumber:amountAsNumber];
    self.header.amount = amountAsString;
    self.header.securePayment = NSLocalizedStringFromTableInBundle(@"gc.app.general.securePaymentText", kIDSDKLocalizable, self.sdkBundle, @"Text indicating that a secure payment method is used.");
    self.tableView.tableHeaderView = self.header;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    IDPaymentProductsTableSection *tableSection = self.sections[section];
    return tableSection.rows.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    IDPaymentProductsTableSection *tableSection = self.sections[section];
    return tableSection.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDPaymentProductTableViewCell *cell = (IDPaymentProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDPaymentProductTableViewCell reuseIdentifier]];
    
    IDPaymentProductsTableSection *section = self.sections[indexPath.section];
    IDPaymentProductsTableRow *row = section.rows[indexPath.row];
    cell.name = row.name;
    cell.logo = row.logo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IDPaymentProductsTableSection *section = self.sections[indexPath.section];
    IDPaymentProductsTableRow *row = section.rows[indexPath.row];
    NSObject<IDBasicPaymentItem> *paymentItem = [self.paymentItems paymentItemWithIdentifier:row.paymentProductIdentifier];
    if (section.type == IDAccountOnFileType) {
        IDBasicPaymentProduct *product = (IDBasicPaymentProduct *) paymentItem;
        IDAccountOnFile *accountOnFile = [product accountOnFileWithIdentifier:row.accountOnFileIdentifier];
        [self.target didSelectPaymentItem:product accountOnFile:accountOnFile];
    }
    else {
        [self.target didSelectPaymentItem:paymentItem accountOnFile:nil];
    }
}

@end
