//
//  CommonViews.m
//  IBMtaskDW
//
//  Created by Geno on 6/8/15.
//  Copyright (c) 2015 Geno. All rights reserved.
//

#import "CommonViews.h"
#import "ViewTags.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@implementation CommonViews


+ (UILabel *)labelView:(NSString *)title frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]
                      initWithFrame:frame];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];

    return label;
}

+ (UIImageView *)logo:(UIInterfaceOrientation)orientation{
    CGRect frame;
    UIImage *img;

    frame = CGRectMake(0, 0, 175, 60);
        img = [UIImage imageNamed:@"logo.png"];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = frame;
    
    return imageView;
}

+ (UIImageView *)imageView:(NSString*)imageName frame:(CGRect)frame topInset:(CGFloat)topInset leftInset:(CGFloat)leftInset bottomInset:(CGFloat)bottomInset rightInset:(CGFloat)rightInset{
    UIImage *img = [UIImage imageNamed:imageName];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(topInset, leftInset,
                                                                bottomInset,
                                                                rightInset)];
    }else{
        img = [img stretchableImageWithLeftCapWidth:(NSInteger)leftInset topCapHeight:(NSInteger)topInset];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.frame = frame;
    imageView.autoresizingMask = UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth;

    return imageView;
}

+ (UILabel *)subtitleLabelView:(NSString *)title frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]
                      initWithFrame:frame];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    
    return label;
}

+ (UIButton *)horizontalTabButton:(id)target
                     selector:(SEL)selector
                        frame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.backgroundColor = [UIColor clearColor];    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];

    return button;
}

+ (void)setHorizontalTabButtonBg:(UIButton*)button
                         selected:(BOOL)selected
{
    NSString *postFix = @".png";
    NSString *postFixSelected = @"_selected.png";
    
    UIImage *image;
    if(!selected){
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", @"horizontal_list_item_bg", postFix]];
    }else{
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", @"horizontal_list_item_bg", postFixSelected]];
    }
    
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:52.0 topCapHeight:19.0];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    
}

+(void)roundView:(UIView *)view onCorner:(UIRectCorner)rectCorner radius:(float)radius

{
    view.layer.masksToBounds = YES;
    
UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:rectCorner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    
    view.layer.mask = maskLayer;
    
    CAShapeLayer*   frameLayer = [CAShapeLayer layer];
    frameLayer.frame = view.bounds;
    frameLayer.path = maskPath.CGPath;
    frameLayer.strokeColor = [UIColor colorWithRed:147.0f/256.0f green:5.0f/256.0f blue:5.0f/256.0f alpha:1.0f].CGColor;
    frameLayer.fillColor = [UIColor colorWithRed:147.0f/256.0f green:5.0f/256.0f blue:5.0f/256.0f alpha:1.0f].CGColor;

    frameLayer.lineWidth = 5;

    [view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
 [view.layer addSublayer:frameLayer];
    //[view.layer setMask:maskLayer];
}

@end
