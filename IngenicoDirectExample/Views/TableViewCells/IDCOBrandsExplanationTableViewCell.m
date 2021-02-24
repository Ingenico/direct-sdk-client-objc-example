//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDCOBrandsExplanationTableViewCell.h"
#import <IngenicoDirectSDK/IDSDKConstants.h>

@interface IDCOBrandsExplanationTableViewCell ()

@property (nonatomic, strong) UIView *limitedBackgroundView;

@end

@implementation IDCOBrandsExplanationTableViewCell

+ (NSString *)reuseIdentifier {
    return @"co-brand-explanation-cell";
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.limitedBackgroundView = [[UIView alloc]init];
        self.textLabel.attributedText = [IDCOBrandsExplanationTableViewCell cellString];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.clipsToBounds = YES;
        [self.limitedBackgroundView addSubview:self.textLabel];
        self.limitedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.contentView addSubview:self.limitedBackgroundView];
    }

    return self;
}

+ (NSAttributedString *)cellString {
    UIFont *font = [UIFont systemFontOfSize:12];
    NSDictionary *fontAttribute = @{
            NSFontAttributeName: font
    };
    NSBundle *sdkBundle = [NSBundle bundleWithPath:kIDSDKBundlePath];
    NSString *cellKey = @"gc.general.cobrands.introText";
    NSString *cellString = NSLocalizedStringFromTableInBundle(cellKey, kIDSDKLocalizable, sdkBundle, nil);
    NSAttributedString *cellStringWithFont = [[NSAttributedString alloc] initWithString:cellString
                                                                             attributes:fontAttribute];
    return cellStringWithFont;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [super accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [super accessoryCompatibleLeftMargin];
    self.limitedBackgroundView.frame = CGRectMake(leftMargin, 4, width, self.textLabel.frame.size.height);
    self.textLabel.frame = self.limitedBackgroundView.bounds;
}

@end
