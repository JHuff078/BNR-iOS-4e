//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by Julian Huff on 2014-06-21.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"


@implementation BNRDrawViewController

- (void)loadView {
    self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}

@end
