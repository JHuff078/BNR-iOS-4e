//
//  main.m
//  VowelMovement
//
//  Created by Julian Huff on 2014-04-06.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // Create array of strings and a container for devowelized ones
        NSArray *originalStrings = @[@"Sauerkraut", @"Raygun", @"Big Nerd Ranch", @"Mississippi"];
        
        NSLog(@"original strings: %@", originalStrings);
        
        NSMutableArray *devowelizedStrings = [NSMutableArray array];
        
        // Create a list of characters to be removed from the string
        NSArray *vowels = @[@"a", @"e", @"i", @"o", @"u"];
        
        // Declare the block variable
        void (^devowelizer)(id, NSUInteger, BOOL *);
        
        //Compose a block and assign it to the variable
        devowelizer = ^(id string, NSUInteger i, BOOL *stop) {
            NSRange yRange = [string rangeOfString:@"y"
                                           options:NSCaseInsensitiveSearch];
            //Did I find a y?
            if (yRange.location != NSNotFound) {
                *stop = YES;
                return;
            }
            NSMutableString *newString = [NSMutableString stringWithString:string];
            
            //Iterate over teh array of cowels, replacing occurrences of each with an empty string
            for (NSString *s in vowels) {
                NSRange fullRange = NSMakeRange(0, [newString length]);
                [newString replaceOccurrencesOfString:s
                                           withString:@""
                                              options:NSCaseInsensitiveSearch
                                                range:fullRange];
            }
            
            [devowelizedStrings addObject:newString];
        };
        
        //Iterate over the array with your block
        [originalStrings enumerateObjectsUsingBlock:devowelizer];
        NSLog(@"devowelized strings: %@", devowelizedStrings);
        
    }
    return 0;
}

