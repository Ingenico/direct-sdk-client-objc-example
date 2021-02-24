//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"
#import "IDPickerView.h"
#import <IngenicoDirectSDK/IDValueMappingItem.h>
#import <IngenicoDirectSDK/IDPaymentProductField.h>

@interface IDPickerViewTableViewCell : IDTableViewCell {
    BOOL _readonly;
}

@property (strong, nonatomic) NSArray<IDValueMappingItem *> *items;
@property (strong, nonatomic) NSObject<UIPickerViewDelegate> *delegate;
@property (strong, nonatomic) NSObject<UIPickerViewDataSource> *dataSource;
@property (assign, nonatomic) NSInteger selectedRow;
@property (assign, nonatomic) BOOL readonly;

+ (NSUInteger)pickerHeight;
+ (NSString *)reuseIdentifier;

@end
