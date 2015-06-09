//
//  CommonViews.h
//  IBMtaskDW
//
//  Created by Geno on 6/8/15.
//  Copyright (c) 2015 Geno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonViews : NSObject

+ (UILabel *)labelView:(NSString *)title frame:(CGRect)frame;

+ (UIImageView *)logo:(UIInterfaceOrientation)orientation;
+ (UIImageView *)imageView:(NSString*)imageName frame:(CGRect)frame topInset:(CGFloat)topInset leftInset:(CGFloat)leftInset bottomInset:(CGFloat)bottomInset rightInset:(CGFloat)rightInset;
+ (UILabel *)subtitleLabelView:(NSString *)title frame:(CGRect)frame;
+ (UIButton *)horizontalTabButton:(id)target
                         selector:(SEL)selector
                            frame:(CGRect)frame;
+ (void)setHorizontalTabButtonBg:(UIButton*)button
                        selected:(BOOL)selected;
+(void)roundView:(UIView *)view onCorner:(UIRectCorner)rectCorner radius:(float)radius;

@end
