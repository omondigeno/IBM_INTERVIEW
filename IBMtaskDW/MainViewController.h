//
//  MainViewController.h
//  IBMtaskDW
//
//  Created by Geno on 6/8/15.
//  Copyright (c) 2015 Geno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyTableView.h"
#import "EColumnChart.h"

@interface MainViewController : UIViewController <EColumnChartDelegate, EColumnChartDataSource, EasyTableViewDelegate>

@end
