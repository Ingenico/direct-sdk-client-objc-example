//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDContinueShoppingTarget.h"
#import "IDViewFactory.h"

@interface IDEndViewController : UIViewController

@property (weak, nonatomic) id <IDContinueShoppingTarget> target;
@property (strong, nonatomic) IDViewFactory *viewFactory;

@end
