//
//  WebViewController.h
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "BaseViewController_protected.h"
#import "PCommandConsumer.h"

@interface WebViewController : BaseViewController <UIWebViewDelegate>

- (void) setCommandConsumer:(id<PCommandConsumer>)commandConsumer;

@end
