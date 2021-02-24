//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDPaymentType.h"

@interface IDPaymentProductsTableSection : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *rows;
@property (nonatomic) IDPaymentType type;

@end
