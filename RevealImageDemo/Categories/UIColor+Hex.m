//
//  UIColor+Hex.m
//  CVSample
//
//  Created by Alex Staravoitau on 16/4/14.
//  Copyright (c) 2014 Old Yellow Bricks. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSString *)hex {
    unsigned int scanResult;
    [[NSScanner scannerWithString:hex] scanHexInt:&scanResult];

    float r = ((scanResult >> 16) & 0xFF) / 255.0f;
    float g = ((scanResult >> 8) & 0xFF) / 255.0f;
    float b = ((scanResult >> 0) & 0xFF) / 255.0f;

    return [UIColor colorWithRed:r
                           green:g
                            blue:b
                           alpha:1.0f];
}

- (UIColor *)lightColor {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.15, 1.0)
                               green:MIN(g + 0.15, 1.0)
                                blue:MIN(b + 0.15, 1.0)
                               alpha:a];
    return nil;
}

@end
