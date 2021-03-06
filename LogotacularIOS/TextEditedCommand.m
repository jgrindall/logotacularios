//
//  TextEditedCommand.m
//  LogotacularIOS
//
//  Created by John on 06/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TextEditedCommand.h"
#import "PLogoModel.h"
#import "PFileModel.h"

@implementation TextEditedCommand

- (void) execute:(id) payload{
	NSString* text = (NSString*)payload;
	NSString* oldText = [[self getLogoModel] get];
	if(![oldText isEqualToString:text]){
		[[self getLogoModel] add:text];
		[[self getFileModel] setVal:@YES forKey:FILE_DIRTY];
	}
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}


@end
