//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <PassKit/PassKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "IDAppConstants.h"
#import "IDStartViewController.h"
#import "IDViewFactory.h"
#import "IDPaymentProductsViewController.h"
#import "IDPaymentProductViewController.h"
#import "IDEndViewController.h"
#import "IDPaymentProductsViewControllerTarget.h"

#import <IngenicoDirectSDK/IDSDKConstants.h>
#import <IngenicoDirectSDK/IDPaymentItem.h>
#import <IngenicoDirectSDK/IDPaymentAmountOfMoney.h>
#import <IngenicoDirectSDK/IDPaymentProductGroup.h>
#import <IngenicoDirectSDK/IDBasicPaymentProductGroup.h>

@interface IDStartViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UITextView *explanation;
@property (strong, nonatomic) IDLabel *clientSessionIdLabel;
@property (strong, nonatomic) IDTextField *clientSessionIdTextField;
@property (strong, nonatomic) IDLabel *customerIdLabel;
@property (strong, nonatomic) IDTextField *customerIdTextField;
@property (strong, nonatomic) IDLabel *baseURLLabel;
@property (strong, nonatomic) IDTextField *baseURLTextField;
@property (strong, nonatomic) IDLabel *assetsBaseURLLabel;
@property (strong, nonatomic) IDTextField *assetsBaseURLTextField;
@property (strong, nonatomic) IDLabel *merchantIdLabel;
@property (strong, nonatomic) IDTextField *merchantIdTextField;
@property (strong, nonatomic) IDLabel *amountLabel;
@property (strong, nonatomic) IDTextField *amountTextField;
@property (strong, nonatomic) IDLabel *countryCodeLabel;
@property (strong, nonatomic) IDPickerView *countryCodePicker;
@property (strong, nonatomic) IDLabel *currencyCodeLabel;
@property (strong, nonatomic) IDPickerView *currencyCodePicker;
@property (strong, nonatomic) IDLabel *isRecurringLabel;
@property (strong, nonatomic) IDSwitch *isRecurringSwitch;
@property (strong, nonatomic) UIButton *payButton;
@property (strong, nonatomic) IDPaymentProductsViewControllerTarget *paymentProductsViewControllerTarget;

@property (nonatomic) long amountValue;

@property (strong, nonatomic) IDViewFactory *viewFactory;
@property (strong, nonatomic) IDSession *session;
@property (strong, nonatomic) IDPaymentContext *context;

@property (strong, nonatomic) NSArray *countryCodes;
@property (strong, nonatomic) NSArray *currencyCodes;

@end

@implementation IDStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeTapRecognizer];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)] == YES) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.viewFactory = [[IDViewFactory alloc] init];
    
    self.countryCodes = [[kIDCountryCodes componentsSeparatedByString:@", "] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.currencyCodes = [[kIDCurrencyCodes componentsSeparatedByString:@", "] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delaysContentTouches = NO;
    [self.view addSubview:self.scrollView];
    
    UIView *superContainerView = [[UIView alloc] init];
    superContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    superContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:superContainerView];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [superContainerView addSubview:self.containerView];


    self.explanation = [[UITextView alloc] init];
    self.explanation.translatesAutoresizingMaskIntoConstraints = NO;
    self.explanation.text = NSLocalizedStringFromTable(@"SetupExplanation", kIDAppLocalizable, @"To process a payment using the services provided by the IngenicoDirect platform, the following information must be provided by a merchant.\n\nAfter providing the information requested below, this example app can process a payment.");
    self.explanation.editable = NO;
    self.explanation.backgroundColor = [UIColor colorWithRed:0.85 green:0.94 blue:0.97 alpha:1];
    self.explanation.textColor = [UIColor colorWithRed:0 green:0.58 blue:0.82 alpha:1];
    self.explanation.layer.cornerRadius = 5.0;
    self.explanation.scrollEnabled = NO;
    [self.containerView addSubview:self.explanation];

    self.clientSessionIdLabel = [self.viewFactory labelWithType:IDLabelType];
    self.clientSessionIdLabel.text = NSLocalizedStringFromTable(@"ClientSessionIdentifier", kIDAppLocalizable, @"Client session identifier");
    self.clientSessionIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.clientSessionIdTextField = [self.viewFactory textFieldWithType:IDTextFieldType];
    self.clientSessionIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.clientSessionIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.clientSessionIdTextField.text = [StandardUserDefaults objectForKey:kIDClientSessionId];
    [self.containerView addSubview:self.clientSessionIdLabel];
    [self.containerView addSubview:self.clientSessionIdTextField];
    
    self.customerIdLabel = [self.viewFactory labelWithType:IDLabelType];
    self.customerIdLabel.text = NSLocalizedStringFromTable(@"CustomerIdentifier", kIDAppLocalizable, @"Customer identifier");
    self.customerIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.customerIdTextField = [self.viewFactory textFieldWithType:IDTextFieldType];
    self.customerIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.customerIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.customerIdTextField.text = [StandardUserDefaults objectForKey:kIDCustomerId];
    [self.containerView addSubview:self.customerIdLabel];
    [self.containerView addSubview:self.customerIdTextField];
    
    self.baseURLLabel = [self.viewFactory labelWithType:IDLabelType];
    self.baseURLLabel.text = NSLocalizedStringFromTable(@"BaseURL", kIDAppLocalizable, @"Client session identifier");
    self.baseURLLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.baseURLTextField = [self.viewFactory textFieldWithType:IDTextFieldType];
    self.baseURLTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.baseURLTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.baseURLTextField.text = [StandardUserDefaults objectForKey:kIDBaseURL];
    [self.containerView addSubview:self.baseURLLabel];
    [self.containerView addSubview:self.baseURLTextField];
    
    self.assetsBaseURLLabel = [self.viewFactory labelWithType:IDLabelType];
    self.assetsBaseURLLabel.text = NSLocalizedStringFromTable(@"AssetsBaseURL", kIDAppLocalizable, @"Customer identifier");
    self.assetsBaseURLLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.assetsBaseURLTextField = [self.viewFactory textFieldWithType:IDTextFieldType];
    self.assetsBaseURLTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.assetsBaseURLTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.assetsBaseURLTextField.text = [StandardUserDefaults objectForKey:kIDAssetsBaseURL];
    [self.containerView addSubview:self.assetsBaseURLLabel];
    [self.containerView addSubview:self.assetsBaseURLTextField];

    self.merchantIdLabel = [self.viewFactory labelWithType:IDLabelType];
    self.merchantIdLabel.text = NSLocalizedStringFromTable(@"MerchantIdentifier", kIDAppLocalizable, @"Merchant identifier");
    self.merchantIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.merchantIdTextField = [self.viewFactory textFieldWithType:IDTextFieldType];
    self.merchantIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.merchantIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.merchantIdTextField.text = [StandardUserDefaults objectForKey:kIDMerchantId];
    [self.containerView addSubview:self.merchantIdLabel];
    [self.containerView addSubview:self.merchantIdTextField];
    
    self.amountLabel = [self.viewFactory labelWithType:IDLabelType];
    self.amountLabel.text = NSLocalizedStringFromTable(@"AmountInCents", kIDAppLocalizable, @"Amount in cents");
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField = [self.viewFactory textFieldWithType:IDTextFieldType];
    self.amountTextField.translatesAutoresizingMaskIntoConstraints = NO;
    NSInteger amount = [[NSUserDefaults standardUserDefaults] integerForKey:kIDPrice];
    if (amount == 0) {
        self.amountTextField.text = @"100";
    }
    else {
        self.amountTextField.text = [NSString stringWithFormat:@"%ld", (long)amount];

    }
    [self.containerView addSubview:self.amountLabel];
    [self.containerView addSubview:self.amountTextField];
    
    self.countryCodeLabel = [self.viewFactory labelWithType:IDLabelType];
    self.countryCodeLabel.text = NSLocalizedStringFromTable(@"CountryCode", kIDAppLocalizable, @"Country code");
    self.countryCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryCodePicker = [self.viewFactory pickerViewWithType:IDPickerViewType];
    self.countryCodePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryCodePicker.content = self.countryCodes;
    self.countryCodePicker.dataSource = self;
    self.countryCodePicker.delegate = self;
    NSInteger countryCode = [[NSUserDefaults standardUserDefaults] integerForKey:kIDCountryCode];
    if (countryCode == 0) {
        [self.countryCodePicker selectRow:165 inComponent:0 animated:NO];
    }
    else {
        [self.countryCodePicker selectRow:countryCode inComponent:0 animated:NO];
    }
    [self.countryCodePicker selectRow:165 inComponent:0 animated:NO];
    [self.containerView addSubview:self.countryCodeLabel];
    [self.containerView addSubview:self.countryCodePicker];
    
    self.currencyCodeLabel = [self.viewFactory labelWithType:IDLabelType];
    self.currencyCodeLabel.text = NSLocalizedStringFromTable(@"CurrencyCode", kIDAppLocalizable, @"Currency code");
    self.currencyCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.currencyCodePicker = [self.viewFactory pickerViewWithType:IDPickerViewType];
    self.currencyCodePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.currencyCodePicker.content = self.currencyCodes;
    self.currencyCodePicker.dataSource = self;
    self.currencyCodePicker.delegate = self;
    NSInteger currency = [[NSUserDefaults standardUserDefaults] integerForKey:kIDCurrency];
    if (currency == 0) {
        [self.currencyCodePicker selectRow:42 inComponent:0 animated:NO];
    }
    else {
        [self.currencyCodePicker selectRow:currency inComponent:0 animated:NO];
    }
    [self.containerView addSubview:self.currencyCodeLabel];
    [self.containerView addSubview:self.currencyCodePicker];
    
    self.isRecurringLabel = [self.viewFactory labelWithType:IDLabelType];
    self.isRecurringLabel.text = NSLocalizedStringFromTable(@"RecurringPayment", kIDAppLocalizable, @"Payment is recurring");
    self.isRecurringLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.isRecurringSwitch = [self.viewFactory switchWithType:IDSwitchType];
    self.isRecurringSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.isRecurringLabel];
    [self.containerView addSubview:self.isRecurringSwitch];

    self.payButton = [self.viewFactory buttonWithType:IDButtonTypePrimary];
    [self.payButton setTitle:NSLocalizedStringFromTable(@"PayNow", kIDAppLocalizable, @"Pay securely now") forState:UIControlStateNormal];
    self.payButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.payButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.payButton];

    NSDictionary *views = NSDictionaryOfVariableBindings(_explanation, _clientSessionIdLabel, _clientSessionIdTextField, _customerIdLabel, _customerIdTextField, _baseURLLabel, _baseURLTextField, _assetsBaseURLLabel, _assetsBaseURLTextField, _merchantIdLabel, _merchantIdTextField, _amountLabel, _amountTextField, _countryCodeLabel, _countryCodePicker, _currencyCodeLabel, _currencyCodePicker, _isRecurringLabel, _isRecurringSwitch, _payButton, _containerView, _scrollView, superContainerView);
    NSDictionary *metrics = @{@"fieldSeparator": @"24", @"groupSeparator": @"72"};

    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_explanation]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_clientSessionIdLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_clientSessionIdTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_customerIdLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_customerIdTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_baseURLLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_baseURLTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_assetsBaseURLLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_assetsBaseURLTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_merchantIdLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_merchantIdTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_amountLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_amountTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_countryCodeLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_countryCodePicker]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_currencyCodeLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_currencyCodePicker]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_isRecurringLabel]-[_isRecurringSwitch]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_payButton]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_explanation]-(fieldSeparator)-[_clientSessionIdLabel]-[_clientSessionIdTextField]-(fieldSeparator)-[_customerIdLabel]-[_customerIdTextField]-(fieldSeparator)-[_baseURLLabel]-[_baseURLTextField]-(fieldSeparator)-[_assetsBaseURLLabel]-[_assetsBaseURLTextField]-(fieldSeparator)-[_merchantIdLabel]-[_merchantIdTextField]-(groupSeparator)-[_amountLabel]-[_amountTextField]-(fieldSeparator)-[_countryCodeLabel]-[_countryCodePicker]-(fieldSeparator)-[_currencyCodeLabel]-[_currencyCodePicker]-(fieldSeparator)-[_isRecurringSwitch]-(fieldSeparator)-[_payButton]-|" options:0 metrics:metrics views:views]];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    superContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:superContainerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0], [NSLayoutConstraint constraintWithItem:superContainerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[superContainerView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[superContainerView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:views]];
    [superContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_containerView]|" options:0 metrics:nil views:views]];
    [superContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:320]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)initializeTapRecognizer {
    UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    tapScrollView.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapScrollView];
}

- (void)tableViewTapped {
    for (UIView *view in self.containerView.subviews) {
        if ([view class] == [IDTextField class]) {
            IDTextField *textField = (IDTextField *)view;
            if ([textField isFirstResponder] == YES) {
                [textField resignFirstResponder];
            }
        }
    }
}

#pragma mark - Picker view delegate

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

- (BOOL)checkURL:(NSString *)url {
    NSMutableArray<NSString *> *components;
    if (@available(iOS 7.0, *)) {
        NSURLComponents *finalComponents = [NSURLComponents componentsWithString:url];
        components = [[finalComponents.path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
    }
    else {
        components = [[[NSURL URLWithString:url].path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
    }
    
    
    NSArray<NSString *> *versionComponents = [kIDAPIVersion componentsSeparatedByString:@"/"];
    switch (components.count) {
        case 0: {
            components = versionComponents.mutableCopy;
            break;
        }
        case 1: {
            if (![components[0] isEqualToString:versionComponents[0]]) {
                return NO;
            }
            [components addObject:versionComponents[1]];
            break;
        }
        case 2: {
            if (![components[0] isEqualToString:versionComponents[0]]) {
                return NO;
            }
            if (![components[1] isEqualToString:versionComponents[1]]) {
                return NO;
            }
            break;
        }
        default: {
            return NO;
            break;
        }
    }
    return YES;
}

#pragma mark - Button actions

- (void)buyButtonTapped:(UIButton *)sender {
    if (self.payButton == sender) {
        self.amountValue = (long) [self.amountTextField.text longLongValue];
    } else {
        [NSException raise:@"Invalid sender" format:@"Sender %@ is invalid", sender];
    }

    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"gc.app.general.loading.body", kIDSDKLocalizable, [NSBundle bundleWithPath:kIDSDKBundlePath], nil)];

    NSString *clientSessionId = self.clientSessionIdTextField.text;
    [StandardUserDefaults setObject:clientSessionId forKey:kIDClientSessionId];
    NSString *customerId = self.customerIdTextField.text;
    [StandardUserDefaults setObject:customerId forKey:kIDCustomerId];
    NSString *baseURL = self.baseURLTextField.text;
    [StandardUserDefaults setObject:baseURL forKey:kIDBaseURL];
    NSString *assetsBaseURL = self.assetsBaseURLTextField.text;
    [StandardUserDefaults setObject:assetsBaseURL forKey:kIDAssetsBaseURL];

    if (self.merchantIdTextField.text != nil) {
        NSString *merchantId = self.merchantIdTextField.text;
        [StandardUserDefaults setObject:merchantId forKey:kIDMerchantId];
    }
    [StandardUserDefaults setInteger:self.amountValue forKey:kIDPrice];
    [StandardUserDefaults setInteger:[self.countryCodePicker selectedRowInComponent:0] forKey:kIDCountryCode];
    [StandardUserDefaults setInteger:[self.currencyCodePicker selectedRowInComponent:0] forKey:kIDCurrency];

    // ***************************************************************************
    //
    // The IngenicoDirect SDK supports processing payments with instances of the
    // IDSession class. The code below shows how such an instance could be
    // instantiated.
    //
    // The IDSession class uses a number of supporting objects. There is an
    // initializer for this class that takes these supporting objects as
    // arguments. This should make it easy to replace these additional objects
    // without changing the implementation of the SDK. Use this initializer
    // instead of the factory method used below if you want to replace any of the
    // supporting objects.
    //
    // ***************************************************************************
    if (![self checkURL:baseURL]) {
        [SVProgressHUD dismiss];
        NSMutableArray<NSString *> *components;
        if (@available(iOS 7.0, *)) {
            NSURLComponents *finalComponents = [NSURLComponents componentsWithString:baseURL];
            components = [[finalComponents.path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                          [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
        }
        else {
            components = [[[NSURL URLWithString:baseURL].path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                          [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
        }
        NSArray<NSString *> *versionComponents = [kIDAPIVersion componentsSeparatedByString:@"/"];
        NSString *alertReason = [NSString stringWithFormat: @"This version of the Direct SDK is only compatible with %@ , you supplied: '%@'",
                                 [versionComponents componentsJoinedByString: @"/"],
                                 [components componentsJoinedByString: @"/"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"InvalidBaseURLTitle", kIDAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(alertReason, kIDAppLocalizable, nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    self.session = [IDSession sessionWithClientSessionId:clientSessionId customerId:customerId baseURL:baseURL assetBaseURL:assetsBaseURL appIdentifier:kIDApplicationIdentifier];

    NSString *countryCode = [self.countryCodes objectAtIndex:[self.countryCodePicker selectedRowInComponent:0]];
    NSString *currencyCode = [self.currencyCodes objectAtIndex:[self.currencyCodePicker selectedRowInComponent:0]];
    BOOL isRecurring = self.isRecurringSwitch.on;

    // ***************************************************************************
    //
    // To retrieve the available payment products, the information stored in the
    // following IDPaymentContext object is needed.
    //
    // After the IDSession object has retrieved the payment products that match
    // the information stored in the IDPaymentContext object, a
    // selection screen is shown. This screen itself is not part of the SDK and
    // only illustrates a possible payment product selection screen.
    //
    // ***************************************************************************
    IDPaymentAmountOfMoney *amountOfMoney = [[IDPaymentAmountOfMoney alloc] initWithTotalAmount:self.amountValue currencyCode:currencyCode];
    self.context = [[IDPaymentContext alloc] initWithAmountOfMoney:amountOfMoney isRecurring:isRecurring countryCode:countryCode];

    [self.session paymentItemsForContext:self.context groupPaymentProducts:NO success:^(IDPaymentItems *paymentItems) {
        [SVProgressHUD dismiss];
        [self showPaymentProductSelection:paymentItems];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"InvalidBaseURLTitle", kIDAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(@"ConnectionErrorTitle", kIDAppLocalizable, @"Title of the connection error dialog.") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)showPaymentProductSelection:(IDPaymentItems *)paymentItems {
    self.paymentProductsViewControllerTarget = [[IDPaymentProductsViewControllerTarget alloc] initWithNavigationController:self.navigationController session:self.session context:self.context viewFactory:self.viewFactory];
    self.paymentProductsViewControllerTarget.paymentFinishedTarget = self;
    IDPaymentProductsViewController *paymentProductSelection = [[IDPaymentProductsViewController alloc] init];
    paymentProductSelection.target = self.paymentProductsViewControllerTarget;
    paymentProductSelection.paymentItems = paymentItems;
    paymentProductSelection.viewFactory = self.viewFactory;
    paymentProductSelection.amount = self.amountValue;
    paymentProductSelection.currencyCode = self.context.amountOfMoney.currencyCode;
    [self.navigationController pushViewController:paymentProductSelection animated:YES];
    [SVProgressHUD dismiss];
}

#pragma mark - Continue shopping target

- (void)didSelectContinueShopping {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Payment finished target

- (void)didFinishPayment {
    IDEndViewController *end = [[IDEndViewController alloc] init];
    end.target = self;
    end.viewFactory = self.viewFactory;
    [self.navigationController pushViewController:end animated:YES];
}

@end
