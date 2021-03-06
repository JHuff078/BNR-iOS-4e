//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by Julian Huff on 2014-06-21.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@property (nonatomic, weak) BNRLine *selectedLine;

@end

@implementation BNRDrawView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)r {
    self = [super initWithFrame:r];
    
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES;
        
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                      action:@selector(longPress:)];
        
        [self addGestureRecognizer:pressRecognizer];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
    }
    
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}

#pragma mark - Touch messages

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //Log statement to see the order of the events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //Log statement to see the order of the events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        
        line.end = [t locationInView:self];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //Log statement to see the order of the events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];

        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //Log statement to see the order of the events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Tap messages

- (void)doubleTap:(UIGestureRecognizer *)gr {
    NSLog(@"Recoginzed a double tap");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)tap:(UIGestureRecognizer *)gr {
    NSLog(@"Recognized a single tap");
    
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    if (self.selectedLine) {
        //Make ourselves the target of the menu item action messages
        [self becomeFirstResponder];
        
        //Grab the menu controller
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        //Create a new delete menu item
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete"
                                                        action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        
        //Tell the menu item where it should come from and show it
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2)
                     inView:self];
        [menu setMenuVisible:YES
                    animated:YES];
    } else {
        //Hide the menu if no line is selected
        [[UIMenuController sharedMenuController] setMenuVisible:NO
                                                       animated:YES];
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Press messages

- (void)longPress:(UIGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    } else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Pan messages

- (void)moveLine:(UIPanGestureRecognizer *)gr {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    //If we haven't selected a line, don't do anything
    if (!self.selectedLine || [menu isMenuVisible]) {
        return;
    }
    
    //When the pan recognizer changes its position…
    if (gr.state == UIGestureRecognizerStateChanged) {
        //How far has the pan moved?
        CGPoint translation = [gr translationInView:self];
        
        //Add the translation to the beginning and end points of the line
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        //Set the new beginning and endpoints of the line
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        //Redraw the screen
        [self setNeedsDisplay];
        
        [gr setTranslation:CGPointZero
                    inView:self];
    }
}

#pragma mark - Line messages

- (void)strokeLine:(BNRLine *)line {
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect {
    //Draw finished lines in black
    [[UIColor blackColor] set];
    for (BNRLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        
        [self strokeLine:self.selectedLine];
    }
}

- (BNRLine *)lineAtPoint:(CGPoint)p {
    //Find a line close to p
    for (BNRLine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        //Check a few points on the line
        for (float t = 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            //If the tapped point is within 20 points of this line, let's pick it
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return l;
            }
        }
    }
    
    //If nothing is close enough, we return nil
    return nil;
}

#pragma mark - UIMenuController messages

- (void)deleteLine:(id)sender {
    //Remove the selected line from the list of _finishedLines
    [self.finishedLines removeObject:self.selectedLine];
    
    //Redraw everything
    [self setNeedsDisplay];
}

@end
