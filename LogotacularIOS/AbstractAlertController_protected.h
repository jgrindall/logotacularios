//
//  AbstractAlertController_protected.h
//  
//
//  Created by John on 07/11/2014.
//
//

#import "AbstractOverlayController_protected.h"

@interface AbstractAlertController : AbstractOverlayController

@property UILabel* titleLabel;
@property UIView* panel;
@property NSArray* panelConstraints;

- (UIButton*) getButton:(NSString*) imageUrl withAction:(SEL)action withLabel:(NSString*)label;

- (void)layoutPanel:(float)dy;

@end
