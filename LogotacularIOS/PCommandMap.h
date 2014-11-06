//
//  PCommandMap.h
//  LogotacularIOS
//
//  Created by John on 27/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Objection/Objection.h>

@protocol PCommandMap <NSObject>

- (void) mapEventName:(NSString*)eventName toCommandClass:(Class)class;
- (Class) getForEventName:(NSString*) eventName;

@end
