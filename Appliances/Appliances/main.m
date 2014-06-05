//
//  main.m
//  Appliances
//
//  Created by Julian Huff on 2014-04-15.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRAppliance.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        BNRAppliance *a = [[BNRAppliance alloc] init];
        
        NSLog(@"a is a %@", a);
        [a setProductName:@"Washing machine"];
        [a setVoltage:240];
        NSLog(@"a is a %@", a);
        
    }
    return 0;
}

