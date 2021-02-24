//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDViewFactory.h"
#import "IDPaymentRequestTarget.h"
#import "IDFormRowTextField.h"
#import "IDPaymentProductInputData.h"
#import "IDFormRowSwitch.h"
#import "IDFormRowList.h"
#import "IDPickerViewTableViewCell.h"
#import "IDTextFieldTableViewCell.h"
#import "IDSwitchTableViewCell.h"
#import "IDCoBrandsSelectionTableViewCell.h"

#import <IngenicoDirectSDK/IDPaymentProduct.h>
#import <IngenicoDirectSDK/IDAccountOnFile.h>
#import <IngenicoDirectSDK/IDSession.h>

@interface IDPaymentProductViewController : UITableViewController <IDSwitchTableViewCellDelegate>

@property (weak, nonatomic) id <IDPaymentRequestTarget> paymentRequestTarget;
@property (strong, nonatomic) IDViewFactory *viewFactory;
@property (nonatomic) NSObject<IDPaymentItem> *paymentItem;
@property (strong, nonatomic) IDPaymentProduct *initialPaymentProduct;
@property (strong, nonatomic) IDAccountOnFile *accountOnFile;
@property (strong, nonatomic) IDPaymentContext *context;
@property (nonatomic) NSUInteger amount;
@property (strong, nonatomic) IDSession *session;
@property (strong, nonatomic) NSMutableSet *confirmedPaymentProducts;
@property (strong, nonatomic) NSMutableArray *formRows;
@property (strong, nonatomic) IDPaymentProductInputData *inputData;
@property (nonatomic, readonly) BOOL validation;
@property (nonatomic) BOOL switching;

- (void) addExtraRows;
- (void) registerReuseIdentifiers;
- (void)updatePickerCell:(IDPickerViewTableViewCell *)cell row: (IDFormRowList *)list;
- (void) updateTextFieldCell:(IDTextFieldTableViewCell *)cell row: (IDFormRowTextField *)row;
- (void)updateSwitchCell:(IDSwitchTableViewCell *)cell row: (IDFormRowSwitch *)row;
- (IDTextFieldTableViewCell *)cellForTextField:(IDFormRowTextField *)row tableView:(UITableView *)tableView;
- (IDTableViewCell *)formRowCellForRow:(IDFormRow *)row atIndexPath:(NSIndexPath *)indexPath;
- (void)switchToPaymentProduct:(NSString *)paymentProductId;
- (void)updateFormRows;
- (void)formatAndUpdateCharactersFromTextField:(UITextField *)texField cursorPosition:(NSInteger *)position indexPath:(NSIndexPath *)indexPath;
- (void)initializeFormRows;
- (void)validateExceptFields:(NSSet *)fields;
- (void)pickerView:(IDPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
