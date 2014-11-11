//
//  SyntaxErrorHit.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SyntaxErrorCommand.h"
#import "ToastUtils.h"
#import "PLogoErrorModel.h"

@implementation SyntaxErrorCommand

- (void) execute:(id)payload{
	NSDictionary* error = (NSDictionary*)payload;
	NSString* errorMessage = nil;
	if(payload && error && error[@"message"]){
		if(error[@"line"]){
			errorMessage = [NSString stringWithFormat:@"Error on line %@, %@", error[@"line"], error[@"message"]];
		}
		else{
			errorMessage = [NSString stringWithFormat:@"Error %@", error[@"message"]];
		}
		if(![errorMessage isEqual:nil]){
			[[self getErrorModel] setVal:error forKey:LOGO_ERROR_ERROR];
		}
	}
	else{
		[[self getErrorModel] setVal:nil forKey:LOGO_ERROR_ERROR];
	}
}

- (id<PLogoErrorModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

@end
