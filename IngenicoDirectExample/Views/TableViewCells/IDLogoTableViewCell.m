//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "IDLogoTableViewCell.h"

static CGFloat kIDLogoTableViewCellWidth = 140;

@implementation IDLogoTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

+ (NSString *)reuseIdentifier {
    return @"logo-cell";
}

- (CGSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(kIDLogoTableViewCellWidth, [self sizeTransformedFrom:self.displayImageView.image.size toTargetWidth:kIDLogoTableViewCellWidth].height);
}

- (void)layoutSubviews {
    CGFloat newWidth = kIDLogoTableViewCellWidth;
    CGFloat newHeigh = [self sizeTransformedFrom:self.displayImage.size toTargetWidth:kIDLogoTableViewCellWidth].height;
    
    self.displayImageView.frame = CGRectMake(CGRectGetMidX(self.frame) - newWidth/2, 0, newWidth, newHeigh);
}
@end
