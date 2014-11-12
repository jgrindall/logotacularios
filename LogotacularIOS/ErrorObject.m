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

- (NSString*) getHumanMessage{
	NSString* errorMessage;
	NSNumber* line = [self getLine];
	NSString* message = [self getMessage];
	if(line  && message){
		errorMessage = [NSString stringWithFormat:@"Error on line %@, %@", line, message];
	}
	else if(message){
		if([[message substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"Error"]){
			message = [message substringFromIndex:6];
		}
		errorMessage = [NSString stringWithFormat:@"Error: %@", message];
	}
	else{
		errorMessage = @"Unknown error";
	}
	NSLog(@"!!!!! %@ \n\n errorMessage %@", self.dic, errorMessage);
	return errorMessage;
}

@end
