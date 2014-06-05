//
//  BNRItem.h
//  RandomItems
//
//  Created by Julian Huff on 2014-04-19.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

@property NSString *itemName;
@property NSString *serialNumber;
@property int valueInDollars;
@property NSDate *dateCreated;

+ (instancetype)randomItem;

//Designated init method
- (instancetype)initWithItemName:(NSString *) name
                  valueInDollars:(int) value
                    serialNumber:(NSString *) sNumber;

- (instancetype)initWithItemName:(NSString *) name;

@end
