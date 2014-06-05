//
//  BNROwnedAppliance.h
//  Appliances
//
//  Created by Julian Huff on 2014-04-15.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import "BNRAppliance.h"

@interface BNROwnedAppliance : BNRAppliance

@property (readonly) NSSet *ownerNames;

//Designated initalizer
-(instancetype)initWithProductName:(NSString *) pn
                    firstOwnerName:(NSString *) n;
-(void)addOwnerName:(NSString *) n;
-(void)removeOwnerName:(NSString *) n;

@end
