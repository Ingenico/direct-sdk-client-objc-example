//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDPickerViewTableViewCell.h"

@interface IDDetailedPickerViewCell : IDPickerViewTableViewCell <UIPickerViewDelegate>

@property (nonatomic, strong) NSNumberFormatter *currencyFormatter;
@property (nonatomic, strong) NSNumberFormatter *percentFormatter;
@property (nonatomic, strong) NSString *fieldIdentifier;
@property (nonatomic, strong) NSString *errorMessage;

@end
