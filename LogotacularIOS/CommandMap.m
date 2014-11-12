//
//  CommandMap.m
//  LogotacularIOS
//
//  Created by John on 27/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "CommandMap.h"

@interface CommandMap ()

@property NSMutableDictionary* dic;

@end

@implementation CommandMap

objection_register(CommandMap)

- (instancetype) init{
	self = [super init];
	if(self){
		self.dic = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) mapEventName:(NSString*)eventName toCommandClass:(Class)class{
	self.dic[eventName] = class;
}

- (Class) getForEventName:(NSString*) eventName{
	id val = self.dic[eventName];
	return (Class)val;
}

@end
