//
//  AbstractHelpSectionViewController.m
//  LogotacularIOS
//
//  Created by John on 14/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractHelpSectionViewController_protected.h"

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

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self layoutAll];
}


- (void) loadMedia{

}

- (void) layoutAll{
	
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addChildren];
}

- (void) addChildren{
	
}

@end
