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
#import "ErrorObject.h"

@implementation SyntaxErrorCommand

- (void) execute:(id)payload{
	NSDictionary* errorDic = (NSDictionary*)payload;
	ErrorObject* errorObj = nil;
	if(errorDic && errorDic[@"message"]){
		errorObj = [[ErrorObject alloc] initWithNSDictionary:errorDic];
	}
	[[self getErrorModel] setVal:errorObj forKey:LOGO_ERROR_ERROR];
}

- (id<PLogoErrorModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

@end


