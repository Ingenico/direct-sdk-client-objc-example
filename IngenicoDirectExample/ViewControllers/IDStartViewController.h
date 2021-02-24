//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <PassKit/PassKit.h>

#import "IDPaymentProductSelectionTarget.h"
#import "IDPaymentRequestTarget.h"
#import "IDContinueShoppingTarget.h"
#import "IDPaymentFinishedTarget.h"

@interface IDStartViewController : UIViewController <IDContinueShoppingTarget, IDPaymentFinishedTarget>

@end
