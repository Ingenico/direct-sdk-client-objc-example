//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDViewFactory.h"
#import "IDIntegerTextField.h"
#import "IDFractionalTextField.h"
#import "IDSummaryTableHeaderView.h"

@implementation IDViewFactory

- (IDButton *)buttonWithType:(IDButtonType)type
{
    IDButton *button = [IDButton new];
    button.type = type;
    
    return button;
}

- (IDSwitch *)switchWithType:(IDViewType)type
{
    IDSwitch *switchControl;
    switch (type) {
        case IDSwitchType:
            switchControl = [[IDSwitch alloc] init];
            break;
        default:
            [NSException raise:@"Invalid switch type" format:@"Switch type %u is invalid", type];
            break;
    }
    return switchControl;
}

- (IDTextField *)textFieldWithType:(IDViewType)type
{
    IDTextField *textField;
    switch (type) {
        case IDTextFieldType:
            textField = [[IDTextField alloc] init];
            break;
        case IDIntegerTextFieldType:
            textField = [[IDIntegerTextField alloc] init];
            break;
        case IDFractionalTextFieldType:
            textField = [[IDFractionalTextField alloc] init];
            break;
        default:
            [NSException raise:@"Invalid text field type" format:@"Text field type %u is invalid", type];
            break;
    }
    return textField;
}

- (IDPickerView *)pickerViewWithType:(IDViewType)type
{
    IDPickerView *pickerView;
    switch (type) {
        case IDPickerViewType:
            pickerView = [[IDPickerView alloc] init];
            break;
        default:
            [NSException raise:@"Invalid picker view type" format:@"Picker view type %u is invalid", type];
            break;
    }
    return pickerView;
}

- (IDLabel *)labelWithType:(IDViewType)type
{
    IDLabel *label;
    switch (type) {
        case IDLabelType:
            label = [[IDLabel alloc] init];
            break;
        default:
            [NSException raise:@"Invalid label type" format:@"Label type %u is invalid", type];
            break;
    }
    return label;
}

- (UIView *)tableHeaderViewWithType:(IDViewType)type frame:(CGRect)frame
{
    UIView *view;
    switch (type) {
        case IDSummaryTableHeaderViewType:
            view = [[IDSummaryTableHeaderView alloc] initWithFrame:frame];
            break;
        default:
            [NSException raise:@"Invalid table header view type" format:@"Table header view type %u is invalid", type];
            break;
    }
    return view;
}

@end
