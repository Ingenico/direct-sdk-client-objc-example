//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDCoBrandsSelectionTableViewCell.h"
#import <IngenicoDirectSDK/IDSDKConstants.h>

@implementation IDCoBrandsSelectionTableViewCell

+ (NSString *)reuseIdentifier {
    return @"co-brand-selection-cell";
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *font = [UIFont systemFontOfSize:13];
        NSDictionary *underlineAttribute = @{
                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                NSFontAttributeName: font
        };

        NSBundle *sdkBundle = [NSBundle bundleWithPath:kIDSDKBundlePath];
        NSString *cobrandsKey = @"gc.general.cobrands.toggleCobrands";
        NSString *cobrandsString = NSLocalizedStringFromTableInBundle(cobrandsKey, kIDSDKLocalizable, sdkBundle, nil);
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cobrandsString
                                                                 attributes:underlineAttribute];
        self.textLabel.textAlignment = NSTextAlignmentRight;
        
        self.clipsToBounds = YES;
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [super accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [super accessoryCompatibleLeftMargin];
    self.textLabel.frame = CGRectMake(leftMargin, 4, width, self.textLabel.frame.size.height);;
}

@end
