//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDAppConstants.h"
#import "IDPaymentProductViewController.h"
#import "IDFormRowsConverter.h"
#import "IDFormRow.h"
#import "IDFormRowDate.h"
#import "IDFormRowTextField.h"
#import "IDFormRowCurrency.h"
#import "IDFormRowSwitch.h"
#import "IDFormRowList.h"
#import "IDFormRowButton.h"
#import "IDFormRowLabel.h"
#import "IDFormRowErrorMessage.h"
#import "IDFormRowTooltip.h"
#import "IDTableViewCell.h"
#import "IDDatePickerTableViewCell.h"
#import "IDSummaryTableHeaderView.h"
#import "IDMerchantLogoImageView.h"
#import "IDFormRowCoBrandsSelection.h"
#import "IDFormRowCoBrandsExplanation.h"
#import "IDPaymentProductInputData.h"
#import "IDFormRowReadonlyReview.h"
#import "IDReadonlyReviewTableViewCell.h"
#import "IDPaymentProductsTableRow.h"
#import "IDCurrencyTableViewCell.h"
#import "IDLabelTableViewCell.h"
#import "IDButtonTableViewCell.h"
#import "IDCurrencyTableViewCell.h"
#import "IDErrorMessageTableViewCell.h"
#import "IDTooltipTableViewCell.h"
#import "IDPaymentProductTableViewCell.h"
#import "IDCOBrandsExplanationTableViewCell.h"

#import <IngenicoDirectSDK/IDSDKConstants.h>
#import <IngenicoDirectSDK/IDPaymentAmountOfMoney.h>
#import <IngenicoDirectSDK/IDIINDetail.h>

@interface IDPaymentProductViewController () <UITextFieldDelegate, IDDatePickerTableViewCellDelegate, IDSwitchTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *tooltipRows;
@property (nonatomic) BOOL rememberPaymentDetails;
@property (strong, nonatomic) IDSummaryTableHeaderView *header;
@property (strong, nonatomic) UITextPosition *cursorPositionInCreditCardNumberTextField;
@property (nonatomic) BOOL validation;
@property (nonatomic, strong) IDIINDetailsResponse *iinDetailsResponse;
@property (nonatomic, assign) BOOL coBrandsCollapsed;
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation IDPaymentProductViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        self.sdkBundle = [NSBundle bundleWithPath:kIDSDKBundlePath];
        self.context.forceBasicFlow = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setDelaysContentTouches:)] == YES) {
        self.tableView.delaysContentTouches = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [[IDMerchantLogoImageView alloc] init];
    
    self.rememberPaymentDetails = NO;
    
    [self initializeHeader];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)] == YES) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    self.tooltipRows = [[NSMutableArray alloc] init];
    self.validation = NO;
    self.confirmedPaymentProducts = [[NSMutableSet alloc] init];
    
    self.inputData = [IDPaymentProductInputData new];
    self.inputData.paymentItem = self.paymentItem;
    self.inputData.accountOnFile = self.accountOnFile;
    if ([self.paymentItem isKindOfClass:[IDPaymentProduct class]]) {
        IDPaymentProduct *product = (IDPaymentProduct *) self.paymentItem;
        [self.confirmedPaymentProducts addObject:product.identifier];
        self.initialPaymentProduct = product;
    }
    
    [self initializeFormRows];
    [self addExtraRows];
    
    self.switching = NO;
    self.coBrandsCollapsed = YES;
    
    [self registerReuseIdentifiers];
}

- (void)registerReuseIdentifiers {
    [self.tableView registerClass:[IDTextFieldTableViewCell class] forCellReuseIdentifier:[IDTextFieldTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDButtonTableViewCell class] forCellReuseIdentifier:[IDButtonTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDCurrencyTableViewCell class] forCellReuseIdentifier:[IDCurrencyTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDSwitchTableViewCell class] forCellReuseIdentifier:[IDSwitchTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDDatePickerTableViewCell class] forCellReuseIdentifier:[IDDatePickerTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDLabelTableViewCell class] forCellReuseIdentifier:[IDLabelTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDPickerViewTableViewCell class] forCellReuseIdentifier:[IDPickerViewTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDReadonlyReviewTableViewCell class] forCellReuseIdentifier:[IDReadonlyReviewTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDErrorMessageTableViewCell class] forCellReuseIdentifier:[IDErrorMessageTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDTooltipTableViewCell class] forCellReuseIdentifier:[IDTooltipTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDPaymentProductTableViewCell class] forCellReuseIdentifier:[IDPaymentProductTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDCoBrandsSelectionTableViewCell class] forCellReuseIdentifier:[IDCoBrandsSelectionTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[IDCOBrandsExplanationTableViewCell class] forCellReuseIdentifier:[IDCOBrandsExplanationTableViewCell reuseIdentifier]];
}

- (void)initializeHeader {
    NSBundle *sdkBundle = [NSBundle bundleWithPath:kIDSDKBundlePath];
    self.header = (IDSummaryTableHeaderView *)[self.viewFactory tableHeaderViewWithType:IDSummaryTableHeaderViewType frame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    self.header.summary = [NSString stringWithFormat:@"%@:", NSLocalizedStringFromTableInBundle(@"gc.app.general.shoppingCart.total", kIDSDKLocalizable, sdkBundle, @"Description of the amount header.")];
    NSNumber *amountAsNumber = [[NSNumber alloc] initWithFloat:self.amount / 100.0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:self.context.amountOfMoney.currencyCode];
    NSString *amountAsString = [numberFormatter stringFromNumber:amountAsNumber];
    self.header.amount = amountAsString;
    self.header.securePayment = NSLocalizedStringFromTableInBundle(@"gc.app.general.securePaymentText", kIDSDKLocalizable, sdkBundle, @"Text indicating that a secure payment method is used.");
    self.tableView.tableHeaderView = self.header;
}

- (void)addExtraRows {
    // Add remember me switch
      IDFormRowSwitch *switchFormRow = [[IDFormRowSwitch alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.rememberMe", kIDSDKLocalizable, self.sdkBundle, @"Explanation of the switch for remembering payment information.") isOn:self.rememberPaymentDetails target:self action: @selector(switchChanged:)];
    switchFormRow.isEnabled = false;
    [self.formRows addObject:switchFormRow];
    
    IDFormRowTooltip *switchFormRowTooltip = [IDFormRowTooltip new];
    switchFormRowTooltip.text = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.rememberMe.tooltip", kIDSDKLocalizable, self.sdkBundle, @"");
    switchFormRow.tooltip = switchFormRowTooltip;
    [self.formRows addObject:switchFormRowTooltip];
    
    // Add pay and cancel button
    NSString *payButtonTitle = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.payButton", kIDSDKLocalizable, self.sdkBundle, @"");
    IDFormRowButton *payButtonFormRow = [[IDFormRowButton alloc] initWithTitle: payButtonTitle target: self action: @selector(payButtonTapped)];
    payButtonFormRow.isEnabled = [self.paymentItem isKindOfClass:[IDPaymentProduct class]];
    [self.formRows addObject:payButtonFormRow];
    
    NSString *cancelButtonTitle = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.cancelButton", kIDSDKLocalizable, self.sdkBundle, @"");
    IDFormRowButton *cancelButtonFormRow = [[IDFormRowButton alloc] initWithTitle: cancelButtonTitle target: self action: @selector(cancelButtonTapped)];
    cancelButtonFormRow.buttonType = IDButtonTypeSecondary;
    cancelButtonFormRow.isEnabled = true;
    [self.formRows addObject:cancelButtonFormRow];
}

- (void)initializeFormRows {
    IDFormRowsConverter *mapper = [IDFormRowsConverter new];
    NSMutableArray *formRows = [mapper formRowsFromInputData: self.inputData viewFactory: self.viewFactory confirmedPaymentProducts: self.confirmedPaymentProducts];
    
    NSMutableArray *formRowsWithTooltip = [NSMutableArray new];
    for (IDFormRow *row in formRows) {
        [formRowsWithTooltip addObject:row];
        if (row != nil && [row isKindOfClass: [IDFormRowWithInfoButton class]]) {
            IDFormRowWithInfoButton *infoButtonRow = (IDFormRowWithInfoButton *)row;
            if (infoButtonRow.tooltip != nil) {
                IDFormRowTooltip *tooltipRow = infoButtonRow.tooltip;
                [formRowsWithTooltip addObject:tooltipRow];
            }
        }
    }
    
    self.formRows = formRowsWithTooltip;
}

- (void)addCoBrandFormsInFormRows:(NSMutableArray *)formRows iinDetailsResponse:(IDIINDetailsResponse *)iinDetailsResponse {
    NSMutableArray *coBrands = [NSMutableArray new];
    for (IDIINDetail *coBrand in iinDetailsResponse.coBrands) {
        if (coBrand.isAllowedInContext) {
            [coBrands addObject:coBrand.paymentProductId];
        }
    }
    if (coBrands.count > 1) {
        if (!self.coBrandsCollapsed) {
            NSBundle *sdkBundle = [NSBundle bundleWithPath:kIDSDKBundlePath];
            
            //Add explanation row
            IDFormRowCoBrandsExplanation *explanationRow = [IDFormRowCoBrandsExplanation new];
            [formRows addObject:explanationRow];
            
            //Add row for selection coBrands
            for (NSString *id in coBrands) {
                IDPaymentProductsTableRow *row = [[IDPaymentProductsTableRow alloc] init];
                row.paymentProductIdentifier = id;
                
                NSString *paymentProductKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.name", id];
                NSString *paymentProductValue = NSLocalizedStringFromTableInBundle(paymentProductKey, kIDSDKLocalizable, sdkBundle, nil);
                row.name = paymentProductValue;
                
                IDAssetManager *assetManager = [IDAssetManager new];
                UIImage *logo = [assetManager logoImageForPaymentItem:id];
                row.logo = logo;
                
                [formRows addObject:row];
            }
        }
        
        IDFormRowCoBrandsSelection *toggleCoBrandRow = [IDFormRowCoBrandsSelection new];
        [formRows addObject:toggleCoBrandRow];
    }
}

- (void)switchToPaymentProduct:(NSString *)paymentProductId {
    if (paymentProductId != nil) {
        [self.confirmedPaymentProducts addObject:paymentProductId];
    }
    if (paymentProductId == nil) {
        if ([self.confirmedPaymentProducts containsObject:self.paymentItem.identifier]) {
            [self.confirmedPaymentProducts removeObject:self.paymentItem.identifier];
        }
        [self updateFormRows];
    }
    else if ([paymentProductId isEqualToString:self.paymentItem.identifier]) {
        [self updateFormRows];
    }
    else if (self.switching == NO) {
        self.switching = YES;
        [self.session paymentProductWithId:paymentProductId context:self.context success:^(IDPaymentProduct *paymentProduct) {
            self.paymentItem = paymentProduct;
            self.inputData.paymentItem = paymentProduct;
            [self updateFormRows];
            self.switching = NO;
        } failure:^(NSError *error) {
        }];
    }
}

- (void)updateFormRows {
    [self.tableView beginUpdates];
    for (int i = 0; i < self.formRows.count; i++) {
        IDFormRow *row = self.formRows[i];
        if ([row isKindOfClass:[IDFormRowTextField class]]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell != nil && [cell isKindOfClass:[IDTextFieldTableViewCell class]]) {
                [self updateTextFieldCell: (IDTextFieldTableViewCell *)cell row: (IDFormRowTextField *)row];
            }
            
        } else if ([row isKindOfClass:[IDFormRowList class]]) {
            IDPickerViewTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [self updatePickerCell:cell row:row];
        } else if ([row isKindOfClass:[IDFormRowSwitch class]]) {
            if (((IDFormRowSwitch *)row).action == @selector(switchChanged:)) {
                row.isEnabled = self.paymentItem != nil && [self.paymentItem isKindOfClass:[IDBasicPaymentProduct class]] && ((IDBasicPaymentProduct *)self.paymentItem).allowsTokenization && self.accountOnFile == nil;
                continue;
            }
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell != nil && [cell isKindOfClass:[IDSwitchTableViewCell class]]) {
                [self updateSwitchCell:(IDSwitchTableViewCell *)cell row:(IDFormRowSwitch *)row];
            }
        } else if ([row isKindOfClass:[IDFormRowButton class]] &&  ((IDFormRowButton *)row).action == @selector(payButtonTapped)) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell != nil && [cell isKindOfClass:[IDButtonTableViewCell class]]) {
                row.isEnabled = [self.paymentItem isKindOfClass:[IDPaymentProduct class]];
                [self updateButtonCell: (IDButtonTableViewCell *)cell row: (IDFormRowButton *)row];
            }
        }
    }
    [self.tableView endUpdates];
    
}

- (void)updateTextFieldCell:(IDTextFieldTableViewCell *)cell row: (IDFormRowTextField *)row {
    // Add error messages for cells
    IDValidationError *error = [row.paymentProductField.errors firstObject];
    cell.delegate = self;
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    cell.field = row.field;
    cell.readonly = !row.isEnabled;
    if (error != nil) {
        cell.error = [IDFormRowsConverter errorMessageForError: error withCurrency: row.paymentProductField.displayHints.formElement.type == IDCurrencyType];
    } else {
        cell.error = nil;
    }
}

- (void)updateSwitchCell:(IDSwitchTableViewCell *)cell row: (IDFormRowSwitch *)row {
    // Add error messages for cells
    if (row.field == nil) {
        return;
    }
    IDValidationError *error = [row.field.errors firstObject];
    if (error != nil) {
        cell.errorMessage = [IDFormRowsConverter errorMessageForError: error withCurrency: NO];
    } else {
        cell.errorMessage = nil;
    }
}

- (void)updateButtonCell:(IDButtonTableViewCell *)cell row:(IDFormRowButton *)row {
    cell.isEnabled = row.isEnabled;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.formRows.count;
}

// TODO: indexPath argument is not used, maybe replace it with tableView
- (IDTableViewCell *)formRowCellForRow:(IDFormRow *)row atIndexPath:(NSIndexPath *)indexPath {
    Class class = [row class];
    IDTableViewCell *cell = nil;
    if (class == [IDFormRowTextField class]) {
        cell = [self cellForTextField:(IDFormRowTextField *)row tableView:self.tableView];
    } else if (class == [IDFormRowCurrency class]) {
        cell = [self cellForCurrency:(IDFormRowCurrency *) row tableView:self.tableView];
    } else if (class == [IDFormRowSwitch class]) {
        cell = [self cellForSwitch:(IDFormRowSwitch *)row tableView:self.tableView];
    } else if (class == [IDFormRowList class]) {
        cell = [self cellForList:(IDFormRowList *)row tableView:self.tableView];
    } else if (class == [IDFormRowButton class]) {
        cell = [self cellForButton:(IDFormRowButton *)row tableView:self.tableView];
    } else if (class == [IDFormRowLabel class]) {
        cell = [self cellForLabel:(IDFormRowLabel *)row tableView:self.tableView];
    } else if (class == [IDFormRowDate class]) {
        cell = [self cellForDatePicker:(IDFormRowDate *)row tableView:self.tableView];
    } else if (class == [IDFormRowErrorMessage class]) {
        cell = [self cellForErrorMessage:(IDFormRowErrorMessage *)row tableView:self.tableView];
    } else if (class == [IDFormRowTooltip class]) {
        cell = [self cellForTooltip:(IDFormRowTooltip *)row tableView:self.tableView];
    } else if (class == [IDFormRowCoBrandsSelection class]) {
        cell = [self cellForCoBrandsSelection:(IDFormRowCoBrandsSelection *)row tableView:self.tableView];
    } else if (class == [IDFormRowCoBrandsExplanation class]) {
        cell = [self cellForCoBrandsExplanation:(IDFormRowCoBrandsExplanation  *)row tableView:self.tableView];
    } else if (class == [IDPaymentProductsTableRow class]) {
        cell = [self cellForPaymentProduct:(IDPaymentProductsTableRow  *)row tableView:self.tableView];
    } else if (class == [IDFormRowReadonlyReview class]) {
        cell = [self cellForReadonlyReview:(IDFormRowReadonlyReview  *)row tableView:self.tableView];
    } else {
        [NSException raise:@"Invalid form row class" format:@"Form row class %@ is invalid", class];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDFormRow *row = self.formRows[indexPath.row];
    IDTableViewCell *cell = [self formRowCellForRow:row atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Helper methods for data source methods

- (IDReadonlyReviewTableViewCell *)cellForReadonlyReview:(IDFormRowReadonlyReview *)row tableView:(UITableView *)tableView {
    IDReadonlyReviewTableViewCell *cell = (IDReadonlyReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDReadonlyReviewTableViewCell reuseIdentifier]];
    
    cell.data = row.data;
    return cell;
}

- (IDTextFieldTableViewCell *)cellForTextField:(IDFormRowTextField *)row tableView:(UITableView *)tableView {
    IDTextFieldTableViewCell *cell = (IDTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDTextFieldTableViewCell reuseIdentifier]];
    
    cell.field = row.field;
    cell.delegate = self;
    cell.readonly = !row.isEnabled;
    IDValidationError *error = [row.paymentProductField.errors firstObject];
    if (error != nil && self.validation) {
        cell.error = [IDFormRowsConverter errorMessageForError: error withCurrency: row.paymentProductField.displayHints.formElement.type == IDCurrencyType];
    }
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    
    return cell;
}

- (IDDatePickerTableViewCell *)cellForDatePicker:(IDFormRowDate *)row tableView:(UITableView *)tableView {
    IDDatePickerTableViewCell *cell = (IDDatePickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDDatePickerTableViewCell reuseIdentifier]];
    
    cell.delegate = self;
    cell.readonly = !row.isEnabled;
    cell.date = row.date;
    return cell;
}

- (IDCurrencyTableViewCell *)cellForCurrency:(IDFormRowCurrency *)row tableView:(UITableView *)tableView {
    IDCurrencyTableViewCell *cell = (IDCurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDCurrencyTableViewCell reuseIdentifier]];
    cell.integerField = row.integerField;
    cell.delegate = self;
    cell.fractionalField = row.fractionalField;
    cell.readonly = !row.isEnabled;
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    return cell;
}

- (IDSwitchTableViewCell *)cellForSwitch:(IDFormRowSwitch *)row tableView:(UITableView *)tableView {
    IDSwitchTableViewCell *cell = (IDSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDSwitchTableViewCell reuseIdentifier]];
    cell.attributedTitle = row.title;
    [cell setSwitchTarget:row.target action:row.action];
    cell.on = row.isOn;
    cell.delegate = self;
    IDValidationError *error = [row.field.errors firstObject];
    if (error != nil && self.validation) {
        cell.errorMessage = [IDFormRowsConverter errorMessageForError: error withCurrency: 0];
    }
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    return cell;
}

- (IDPickerViewTableViewCell *)cellForList:(IDFormRowList *)row tableView:(UITableView *)tableView {
    IDPickerViewTableViewCell *cell = (IDPickerViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDPickerViewTableViewCell reuseIdentifier]];
    cell.items = row.items;
    cell.delegate = self;
    cell.dataSource = self;
    cell.selectedRow = row.selectedRow;
    cell.readonly = !row.isEnabled;
    return cell;
}

- (IDButtonTableViewCell *)cellForButton:(IDFormRowButton *)row tableView:(UITableView *)tableView {
    IDButtonTableViewCell *cell = (IDButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDButtonTableViewCell reuseIdentifier]];
    cell.buttonType = row.buttonType;
    cell.isEnabled = row.isEnabled;
    cell.title = row.title;
    [cell setClickTarget:row.target action:row.action];
    return cell;
}

- (IDLabelTableViewCell *)cellForLabel:(IDFormRowLabel *)row tableView:(UITableView *)tableView {
    IDLabelTableViewCell *cell = (IDLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDLabelTableViewCell reuseIdentifier]];
    cell.label = row.text;
    cell.bold = row.bold;
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    return cell;
}

- (IDErrorMessageTableViewCell *)cellForErrorMessage:(IDFormRowErrorMessage *)row tableView:(UITableView *)tableView {
    IDErrorMessageTableViewCell *cell = (IDErrorMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDErrorMessageTableViewCell reuseIdentifier]];
    cell.textLabel.text = row.text;
    return cell;
}

- (IDTooltipTableViewCell *)cellForTooltip:(IDFormRowTooltip *)row tableView:(UITableView *)tableView {
    IDTooltipTableViewCell *cell = (IDTooltipTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDTooltipTableViewCell reuseIdentifier]];
    cell.label = row.text;
    cell.tooltipImage = row.image;
    return cell;
}

- (IDCoBrandsSelectionTableViewCell *)cellForCoBrandsSelection:(IDFormRowCoBrandsSelection *)row tableView:(UITableView *)tableView {
    IDCoBrandsSelectionTableViewCell *cell = (IDCoBrandsSelectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDCoBrandsSelectionTableViewCell reuseIdentifier]];
    return cell;
}


- (IDCOBrandsExplanationTableViewCell *)cellForCoBrandsExplanation:(IDFormRowCoBrandsExplanation *)row tableView:(UITableView *)tableView {
    IDCOBrandsExplanationTableViewCell *cell = (IDCOBrandsExplanationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[IDCOBrandsExplanationTableViewCell reuseIdentifier]];
    return cell;
}

- (IDPaymentProductTableViewCell *)cellForPaymentProduct:(IDPaymentProductsTableRow *)row tableView:(UITableView *)tableView {
    IDPaymentProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[IDPaymentProductTableViewCell reuseIdentifier]];
    cell.name = row.name;
    cell.logo = row.logo;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [cell setNeedsLayout];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDFormRow *row = self.formRows[indexPath.row];
    
    if ([row isKindOfClass:[IDFormRowList class]]) {
        return [IDPickerViewTableViewCell pickerHeight];
    }
    else if ([row isKindOfClass:[IDFormRowDate class]]) {
        return [IDDatePickerTableViewCell pickerHeight];
    }
    // Rows that you can toggle
    else if ([row isKindOfClass:[IDFormRowTooltip class]] && !row.isEnabled) {
        return 0;
    }
    else if ([row isKindOfClass:[IDFormRowSwitch class]] && ((IDFormRowSwitch *)row).action == @selector(switchChanged:) && !row.isEnabled) {
        return 0;
    }
    else if ([row isKindOfClass:[IDFormRowTooltip class]] && ((IDFormRowTooltip *)row).image != nil) {
        return 145;
    } else if ([row isKindOfClass:[IDFormRowTooltip class]]) {
        return [IDTooltipTableViewCell cellSizeForWidth:MIN(320, tableView.frame.size.width) forFormRow:(IDFormRowTooltip *)row].height;
    }
    else if ([row isKindOfClass:[IDFormRowLabel class]]) {
        CGFloat tableWidth = tableView.frame.size.width;
        CGFloat height = [IDLabelTableViewCell cellSizeForWidth:MIN(320, tableWidth) forFormRow:(IDFormRowLabel *)row].height;
        return height;
    } else if ([row isKindOfClass:[IDFormRowButton class]]) {
        return 52;
    } else if ([row isKindOfClass:[IDFormRowTextField class]]) {
        CGFloat width = tableView.bounds.size.width - 20;
        IDFormRowTextField *textfieldRow = (IDFormRowTextField *)row;
        if (textfieldRow.showInfoButton) {
            width -= 48;
        }
        CGFloat errorHeight = 0;

        if ([textfieldRow.paymentProductField.errors firstObject] && self.validation) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@""];
            str = [[NSAttributedString alloc] initWithString: [IDFormRowsConverter errorMessageForError:[textfieldRow.paymentProductField.errors firstObject]   withCurrency: textfieldRow.paymentProductField.displayHints.formElement.type == IDCurrencyType]];
            errorHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin context: nil].size.height;
        }
        
        CGFloat height =  10 + 44 + 10 + errorHeight;
        return height;
        
    } else if ([row isKindOfClass:[IDFormRowSwitch class]]) {
        CGFloat width = tableView.bounds.size.width - 20;
        IDFormRowSwitch *textfieldRow = (IDFormRowSwitch *)row;
        if (textfieldRow.showInfoButton) {
            width -= 48;
        }
        CGFloat errorHeight = 0;
        if ([textfieldRow.field.errors firstObject] && self.validation) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@""];
            str = [[NSAttributedString alloc] initWithString: [IDFormRowsConverter errorMessageForError:[textfieldRow.field.errors firstObject]   withCurrency: 0]];
            errorHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin context: nil].size.height + 10;
        }
    
        CGFloat height =  10 + 44 + 10 + errorHeight;
        return height;
    }

    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.formRows[indexPath.row] isKindOfClass:[IDFormRowCoBrandsSelection class]]) {
        self.coBrandsCollapsed = !self.coBrandsCollapsed;
        [self.tableView reloadData];
    } else if ([self.formRows[indexPath.row] isKindOfClass:[IDPaymentProductsTableRow class]]) {
        IDPaymentProductsTableRow *row = (IDPaymentProductsTableRow *)self.formRows[indexPath.row];
        [self switchToPaymentProduct:row.paymentProductIdentifier];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    IDFormRow *formRow = self.formRows[indexPath.row + 1];
    if ([formRow isKindOfClass:[IDFormRowTooltip class]]) {
        
        formRow.isEnabled = !formRow.isEnabled;
        
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

#pragma mark TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL result = false;
    if ([textField class] == [IDTextField class]) {
        result = [self standardTextField:(IDTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    } else if ([textField class] == [IDIntegerTextField class]) {
        result = [self integerTextField:(IDIntegerTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    } else if ([textField class] == [IDFractionalTextField class]) {
        result = [self fractionalTextField:(IDFractionalTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    if (self.validation) {
        [self validateData];
    }
    
    return result;
}
- (void)formatAndUpdateCharactersFromTextField:(UITextField *)textField cursorPosition:(NSInteger *)position indexPath:(NSIndexPath *)indexPath {
    IDFormRowTextField *row = (IDFormRowTextField *)self.formRows[indexPath.row];
    NSMutableCharacterSet *trimSet = [NSMutableCharacterSet characterSetWithCharactersInString:@" /-_"];
    NSString *formattedString = [[self.inputData maskedValueForField:row.paymentProductField.identifier cursorPosition:position] stringByTrimmingCharactersInSet: trimSet];
    row.field.text = formattedString;
    textField.text = formattedString;
    *position = MIN(*position, formattedString.length);
    UITextPosition *cursorPositionInTextField = [textField positionFromPosition:textField.beginningOfDocument offset:*position];
    [textField setSelectedTextRange:[textField textRangeFromPosition:cursorPositionInTextField toPosition:cursorPositionInTextField]];
}

- (BOOL)standardTextField:(IDTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![textField.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[IDFormRowTextField class]]) {
        return NO;
    }
    IDFormRowTextField *row = (IDFormRowTextField *)self.formRows[indexPath.row];
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.inputData setValue:newString forField:row.paymentProductField.identifier];
    row.field.text = [self.inputData maskedValueForField:row.paymentProductField.identifier];
    NSInteger cursorPosition = range.location + string.length;
    [self formatAndUpdateCharactersFromTextField:textField cursorPosition:&cursorPosition indexPath:indexPath];
    return NO;
}

- (BOOL)integerTextField:(IDIntegerTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![textField.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[IDFormRowCurrency class]]) {
        return NO;
    }
    IDFormRowCurrency *row = (IDFormRowCurrency *)self.formRows[indexPath.row];
    NSString *integerString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *fractionalString = row.fractionalField.text;
    
    if (integerString.length > 16) {
        return NO;
    }
    
    NSString *newValue = [self updateCurrencyValueWithIntegerString:integerString fractionalString:fractionalString paymentProductFieldIdentifier:row.paymentProductField.identifier];
    if (string.length == 0) {
        return YES;
    } else {
        [self updateRowWithCurrencyValue:newValue formRowCurrency:row];
        return NO;
    }
}

- (BOOL)fractionalTextField:(IDFractionalTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![textField.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[IDFormRowCurrency class]]) {
        return NO;
    }
    IDFormRowCurrency *row = (IDFormRowCurrency *)self.formRows[indexPath.row];
    NSString *integerString = row.integerField.text;
    NSString *fractionalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (fractionalString.length > 2) {
        int start = (int) fractionalString.length - 2;
        int end = (int) fractionalString.length - 1;
        fractionalString = [fractionalString substringWithRange:NSMakeRange(start, end)];
    }
    
    NSString *newValue = [self updateCurrencyValueWithIntegerString:integerString fractionalString:fractionalString paymentProductFieldIdentifier:row.paymentProductField.identifier];
    if (string.length == 0) {
        return YES;
    } else {
        [self updateRowWithCurrencyValue:newValue formRowCurrency:row];
        return NO;
    }
}

- (NSString *)updateCurrencyValueWithIntegerString:(NSString *)integerString fractionalString:(NSString *)fractionalString paymentProductFieldIdentifier:(NSString *)identifier {
    long long integerPart = [integerString longLongValue];
    int fractionalPart = [fractionalString intValue];
    long long newValue = integerPart * 100 + fractionalPart;
    NSString *newString = [NSString stringWithFormat:@"%03lld", newValue];
    [self.inputData setValue:newString forField:identifier];
    
    return newString;
}

- (void)updateRowWithCurrencyValue:(NSString *)currencyValue formRowCurrency:(IDFormRowCurrency *)formRowCurrency {
    formRowCurrency.integerField.text = [currencyValue substringToIndex:currencyValue.length - 2];
    formRowCurrency.fractionalField.text = [currencyValue substringFromIndex:currencyValue.length - 2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return NO;
}

- (void)validateData {
    [self.inputData validate];
    [self updateFormRows];
}

#pragma mark Date picker cell delegate

- (void)datePicker:(UIDatePicker *)datePicker selectedNewDate:(NSDate *)newDate {
    IDDatePickerTableViewCell *cell = (IDDatePickerTableViewCell *)[datePicker superview];
    NSIndexPath *path = [[self tableView]indexPathForCell:cell];
    IDFormRowDate *row = self.formRows[path.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [formatter stringFromDate:newDate];
    [self.inputData setValue:dateString forField:row.paymentProductField.identifier] ;
    
}

- (void)cancelButtonTapped {
    [self.paymentRequestTarget didCancelPaymentRequest];
}


- (void)switchChanged:(IDSwitch *)sender
{
    IDSwitchTableViewCell *cell = (IDSwitchTableViewCell *)sender.superview;
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    IDFormRowSwitch *row = self.formRows[ip.row];
    IDPaymentProductField *field = [row field];
    
    if (field == nil) {
        self.inputData.tokenize = sender.on;
    }
    else {
        [self.inputData setValue:[sender isOn] ? @"true" : @"false" forField:field.identifier];
        row.isOn = [sender isOn];
        if (self.validation) {
            [self validateData];
        }
        [self updateSwitchCell:cell row:row];
    }
}

#pragma mark Picker view delegate

- (NSInteger)numberOfComponentsInPickerView:(IDPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(IDPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerView.content.count;
}

- (NSAttributedString *)pickerView:(IDPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *item = pickerView.content[row];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:item];
    return string;
}

- (void)pickerView:(IDPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (![pickerView.superview isKindOfClass:[IDPickerViewTableViewCell class]]) {
        return;
    }
    IDPickerViewTableViewCell *cell = (IDPickerViewTableViewCell *)pickerView.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)pickerView.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[IDFormRowList class]]) {
        return;
    }
    IDFormRowList *element = (IDFormRowList *)self.formRows[indexPath.row];
    IDValueMappingItem *selectedItem = cell.items[row];
    
    element.selectedRow = row;
    [self.inputData setValue:selectedItem.value forField:element.paymentProductField.identifier];
}

// To be overrided by subclasses
- (void)updatePickerCell:(IDPickerViewTableViewCell *)cell row: (IDFormRowList *)list {
    return;
}

#pragma mark Button target methods

- (void)payButtonTapped {
    BOOL valid = NO;
    
    [self.inputData validate];
    if (self.inputData.errors.count == 0) {
        IDPaymentRequest *paymentRequest = [self.inputData paymentRequest];
        [paymentRequest validate];
        if (paymentRequest.errors.count == 0) {
            valid = YES;
            [self.paymentRequestTarget didSubmitPaymentRequest:paymentRequest];
        }
    }
    if (valid == NO) {
        self.validation = YES;
        [self updateFormRows];
    }
    
}

- (void)validateExceptFields:(NSSet *)fields {
    [self.inputData validateExceptFields:fields];
    if (self.inputData.errors.count > 0) {
        self.validation = YES;
    }
}

@end
