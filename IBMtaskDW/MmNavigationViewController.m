//
//  MmNavigationViewController.m
//  IBMtaskDW
//
//  Created by Geno on 6/8/15.
//  Copyright (c) 2015 Geno. All rights reserved.
//

#import "MmNavigationViewController.h"

@interface MmNavigationViewController ()

@end

@implementation MmNavigationViewController

-(id)initWithRootViewController:(UIViewController*)viewController{

    return [super initWithRootViewController:viewController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // You do not need this method if you are not supporting earlier iOS Versions
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end
