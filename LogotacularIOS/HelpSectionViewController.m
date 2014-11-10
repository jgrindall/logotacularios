//
//  HelpSectionViewController.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpSectionViewController.h"

@implementation HelpSectionViewController

- (id)init{
	self = [super init];
	if(self){
		self.view.backgroundColor = [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.0];
	}
	return self;
}

@end
