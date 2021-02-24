//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "IDFormRowDate.h"

@implementation IDFormRowDate

-(void)setValue:(NSString *)value {
    if ([value length] > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMdd";
        self.date = [formatter dateFromString:value];
        if (self.date == NULL) {
            self.date = [NSDate date];
        }
    }
    else {
        self.date = [NSDate date];
    }
}

@end
