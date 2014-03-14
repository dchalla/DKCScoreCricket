//
//  NSDictionary+MutableDeepCopy.m
//  Score Cricket
//
//  Created by Dinesh Challa on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+MutableDeepCopy.h"

@implementation NSDictionary (MutableDeepCopy)

- (NSMutableDictionary *) mutableDeepCopy {
    NSMutableDictionary *mutableCopy = (__bridge_transfer NSMutableDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge_retained CFDictionaryRef)self, kCFPropertyListMutableContainers);
    return mutableCopy;
}

@end
