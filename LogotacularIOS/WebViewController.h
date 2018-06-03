//
//  WebViewController.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController_protected.h"
#import "PCommandConsumer.h"
#import <WebKit/WebKit.h>

@interface WebViewController : BaseViewController <WKNavigationDelegate, WKScriptMessageHandler>

- (void) setCommandConsumer:(id<PCommandConsumer>)commandConsumer;

@end
