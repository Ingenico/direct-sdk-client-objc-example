//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDTableViewCell.h"

@protocol IDDatePickerTableViewCellDelegate

-(void)datePicker:(UIDatePicker *)datePicker selectedNewDate:(NSDate *)newDate;

@end

@interface IDDatePickerTableViewCell : IDTableViewCell {
    NSDate *_date;
}

@property (nonatomic, weak) NSObject<IDDatePickerTableViewCellDelegate> *delegate;
@property (nonatomic, assign) BOOL readonly;
@property (nonatomic, strong) NSDate *date;

+(NSString *)reuseIdentifier;
+(NSUInteger)pickerHeight;

@end
