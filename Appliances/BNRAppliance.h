//
//  BNRAppliance.h
//  Appliances
//
//  Created by Julian Huff on 2014-04-15.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRAppliance : NSObject

@property (nonatomic, copy) NSString *productName;
@property (nonatomic) int voltage;

//Designated initalizer
-(instancetype)initWithProductName:(NSString *) pn;

@end
