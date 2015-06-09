//
//  MmAppDelegate.h
//  IBMtaskDW
//
//  Created by Geno on 6/8/15.
//  Copyright (c) 2015 Geno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmNavigationViewController.h"

@interface MmAppDelegate : UIApplication <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MmNavigationViewController *navigationController;

- (void)setNavigationBarBg;

@end
