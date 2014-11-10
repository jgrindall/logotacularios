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
	NSLog(@"payload %@ error %@", payload, error);
	NSString* errorMessage;
	if(payload && error){
		if(error[@"line"] && error[@"message"]){
			errorMessage = [NSString stringWithFormat:@"Error on line %@, %@", error[@"line"], error[@"message"]];
		}
		else if(error[@"message"]){
			errorMessage = [NSString stringWithFormat:@"Error %@", error[@"message"]];
		}
		else{
			errorMessage = @"Unknown error";
		}
		[[self getErrorModel] setVal:error forKey:LOGO_ERROR_ERROR];
		[ToastUtils showToastInController:nil withMessage:errorMessage withType:TSMessageNotificationTypeError];
	}
	else{
		[[self getErrorModel] setVal:nil forKey:LOGO_ERROR_ERROR];
	}
}

- (id<PLogoErrorModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

@end
