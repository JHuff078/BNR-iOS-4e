//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Julian Huff on 2014-06-03.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
