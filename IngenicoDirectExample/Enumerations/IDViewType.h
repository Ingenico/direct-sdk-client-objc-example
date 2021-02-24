//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#ifndef IDViewType_h
#define IDViewType_h

typedef enum {
    // Switches
    IDSwitchType,
    
    // PickerViews
    IDPickerViewType,
    
    // TextFields
    IDTextFieldType,
    IDIntegerTextFieldType,
    IDFractionalTextFieldType,
    
    // Labels
    IDLabelType,

    // TableViewCells
    IDPaymentProductTableViewCellType,
    IDTextFieldTableViewCellType,
    IDCurrencyTableViewCellType,
    IDErrorMessageTableViewCellType,
    IDSwitchTableViewCellType,
    IDPickerViewTableViewCellType,
    IDButtonTableViewCellType,
    IDLabelTableViewCellType,
    IDTooltipTableViewCellType,
    IDCoBrandsSelectionTableViewCellType,
    IDCoBrandsExplanationTableViewCellType,

    // TableHeaderView
    IDSummaryTableHeaderViewType,
    
    //TableFooterView
    IDButtonsTableFooterViewType
    
} IDViewType;

#endif /* IDViewType_h */
