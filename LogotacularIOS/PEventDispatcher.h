//
//  PEventDispatcher.h
//  LogotacularIOS
//
//  Created by John on 28/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PEventDispatcher <NSObject>

- (void) addListener:(NSString*) eventName toFunction:(SEL)action withContext:(id)context;

- (void) removeListener:(NSString*) eventName toFunction:(SEL)action withContext:(id)context;

- (void) dispatch:(NSString*) eventName withData:(id)data;

@end
