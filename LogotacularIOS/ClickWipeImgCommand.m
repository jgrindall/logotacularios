//
//  ClickNewCommand.m
//  LogotacularIOS
//
//  Created by John on 06/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ClickWipeImgCommand.h"
#import "PBgModel.h"
#import "SymmNotifications.h"

@implementation ClickWipeImgCommand

- (void) execute:(id) payload{
	[[self getBgModel] setVal:nil forKey:BG_IMAGE];
}

- (id<PBgModel>) getBgModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PBgModel)];
}


@end
