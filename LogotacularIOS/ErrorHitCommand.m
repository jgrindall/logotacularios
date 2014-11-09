//
//  ErrorHitCommand.m
//  LogotacularIOS
//
//  Created by John on 09/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ErrorHitCommand.h"
#import "ToastUtils.h"
#import "PLogoErrorModel.h"

@implementation ErrorHitCommand

- (void) execute:(id)payload{
	NSDictionary* error = (NSDictionary*)payload;
	NSString* errorMessage = [NSString stringWithFormat:@"Error on line %@, %@", error[@"line"], error[@"message"]];
	[[self getErrorModel] setVal:error forKey:LOGO_ERROR_ERROR];
	[ToastUtils showToastInController:nil withMessage:errorMessage withType:TSMessageNotificationTypeError];
}

- (id<PLogoErrorModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

@end
