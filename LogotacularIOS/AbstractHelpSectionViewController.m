//
//  AbstractHelpSectionViewController.m
//  LogotacularIOS
//
//  Created by John on 14/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractHelpSectionViewController.h"

@implementation AbstractHelpSectionViewController

- (void) exit{
	[self.navigationController popViewControllerAnimated:YES];
}

- (instancetype) initWithIndex:(NSInteger)index{
	self = [super init];
	if(self){
		_index = index;
	}
	return self;
}

@end
