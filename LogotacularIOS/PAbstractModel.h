//
//  PAbstractModel.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PAbstractModel <NSObject>

- (NSArray*) getKeys;

- (id) getVal:(NSString*)key;

- (void) setVal:(id)val forKey:(NSString*)key;

- (void) addListener:(SEL)action forKey:(NSString*)key withTarget:(id)target;

- (void) removeListener:(SEL)action forKey:(NSString*)key withTarget:(id)target;

- (void) addGlobalListener:(SEL)action withTarget:(id)target;

- (void) removeGlobalListener:(SEL)action withTarget:(id)target;

- (void) toggleBoolValForKey:(NSString*)key;

- (void) incrementValForKey:(NSString*)key;

@end
