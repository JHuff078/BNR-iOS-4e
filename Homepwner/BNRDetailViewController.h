//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Julian Huff on 2014-05-24.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController

- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) BNRItem *item;

@end
