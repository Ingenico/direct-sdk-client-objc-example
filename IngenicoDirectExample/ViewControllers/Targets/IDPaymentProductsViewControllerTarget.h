//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <PassKit/PassKit.h>

#import "IDPaymentProductSelectionTarget.h"
#import "IDPaymentRequestTarget.h"
#import "IDPaymentFinishedTarget.h"
#import "IDSession.h"
#import "IDViewFactory.h"

@interface IDPaymentProductsViewControllerTarget : NSObject <IDPaymentProductSelectionTarget, IDPaymentRequestTarget, PKPaymentAuthorizationViewControllerDelegate>

@property (weak, nonatomic) id <IDPaymentFinishedTarget> paymentFinishedTarget;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController session:(IDSession *)session context:(IDPaymentContext *)context viewFactory:(IDViewFactory *)viewFactory;
- (void)didSubmitPaymentRequest:(IDPaymentRequest *)paymentRequest success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)showApplePaySheetForPaymentProduct:(IDPaymentProduct *)paymentProduct withAvailableNetworks:(IDPaymentProductNetworks *)paymentProductNetworks;

@end
