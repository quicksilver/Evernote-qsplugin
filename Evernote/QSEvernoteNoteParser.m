//
//  QSEvernoteNoteParser.m
//  Evernote
//
//  Created by Andreas Johansson on 2012-08-21.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSEvernoteNoteParser.h"

@implementation QSEvernoteNoteParser


- (NSArray *)allNotes {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    EvernoteApplication *evernote = [SBApplication applicationWithBundleIdentifier:kQSEvernoteBundle];
    
    for (EvernoteNotebook *notebook in evernote.notebooks) {
        for (EvernoteNote *note in notebook.notes) {
            [objects addObject:[self objectFrom:note in:notebook]];
        }
    }

    return objects;
}


- (NSArray *)notesInNotebook:(QSObject *)notebookObject {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    EvernoteApplication *evernote = [SBApplication applicationWithBundleIdentifier:kQSEvernoteBundle];
    
    EvernoteNotebook *notebook;
    
    for (EvernoteNotebook *nb in evernote.notebooks) {
        if ([nb.name isEqualToString:notebookObject.name]) {
            notebook = nb;
            break;
        }
    }
    
    for (EvernoteNote *note in notebook.notes) {
        [objects addObject:[self objectFrom:note in:notebook]];
    }

    return objects;
}


- (QSObject *)objectFrom:(EvernoteNote *)note in:(EvernoteNotebook *)notebook {
    QSObject *object = [QSObject objectWithName:note.title];
    [object setPrimaryType:kQSEvernoteNoteType];
    [object setObject:note forType:kQSEvernoteNoteType];
    [object setObject:note.notebook.name forType:kQSEvernoteNotebookType];

    NSMutableString *details = [NSMutableString stringWithCapacity:1];

    for (EvernoteTag *tag in note.tags) {
        [details appendString:@" #"];
        [details appendString:tag.name];
    }
    [details prependString:notebook.name];
    [object setDetails:details];

    // URL
    NSString *url = [note.sourceURL get];
    if (url) {
        [object setObject:url forType:QSURLType];
    }

    return object;
}


@end
