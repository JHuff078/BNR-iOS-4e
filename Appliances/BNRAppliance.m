//
//  BNRAppliance.m
//  Appliances
//
//  Created by Julian Huff on 2014-04-15.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import "BNRAppliance.h"

@implementation BNRAppliance

-(instancetype)init {
    
    return [self initWithProductName:@"Unknown"];
}

-(instancetype)initWithProductName:(NSString *)pn {
    
    if (self = [super init]) {
        _productName = [pn copy];
        _voltage = 120;
        
        //Alternatively
        //[self setProductName:pn];
        //[self setVoltage:120];
    }
    
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<%@: %d volts", self.productName, self.voltage];
}

@end