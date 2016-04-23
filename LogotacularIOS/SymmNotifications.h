//
//  SymmNotifications.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SymmNotifications : NSObject

extern NSString* const SYMM_NOTIF_SHOW_SPINNER;
extern NSString* const SYMM_NOTIF_HIDE_SPINNER;
extern NSString* const SYMM_NOTIF_CLICK_MENU;
extern NSString* const SYMM_NOTIF_HIDE_MENU;
extern NSString* const SYMM_NOTIF_CLICK_TUT;
extern NSString* const SYMM_NOTIF_CLICK_PLAY;
extern NSString* const SYMM_NOTIF_START;
extern NSString* const SYMM_NOTIF_RESTART;
extern NSString* const SYMM_NOTIF_RESTART_QUEUE;
extern NSString* const SYMM_NOTIF_RESET_ZOOM;
extern NSString* const SYMM_NOTIF_CLEAR_QUEUE;
extern NSString* const SYMM_NOTIF_PARSE;
extern NSString* const SYMM_NOTIF_TRI;
extern NSString* const SYMM_NOTIF_HIDE_TRI;
extern NSString* const SYMM_NOTIF_STOP;
extern NSString* const SYMM_NOTIF_UNDO;
extern NSString* const SYMM_NOTIF_RESET;
extern NSString* const SYMM_NOTIF_REDO;
extern NSString* const SYMM_NOTIF_LOAD;
extern NSString* const SYMM_NOTIF_SAVE;
extern NSString* const SYMM_NOTIF_CLEAR;
extern NSString* const SYMM_NOTIF_CMD_RECEIVED;
extern NSString* const SYMM_NOTIF_CLICK_STOP;
extern NSString* const SYMM_NOTIF_CLICK_RESET_ZOOM;
extern NSString* const SYMM_NOTIF_CLICK_WIPE;
extern NSString* const SYMM_NOTIF_CLICK_TRI;
extern NSString* const SYMM_NOTIF_CLICK_EXAMPLES;
extern NSString* const SYMM_NOTIF_CLICK_REF;
extern NSString* const SYMM_NOTIF_DISMISS_KEY;
extern NSString* const SYMM_NOTIF_CLICK_OPEN;
extern NSString* const SYMM_NOTIF_LOAD_FILES;
extern NSString* const SYMM_NOTIF_PERFORM_OPEN;
extern NSString* const SYMM_NOTIF_PERFORM_DEL;
extern NSString* const SYMM_NOTIF_CLICK_SAVE;
extern NSString* const SYMM_NOTIF_CLICK_SAVE_AS;
extern NSString* const SYMM_NOTIF_CLICK_HELP;
extern NSString* const SYMM_NOTIF_SHOW_FILENAME;
extern NSString* const SYMM_NOTIF_SHOW_FILENAME_AS;
extern NSString* const SYMM_NOTIF_PERFORM_SAVE;
extern NSString* const SYMM_NOTIF_PERFORM_SAVE_AS;
extern NSString* const SYMM_NOTIF_TEXT_EDITED;
extern NSString* const SYMM_NOTIF_FILE_LOADED;
extern NSString* const SYMM_NOTIF_CLICK_NEW;
extern NSString* const SYMM_NOTIF_SCREENGRAB;
extern NSString* const SYMM_NOTIF_CHECK_SAVE;
extern NSString* const SYMM_NOTIF_PERFORM_NEW;
extern NSString* const SYMM_NOTIF_SAVED;
extern NSString* const SYMM_NOTIF_ERROR_HIT;
extern NSString* const SYMM_NOTIF_SYNTAX_CHECK;
extern NSString* const SYMM_NOTIF_SYNTAX_ERROR;
extern NSString* const SYMM_NOTIF_SHOW_POPOVER;
extern NSString* const SYMM_NOTIF_HIDE_POPOVER;
extern NSString* const SYMM_NOTIF_CHANGE_PAGE;
extern NSString* const SYMM_NOTIF_PERFORM_FILE_SETUP;
extern NSString* const SYMM_NOTIF_LOAD_FROM_HELP;

@end

