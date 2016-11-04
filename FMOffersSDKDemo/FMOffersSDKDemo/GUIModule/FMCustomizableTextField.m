//
//  FMCustomizableTextField.m
//  FMOffersSDKDemo
//
//  Created by Nazmul on 11/1/16.
//  Copyright © 2016 zinnuree. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FMCustomizableTextField.h"

@implementation FMCustomizableTextField

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.borderColor = [UIColor clearColor];
        self.borderWidth = 0;
        self.cornerRadius = 0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.borderColor = self.borderColor.CGColor;
        self.layer.borderWidth = self.borderWidth;
        self.layer.cornerRadius = self.cornerRadius;
    }
    return self;
}

- (void)prepareForInterfaceBuilder {
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.layer.cornerRadius = self.cornerRadius;
}

- (void)drawRect:(CGRect)rect {
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.layer.cornerRadius = self.cornerRadius;
}

// placeholder padding
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 5);
}

// text padding
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 5);
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

@end
