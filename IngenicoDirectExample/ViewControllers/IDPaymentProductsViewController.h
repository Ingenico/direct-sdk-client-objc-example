//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDPaymentProductSelectionTarget.h"
#import "IDViewFactory.h"

#import <IngenicoDirectSDK/IDBasicPaymentProducts.h>

@class IDPaymentItems;

@interface IDPaymentProductsViewController : UITableViewController

@property (strong, nonatomic) IDViewFactory *viewFactory;
@property (weak, nonatomic) id <IDPaymentProductSelectionTarget> target;
@property (strong, nonatomic) IDPaymentItems *paymentItems;
@property (nonatomic) NSInteger amount;
@property (strong, nonatomic) NSString *currencyCode;

@end
