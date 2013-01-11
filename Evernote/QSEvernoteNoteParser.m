//
//  QSEvernoteNoteParser.m
//  Evernote
//
//  Created by Andreas Johansson on 2012-08-21.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSEvernoteNoteParser.h"

@implementation QSEvernoteNoteParser

- (NSArray *)notesInNotebook:(QSObject *)notebookObject {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    EvernoteApplication *evernote = [SBApplication applicationWithBundleIdentifier:kQSEvernoteBundle];
    
    QSObject *object;
    
    EvernoteNotebook *notebook;
    
    for (EvernoteNotebook *nb in evernote.notebooks) {
        if ([nb.name isEqualToString:notebookObject.name]) {
            notebook = nb;
            break;
        }
    }
    
    for (EvernoteNote *note in notebook.notes) {
        object = [QSObject objectWithName:note.title];
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

        [objects addObject:object];
    }
    
    return objects;
}

@end
