//
//  Constants.h
//  IBMtaskDW
//
//  Created by Nelson on 6/8/15.
//  Copyright (c) 2015 Geno. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LAYOUT_LEFT_OUTER_X_POS 5.0f
#define LAYOUT_LEFT_INNER_X_POS 0.0f
#define LAYOUT_LEVEL_2_VIEW_START_Y_POS 0.0f
#define LAYOUT_VIEW_HEIGHT 30.0f
#define LAYOUT_STANDARD_VIEW_MARGIN_IPHONE 5.0f
#define LAYOUT_Y_POSITION_AFTER_TITLE 52.0f
#define LAYOUT_INNER_CONTAINER_VIEW_MARGIN_IPHONE 2.0f
#define LAYOUT_INNER_INNER_CONTAINER_VIEW_MARGIN_IPHONE 5.0f


#define LAYOUT_HORIZONTAL_TAB_BUTTON_WIDTH_WIDE 210.0f
#define LAYOUT_HORIZONTAL_TAB_BUTTON_HEIGHT 40.0f
#define LAYOUT_CONTENT_BG_CORNER_RADIUS 10.0f


#define ANIMATION_DURATION 1.0f

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface Constants : NSObject

@end
