//
//  NSTextView+Extension.m
//  JSONMapping
//
//  Created by BraveShine on 2021/1/8.
//

#import "NSTextView+Extension.h"
#import <objc/runtime.h>

@implementation NSTextView (Extension)


+ (void)load{
    Method m1 = class_getInstanceMethod([NSTextView class], @selector(initWithFrame:));
    Method m2 = class_getInstanceMethod([NSTextView class], @selector(_initWithFrame:));
    method_exchangeImplementations(m1, m2);
}

-(instancetype)_initWithFrame:(NSRect)frameRect{
    NSTextView * obj = [self _initWithFrame:frameRect];
    obj.automaticQuoteSubstitutionEnabled = NO;
    return  obj;
}

@end
