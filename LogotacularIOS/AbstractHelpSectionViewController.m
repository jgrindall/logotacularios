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
	[self addMedia];
	[self loadMedia];
	[self layoutAll];
}

- (void) addMedia{
	
}

- (void) loadMedia{

}

- (void) layoutAll{
	
}

- (void) viewDidDisappear:(BOOL)animated{
	[self clearMedia];
}

- (void) clearMedia{
	
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addChildren];
}

- (void) addChildren{
	
}

@end
