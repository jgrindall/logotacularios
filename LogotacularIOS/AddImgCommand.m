//
//  ClickTutCommand.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AddImgCommand.h"
#import "FileLoader.h"
#import "ToastUtils.h"
#import <Objection/Objection.h>

@implementation AddImgCommand

- (void) execute:(id) payload{
	NSDictionary* data = (NSDictionary*)payload;
	[[FileLoader sharedInstance] saveImg:data[@"name"] withImage:data[@"image"] withCallback:^(FileLoaderResults result) {
		if(result == FileLoaderResultOk){
			[self fileSaved:data[@"name"]];
		}
		else{
			[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileSaveErrorMessage] withType:TSMessageNotificationTypeError];
		}
	}];
}

-  (void) fileSaved:(NSString*)filename{
	[ToastUtils showToastInController:nil withMessage:[ToastUtils getFileSaveSuccessMessage] withType:TSMessageNotificationTypeSuccess];
	
	//[[self getEventDispatcher] dispatch:SYMM_NOTIF_SAVED withData:nil];
}

@end



