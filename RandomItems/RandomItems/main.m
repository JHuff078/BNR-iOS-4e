//
//  main.m
//  RandomItems
//
//  Created by Julian Huff on 2014-04-19.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        //Create a mutable array
        NSMutableArray *items = [[NSMutableArray alloc] init];
   
//        [items addObject:@"One"];
//        [items addObject:@"Two"];
//        [items addObject:@"Three"];
//        
//        [items insertObject:@"Zero" atIndex:0];
//        
//        //Fast enum
//        for (NSString *item in items) {
//            NSLog(@"%@", item);
//        }
//        
//        BNRItem *item = [[BNRItem alloc] initWithItemName:@"Blue sofa"
//                                           valueInDollars:100
//                                             serialNumber:@"AAAA"];
//        NSLog(@"%@]", item);
//        
//        BNRItem *itemWithJustName = [[BNRItem alloc] initWithItemName:@"Just a name"];
//        NSLog(@"%@]", itemWithJustName);
//        
//        BNRItem *itemWithNoName = [[BNRItem alloc] init];
//        NSLog(@"%@]", itemWithNoName);

        for (int i = 0; i < 10; i++) {
            BNRItem *item = [BNRItem randomItem];
            [items addObject:item];
        }
        
        for (BNRItem *item in items) {
            NSLog(@"%@", item);
        }
        
        items = nil;
    }
    return 0;
}

