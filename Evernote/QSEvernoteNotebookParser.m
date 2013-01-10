//
//  QSEvernoteNotebookParser.m
//  Evernote
//
//  Created by Andreas Johansson on 2012-08-19.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSEvernoteNotebookParser.h"

@implementation QSEvernoteNotebookParser


- (NSArray *)allNotebooks {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    EvernoteApplication *evernote = [SBApplication applicationWithBundleIdentifier:kQSEvernoteBundle];
    
    QSObject *object;
    
    for (EvernoteNotebook *notebook in evernote.notebooks) {
        object = [QSObject objectWithName:notebook.name];
        [object setPrimaryType:kQSEvernoteNotebookType];
        [object setObject:notebook.name forType:kQSEvernoteNotebookType];
        [objects addObject:object];
    }
    
    return objects;
}


@end
