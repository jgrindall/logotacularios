//
//  ErrorObject.m
//  LogotacularIOS
//
//  Created by John on 12/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ErrorObject.h"

@interface ErrorObject ()

@property NSDictionary* dic;

@end

@implementation ErrorObject

- (instancetype) initWithNSDictionary:(NSDictionary*)dic{
	self = [super init];
	if(self){
		_dic = dic;
	}
	return self;
}

- (NSNumber*) getLine{
	return self.dic[@"line"];
};

- (NSNumber*) getColumn{
	return self.dic[@"column"];
};

- (NSString*) getFound{
	return 	self.dic[@"found"];
};

- (NSString*) getErrorName{
	return 	self.dic[@"name"];
};

- (NSString*) getMessage{
	return 	self.dic[@"message"];
};

- (NSString*) filterMessage{
	NSString* message = [self getMessage];
	if([[message substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"Error"]){
		message = [message substringFromIndex:6];
	}
	BOOL expected = [message rangeOfString:@"Expected"].location != NSNotFound;
	BOOL endOfInput = [message rangeOfString:@"but"].location != NSNotFound;
	if(expected && endOfInput){
		NSString* found = [self getFound];
		if(!found || ![found isKindOfClass:[NSString class]] || [found isEqualToString:@"<null>"]){
			message = [NSString stringWithFormat:@"It looks like something is missing on this line"];
		}
		else{
			message = [NSString stringWithFormat:@"The '%@' here doesn't look right to me", found];
		}
		
	}
	return message;
}

- (NSString*) getHumanMessage{
	NSString* errorMessage;
	NSNumber* line = [self getLine];
	NSNumber* col = [self getColumn];
	NSString* message = [self filterMessage];
	if(line && col && message){
		errorMessage = [NSString stringWithFormat:@"Error on line %@ at position %@. %@", line, col, message];
	}
	if(line && message){
		errorMessage = [NSString stringWithFormat:@"Error on line %@. %@", line, message];
	}
	else if(message){
		errorMessage = [NSString stringWithFormat:@"Error: %@", message];
	}
	else{
		errorMessage = @"Unknown error";
	}
	return errorMessage;
}

@end
