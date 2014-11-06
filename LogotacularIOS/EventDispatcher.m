//
//  EventDispatcher.m
//  LogotacularIOS
//
//  Created by John on 27/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "EventDispatcher.h"
#import "PCommandMap.h"
#import <Objection/Objection.h>
#import "AbstractCommand.h"
#import "PLogger.h"

@interface EventDispatcher ()

@property id<PCommandMap> commandMap;
@property id<PLogger> logger;

@end

@implementation EventDispatcher

- (void) addListener:(NSString*) eventName toFunction:(SEL)action withContext:(id)context{
	[[NSNotificationCenter defaultCenter] addObserver:context selector:action name:eventName object:nil];
}

- (void) removeListener:(NSString*) eventName toFunction:(SEL)action withContext:(id)context{
	[[NSNotificationCenter defaultCenter] removeObserver:context name:eventName object:nil];
}

- (id<PCommandMap>) getCommandMap{
	if(!self.commandMap){
		self.commandMap = [[JSObjection defaultInjector] getObject:@protocol(PCommandMap)];
	}
	return self.commandMap;
}

- (void) executeCommand:(NSString*) eventName withData:(id)data{
	Class CommandClass = [[self getCommandMap] getForEventName:eventName];
	if(CommandClass){
		AbstractCommand* cmd = [[CommandClass alloc] init];
		if(cmd){
			[cmd execute:data];
		}
	}
}
				   
- (void) dispatch:(NSString*) eventName withData:(id)data{
	[self executeCommand:eventName withData:data];
	[[NSNotificationCenter defaultCenter] postNotificationName:eventName object:data];
}

@end
