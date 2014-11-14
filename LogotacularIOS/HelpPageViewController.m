//
//  HelpPageViewController.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpPageViewController.h"
#import "HelpSectionViewController.h"

@implementation HelpPageViewController

- (instancetype)init{
	self = [super initWithChildClass:[HelpSectionViewController class] andNumPages:5];
	if(self){
		
	}
	return self;
}

@end

