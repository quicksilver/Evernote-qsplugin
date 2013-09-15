//
//  QSEvernoteNoteParser.h
//  Evernote
//
//  Created by Andreas Johansson on 2012-08-21.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSEvernoteDefinitions.h"

@interface QSEvernoteNoteParser : NSObject

- (NSArray *)allNotes;
- (NSArray *)notesInNotebook:(QSObject *)notebookObject;
- (NSArray *)notesWithTag:(QSObject *)tagObject;

@end
