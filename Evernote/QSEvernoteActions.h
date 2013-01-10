//
//  QSEvernoteActionProvider.h
//  Evernote
//
//  Created by Andreas Johansson on 2012-08-25.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSEvernoteDefinitions.h"

@interface QSEvernoteActions : NSObject

- (QSObject *) openNotebook:(QSObject *)directObj;
- (QSObject *) revealNotebook:(QSObject *)directObj;
- (QSObject *) openNote:(QSObject *)directObj;
- (QSObject *) revealNote:(QSObject *)directObj;

- (NSArray *) validActionsForDirectObject:(QSObject *)directObj indirectObject:(QSObject *)indirectObj;

@end
