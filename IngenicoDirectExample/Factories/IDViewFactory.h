//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDViewType.h"
#import "IDTableViewCell.h"
#import "IDSwitch.h"
#import "IDTextField.h"
#import "IDPickerView.h"
#import "IDLabel.h"
#import "IDButton.h"

@interface IDViewFactory : NSObject

- (IDButton *)buttonWithType:(IDButtonType)type;
- (IDSwitch *)switchWithType:(IDViewType)type;
- (IDTextField *)textFieldWithType:(IDViewType)type;
- (IDPickerView *)pickerViewWithType:(IDViewType)type;
- (IDLabel *)labelWithType:(IDViewType)type;
- (UIView *)tableHeaderViewWithType:(IDViewType)type frame:(CGRect)frame;

@end

