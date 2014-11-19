//
//  AbstractPerformSaveCommand_protected.h
//  
//
//  Created by John on 18/11/2014.
//
//

#import "AbstractPerformSaveCommand.h"
#import "PLogoModel.h"
#import "PFileModel.h"
#import "PScreenGrabModel.h"

@interface AbstractPerformSaveCommand ()

- (id<PScreenGrabModel>) getScreenGrabModel;

- (id<PLogoModel>) getLogoModel;

- (id<PFileModel>) getFileModel;

@end
