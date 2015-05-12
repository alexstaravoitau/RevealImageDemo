//
//  UIColor+Hex.h
//  CVSample
//
//  Created by Alex Staravoitau on 16/4/14.
//  Copyright (c) 2014 Old Yellow Bricks. All rights reserved.
//
//  A very straightforward class to get a color object from its HEX
//  representation — and a couple of other color-related methods.

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(NSString *)hex;
- (UIColor *)lightColor;

@end
