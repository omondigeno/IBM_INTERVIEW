//
//  Utils.m
//  IBMtaskDW
//
//  Created by Geno on 6/8/15.
//  Copyright (c) 2015 Geno. All rights reserved.
//

#import "Utils.h"
#import "Constants.h"

@implementation Utils

+ (NSData*)readFileData:(NSString *)name type: (NSString *)type
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if (filePath) {
        NSData *myData = [NSData dataWithContentsOfFile:filePath];
        if (myData) {
            return myData;
        }
    }
    return nil;
}

@end
