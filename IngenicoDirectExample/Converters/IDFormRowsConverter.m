//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDFormRowsConverter.h"
#import "IDFormRowDate.h"
#import "IDFormRowsConverter.h"
#import "IDFormRowList.h"
#import "IDFormRowTextField.h"
#import "IDFormRowSwitch.h"
#import "IDPaymentProductInputData.h"
#import "IDFormRowCurrency.h"
#import "IDFormRowLabel.h"

#import <IngenicoDirectSDK/IDIINDetailsResponse.h>
#import <IngenicoDirectSDK/IDSDKConstants.h>
#import <IngenicoDirectSDK/IDValidators.h>
#import <IngenicoDirectSDK/IDValidationErrorAllowed.h>
#import <IngenicoDirectSDK/IDValidationErrorIBAN.h>
#import <IngenicoDirectSDK/IDValidationErrorLuhn.h>
#import <IngenicoDirectSDK/IDValidationErrorLength.h>
#import <IngenicoDirectSDK/IDValidationErrorRegularExpression.h>
#import <IngenicoDirectSDK/IDValidationErrorTermsAndConditions.h>
#import <IngenicoDirectSDK/IDValidationErrorIsRequired.h>
#import <IngenicoDirectSDK/IDValidationErrorFixedList.h>
#import <IngenicoDirectSDK/IDValidationErrorRange.h>
#import <IngenicoDirectSDK/IDValidationErrorExpirationDate.h>
#import <IngenicoDirectSDK/IDValidationErrorEmailAddress.h>

@interface IDFormRowsConverter ()

+ (NSBundle *)sdkBundle;

@end

@implementation IDFormRowsConverter

static NSBundle * _sdkBundle;
+ (NSBundle *)sdkBundle {
    if (_sdkBundle == nil) {
        _sdkBundle = [NSBundle bundleWithPath:kIDSDKBundlePath];
    }
    return _sdkBundle;
}

- (instancetype)init
{
    self = [super init];
    
    return self;
}

- (NSMutableArray *)formRowsFromInputData:(IDPaymentProductInputData *)inputData viewFactory:(IDViewFactory *)viewFactory confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts {
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    for (IDPaymentProductField* field in inputData.paymentItem.fields.paymentProductFields) {
        IDFormRow *row;
        BOOL isPartOfAccountOnFile = [inputData fieldIsPartOfAccountOnFile:field.identifier];
        NSString *value;
        BOOL isEnabled;
        if (isPartOfAccountOnFile == YES) {
            NSString *mask = field.displayHints.mask;
            value = [inputData.accountOnFile maskedValueForField:field.identifier mask:mask];
            isEnabled = [inputData fieldIsReadOnly:field.identifier] == NO;
        } else {
            value = [inputData maskedValueForField:field.identifier];
            isEnabled = YES;
        }
        row = [self labelFormRowFromField:field paymentProduct:inputData.paymentItem.identifier viewFactory:viewFactory];
        [rows addObject:row];
        switch (field.displayHints.formElement.type) {
            case IDListType: {
                row = [self listFormRowFromField:field value:value isEnabled:isEnabled viewFactory:viewFactory];
                break;
            }
            case IDTextType: {
                row = [self textFieldFormRowFromField:field paymentItem:inputData.paymentItem value:value isEnabled:isEnabled confirmedPaymentProducts:confirmedPaymentProducts viewFactory:viewFactory];
                break;
            }
            case IDBoolType: {
                [rows removeLastObject]; // Label is integrated into switch field
                row = [self switchFormRowFromField: field paymentItem: inputData.paymentItem value: value isEnabled: isEnabled viewFactory: viewFactory];
                break;
            }
            case IDDateType: {
                row = [self dateFormRowFromField: field paymentItem: inputData.paymentItem value: value isEnabled: isEnabled viewFactory: viewFactory];
                break;

            }
            case IDCurrencyType: {
                row = [self currencyFormRowFromField:field paymentItem:inputData.paymentItem value:value isEnabled:isEnabled viewFactory:viewFactory];
                break;
            }
            default: {
                [NSException raise:@"Invalid form element type" format:@"Form element type %d is invalid", field.displayHints.formElement.type];
                break;
            }
        }
        [rows addObject:row];
    }
    return rows;
}

- (IDValidationError *)errorWithIINDetails:(IDIINDetailsResponse *)iinDetailsResponse {
    //Validation error
    if (iinDetailsResponse.status == IDExistingButNotAllowed) {
        return [IDValidationErrorAllowed new];
    } else if (iinDetailsResponse.status == IDUnknown) {
        return [IDValidationErrorLuhn new];
    }
    return nil;
}

+ (NSString *)errorMessageForError:(IDValidationError *)error withCurrency:(BOOL)forCurrency
{
    Class errorClass = [error class];
    NSString *errorMessageFormat = @"gc.general.paymentProductFields.validationErrors.%@.label";
    NSString *errorMessageKey;
    NSString *errorMessageValue;
    NSString *errorMessage;
    if (errorClass == [IDValidationErrorLength class]) {
        IDValidationErrorLength *lengthError = (IDValidationErrorLength *)error;
        if (lengthError.minLength == lengthError.maxLength) {
            errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.exact"];
        } else if (lengthError.minLength == 0 && lengthError.maxLength > 0) {
            errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.max"];
        } else if (lengthError.minLength > 0 && lengthError.maxLength > 0) {
            errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.between"];
        }
        NSString *errorMessageValueWithPlaceholders = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, self.sdkBundle, nil);
        NSString *errorMessageValueWithPlaceholder = [errorMessageValueWithPlaceholders stringByReplacingOccurrencesOfString:@"{maxLength}" withString:[NSString stringWithFormat:@"%ld", lengthError.maxLength]];
        errorMessage = [errorMessageValueWithPlaceholder stringByReplacingOccurrencesOfString:@"{minLength}" withString:[NSString stringWithFormat:@"%ld", lengthError.minLength]];
    } else if (errorClass == [IDValidationErrorRange class]) {
        IDValidationErrorRange *rangeError = (IDValidationErrorRange *)error;
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.between"];
        NSString *errorMessageValueWithPlaceholders = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, self.sdkBundle, nil);
        NSString *minString;
        NSString *maxString;
        if (forCurrency == YES) {
            minString = [NSString stringWithFormat:@"%.2f", (double)rangeError.minValue / 100];
            maxString = [NSString stringWithFormat:@"%.2f", (double)rangeError.maxValue / 100];
        } else {
            minString = [NSString stringWithFormat:@"%ld", (long)rangeError.minValue];
            maxString = [NSString stringWithFormat:@"%ld", (long)rangeError.maxValue];
        }
        NSString *errorMessageValueWithPlaceholder = [errorMessageValueWithPlaceholders stringByReplacingOccurrencesOfString:@"{minValue}" withString:minString];
        errorMessageValue = [errorMessageValueWithPlaceholder stringByReplacingOccurrencesOfString:@"{maxValue}" withString:maxString];
    } else if (errorClass == [IDValidationErrorExpirationDate class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"expirationDate"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [IDValidationErrorFixedList class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"fixedList"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [IDValidationErrorLuhn class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"luhn"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [IDValidationErrorAllowed class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"allowedInContext"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [IDValidationErrorEmailAddress class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"emailAddress"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [IDValidationErrorIBAN class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"regularExpression"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [IDValidationErrorRegularExpression class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"regularExpression"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [IDValidationErrorTermsAndConditions class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"termsAndConditions"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [IDValidationErrorIsRequired class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"required"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else {
        [NSException raise:@"Invalid validation error" format:@"Validation error %@ is invalid", error];
    }
    return errorMessage;
}
- (IDFormRowTextField *)textFieldFormRowFromField:(IDPaymentProductField *)field paymentItem:(NSObject<IDPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts viewFactory:(IDViewFactory *)viewFactory
{
    NSString *placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.placeholder", paymentItem.identifier, field.identifier];
    NSString *placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
    if ([placeholderKey isEqualToString:placeholderValue] == YES) {
        placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.placeholder", field.identifier];
        placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
    }
    
    UIKeyboardType keyboardType = UIKeyboardTypeDefault;
    if (field.displayHints.preferredInputType == IDIntegerKeyboard) {
        keyboardType = UIKeyboardTypeNumberPad;
    } else if (field.displayHints.preferredInputType == IDEmailAddressKeyboard) {
        keyboardType = UIKeyboardTypeEmailAddress;
    } else if (field.displayHints.preferredInputType == IDPhoneNumberKeyboard) {
        keyboardType = UIKeyboardTypePhonePad;
    }
    
    IDFormRowField *formField = [[IDFormRowField alloc] initWithText:value placeholder:placeholderValue keyboardType:keyboardType isSecure:field.displayHints.obfuscate];
    IDFormRowTextField *row = [[IDFormRowTextField alloc] initWithPaymentProductField:field field:formField];
    row.isEnabled = isEnabled;
    
    if ([field.identifier isEqualToString:@"cardNumber"] == YES) {
        if ([confirmedPaymentProducts member:paymentItem.identifier] != nil) {
            row.logo = paymentItem.displayHints.logoImage;
        }
        else {
            row.logo = nil;
        }
    }
    
    [self setTooltipForFormRow:row withField:field paymentItem:paymentItem];
    
    return row;
}

- (IDFormRowSwitch *)switchFormRowFromField:(IDPaymentProductField *)field paymentItem:(NSObject<IDPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(IDViewFactory *)viewFactory
{
    NSString *descriptionKey = [NSString stringWithFormat: @"gc.general.paymentProducts.%@.paymentProductFields.%@.label", paymentItem.identifier, field.identifier];
    NSString *descriptionValue = NSLocalizedStringWithDefaultValue(descriptionKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil, @"Accept {link}");
    NSString *labelKey = [NSString stringWithFormat: @"gc.general.paymentProducts.%@.paymentProductFields.%@.link.label", paymentItem.identifier, field.identifier];
    NSString *labelValue = NSLocalizedStringWithDefaultValue(labelKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil, @"");
    NSRange range = [descriptionValue rangeOfString:@"{link}"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:descriptionValue];
    NSAttributedString *linkString = [[NSAttributedString alloc]initWithString:labelValue attributes:@{NSLinkAttributeName:field.displayHints.link.absoluteString}];
    [attrString replaceCharactersInRange:range withAttributedString:linkString];

    IDFormRowSwitch *row = [[IDFormRowSwitch alloc] initWithAttributedTitle:attrString isOn:[value isEqualToString:@"true"] target:nil action:NULL paymentProductField:field];
    row.isEnabled = isEnabled;

    return row;
}

- (IDFormRowDate *)dateFormRowFromField:(IDPaymentProductField *)field paymentItem:(NSObject<IDPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(IDViewFactory *)viewFactory
{
    IDFormRowDate *row = [[IDFormRowDate alloc] init];
    row.paymentProductField = field;
    row.isEnabled = isEnabled;
    row.value = value;
    return row;
}

- (IDFormRowCurrency *)currencyFormRowFromField:(IDPaymentProductField *)field paymentItem:(NSObject<IDPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(IDViewFactory *)viewFactory
{
    NSString *placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.placeholder", paymentItem.identifier, field.identifier];
    NSString *placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
    if ([placeholderKey isEqualToString:placeholderValue] == YES) {
        placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.placeholder", field.identifier];
        placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
    }
    
    IDFormRowCurrency *row = [[IDFormRowCurrency alloc] init];
    row.integerField = [[IDFormRowField alloc] init];
    row.fractionalField = [[IDFormRowField alloc] init];
    
    row.integerField.placeholder = placeholderValue;
    if (field.displayHints.preferredInputType == IDIntegerKeyboard) {
        row.integerField.keyboardType = UIKeyboardTypeNumberPad;
        row.fractionalField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (field.displayHints.preferredInputType == IDEmailAddressKeyboard) {
        row.integerField.keyboardType = UIKeyboardTypeEmailAddress;
        row.fractionalField.keyboardType = UIKeyboardTypeEmailAddress;
    } else if (field.displayHints.preferredInputType == IDPhoneNumberKeyboard) {
        row.integerField.keyboardType = UIKeyboardTypePhonePad;
        row.fractionalField.keyboardType = UIKeyboardTypePhonePad;
    }
    
    long long integerPart = [value longLongValue] / 100;
    int fractionalPart = (int) llabs([value longLongValue] % 100);
    row.integerField.isSecure = field.displayHints.obfuscate;
    row.integerField.text = [NSString stringWithFormat:@"%lld", integerPart];
    row.fractionalField.isSecure = field.displayHints.obfuscate;
    row.fractionalField.text = [NSString stringWithFormat:@"%02d", fractionalPart];
    row.paymentProductField = field;

    row.isEnabled = isEnabled;
    [self setTooltipForFormRow:row withField:field paymentItem:paymentItem];
    
    return row;
}

- (void)setTooltipForFormRow:(IDFormRowWithInfoButton *)row withField:(IDPaymentProductField *)field paymentItem:(NSObject<IDPaymentItem> *)paymentItem
{
    if (field.displayHints.tooltip.imagePath != nil) {
        IDFormRowTooltip *tooltip = [IDFormRowTooltip new];
        NSString *tooltipTextKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.tooltipText", paymentItem.identifier, field.identifier];
        NSString *tooltipTextValue = NSLocalizedStringFromTableInBundle(tooltipTextKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        if ([tooltipTextKey isEqualToString:tooltipTextValue] == YES) {
            tooltipTextKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.tooltipText", field.identifier];
            tooltipTextValue = NSLocalizedStringFromTableInBundle(tooltipTextKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
        }
        tooltip.text = tooltipTextValue;
        tooltip.image = field.displayHints.tooltip.image;
        row.tooltip = tooltip;
    }
}

- (IDFormRowList *)listFormRowFromField:(IDPaymentProductField *)field value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(IDViewFactory *)viewFactory
{
    IDFormRowList *row = [[IDFormRowList alloc] initWithPaymentProductField:field];
    
    NSInteger rowIndex = 0;
    NSInteger selectedRow = 0;
    for (IDValueMappingItem *item in field.displayHints.formElement.valueMapping) {
        if (item.value != nil) {
            if ([item.value isEqualToString:value]) {
                selectedRow = rowIndex;
            }
            [row.items addObject:item];
        }
        ++rowIndex;
    }

    row.selectedRow = selectedRow;
    row.isEnabled = isEnabled;
    return row;
}
- (NSString *)labelStringFormRowFromField:(IDPaymentProductField *)field paymentProduct:(NSString *)paymentProductId {
    NSString *labelKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.label", paymentProductId, field.identifier];
    NSString *labelValue = NSLocalizedStringFromTableInBundle(labelKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
    if ([labelKey isEqualToString:labelValue] == YES) {
        labelKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.label", field.identifier];
        labelValue = NSLocalizedStringFromTableInBundle(labelKey, kIDSDKLocalizable, [IDFormRowsConverter sdkBundle], nil);
    }
    return labelValue;
}
- (IDFormRowLabel *)labelFormRowFromField:(IDPaymentProductField *)field paymentProduct:(NSString *)paymentProductId viewFactory:(IDViewFactory *)viewFactory
{
    IDFormRowLabel *row = [[IDFormRowLabel alloc] init];
    NSString *labelValue = [self labelStringFormRowFromField:field paymentProduct:paymentProductId];
    row.text = labelValue;
    
    return row;
}

@end
