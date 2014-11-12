//
//  HelpSectionViewController.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpSectionViewController.h"
#import "SymmNotifications.h"

@interface HelpSectionViewController ()

@property UIButton* progCopyButton;

@end

@implementation HelpSectionViewController

- (instancetype)init{
	self = [super init];
	if(self){
		self.view.backgroundColor = [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.0];
	}
	return self;
}

- (void) viewDidLoad{
	[self addButton];
}

- (void) addButton{
	self.progCopyButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.progCopyButton setTitle:@"CLICK" forState:UIControlStateNormal];
	[self.progCopyButton addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.progCopyButton];
	self.progCopyButton.frame = CGRectMake(100, 100, 100, 100);
}

- (void) onClick{
	NSString* logo = @"AND HERE IT IS";
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_PERFORM_FILE_SETUP withData:@{@"filename":[NSNull null], @"logo":logo}];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
