//
//  ViewController.m
//  RevealImageDemo
//
//  Created by Alex Staravoitau on 12/05/2015.
//  Copyright (c) 2015 Old Yellow Bricks. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Hex.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *viewToDrawOn;
@property (nonatomic, weak) IBOutlet UIView *imageToReveal;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // A small dramatic pause, to make sure the view is fully visible and the user is thrilled to see our work
    dispatch_time_t timeToShow = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(timeToShow, dispatch_get_main_queue(), ^{
        [self triggerAnimations];
    });
}

CGFloat const kAnimationDuration = 0.7f;

- (void) triggerAnimations {
    //And now we trigger both the outline and reveal animations for the userpic image, the transition to show the comment will be triggered in the callback when these animations will finish
    [self drawUserpicOutline];
    [self revealUserpic];
}

- (void) drawUserpicOutline {
    //The shape of the outline — circle, obviously
    CAShapeLayer *circle = [CAShapeLayer layer];
    //It should cover the whole view, so...
    CGFloat radius = self.viewToDrawOn.frame.size.width / 2.0f;
    circle.position = CGPointZero;
    circle.path = [UIBezierPath bezierPathWithRoundedRect:self.viewToDrawOn.bounds
                                             cornerRadius:radius].CGPath;
    //We set the stroke color and fill color of the shape
    circle.fillColor = [UIColor clearColor].CGColor;
    //Don't freak out, I'm simply using a UIColor category that creates UIColor objects out of a string holding its hex value.
    circle.strokeColor = [UIColor colorWithHex:@"ffd800"].CGColor;
    circle.lineWidth = 1.0f;
    [self.viewToDrawOn.layer addSublayer:circle];
    
    //Here we create the animation itself, We're animating the end position of the stroke, which will gradually change from 0 to 1 (making a full circle)
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = kAnimationDuration;
    drawAnimation.repeatCount = 1.0;
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [circle addAnimation:drawAnimation forKey:@"drawUserpicOutlineAnimation"];
    
}

- (void) revealUserpic {
    //The initial and final radius' values of the shapes
    CGFloat initialRadius = 1.0f;
    CGFloat finalRadius = self.imageToReveal.bounds.size.width / 2.0f;
    
    //Creating the shape of revealing mask
    CAShapeLayer *revealShape = [CAShapeLayer layer];
    revealShape.bounds = self.imageToReveal.bounds;
    //We need to set the fill color to some — since it's a mask shape layer
    revealShape.fillColor = [UIColor blackColor].CGColor;
    
    //A set of two paths — the initial and final ones
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMidX(self.imageToReveal.bounds) - initialRadius,
                                                                                 CGRectGetMidY(self.imageToReveal.bounds) - initialRadius, initialRadius * 2, initialRadius * 2)
                                                         cornerRadius:initialRadius];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:self.imageToReveal.bounds
                                                       cornerRadius:finalRadius];
    revealShape.path = startPath.CGPath;
    revealShape.position = CGPointMake(CGRectGetMidX(self.imageToReveal.bounds) - initialRadius,
                                       CGRectGetMidY(self.imageToReveal.bounds) - initialRadius);
    
    //So now we've masked the image, only the portion that is covered with the circle layer will be visible
    self.imageToReveal.layer.mask = revealShape;
    
    //That's the animation. What we animate is the "path" property — from a tiny dot in the center of the image to a large filled circle covering the whole image.
    CABasicAnimation *revealAnimationPath = [CABasicAnimation animationWithKeyPath:@"path"];
    revealAnimationPath.fromValue = (__bridge id)(startPath.CGPath);
    revealAnimationPath.toValue = (__bridge id)(endPath.CGPath);
    revealAnimationPath.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    revealAnimationPath.duration = kAnimationDuration/2.0f;
    revealAnimationPath.repeatCount = 1.0f;
    //Set the begin time, so that the image starts appearing when the outline animation is already halfway through
    revealAnimationPath.beginTime = CACurrentMediaTime() + kAnimationDuration/2.0f;
    revealAnimationPath.delegate = self;
    //Since we start the image reveal animation with a delay, we will need to wait to make the image visible as well
    dispatch_time_t timeToShow = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimationDuration/2.0f * NSEC_PER_SEC));
    dispatch_after(timeToShow, dispatch_get_main_queue(), ^{
        self.imageToReveal.hidden = NO;
    });
    
    revealShape.path = endPath.CGPath;
    [revealShape addAnimation:revealAnimationPath forKey:@"revealUserpicAnimation"];
    
}


@end
