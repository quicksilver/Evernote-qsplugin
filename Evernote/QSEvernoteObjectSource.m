//
//  QSEvernoteObjectSource.m
//  Evernote
//
//  Created by Andreas Johansson on 2012-08-19.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSEvernoteObjectSource.h"

@implementation QSEvernoteObjectSource


/*
 Rescan the catalog entries if the Evernote app is running
 */
- (BOOL)indexIsValidFromDate:(NSDate *)indexDate forEntry:(NSDictionary *)theEntry {
    if (!QSAppIsRunning(kQSEvernoteBundle)) {
        return YES;
    } else {
        return NO;
    }
}


/*
 Provides catalog entries notebooks and notes
 */
- (NSArray *)objectsForEntry:(NSDictionary *)theEntry {
    
    BOOL isRunning = QSAppIsRunning(kQSEvernoteBundle);
    
    if ([[theEntry objectForKey:@"ID"] hasPrefix:@"QSPresetEvernoteNotebooks"]) {
        if (isRunning) {
            QSEvernoteNotebookParser *notebookParser = [[[QSEvernoteNotebookParser alloc] init] autorelease];
            return [notebookParser allNotebooks];
        } else {
            return [QSLib arrayForType:kQSEvernoteNotebookType];
        }
    } else if ([[theEntry objectForKey:@"ID"] hasPrefix:@"QSPresetEvernoteNotes"]) {
        if (isRunning) {
            QSEvernoteNoteParser *noteParser = [[[QSEvernoteNoteParser alloc] init] autorelease];
            return [noteParser allNotes];
        } else {
            return [QSLib arrayForType:kQSEvernoteNoteType];
        }
    }
    return nil;
}


/*
 Loads right arrow children for Evernote, notebooks for the Evernote app itself,
 and notes for notebooks.
 */
- (BOOL)loadChildrenForObject:(QSObject *)object {
    if (!QSAppIsRunning(kQSEvernoteBundle)) {
        return NO;
    }
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:1];
    
    if ([object.primaryType isEqualToString:NSFilenamesPboardType]) {
        QSEvernoteNotebookParser *notebookParser = [[[QSEvernoteNotebookParser alloc] init] autorelease];
        [children addObjectsFromArray:[notebookParser allNotebooks]];
        
        [object setChildren:children];
        return YES;
    } else if ([object.primaryType isEqualToString:kQSEvernoteNotebookType]) {
        QSEvernoteNoteParser *noteParser = [[[QSEvernoteNoteParser alloc] init] autorelease];
        [children addObjectsFromArray:[noteParser notesInNotebook:object]];
        
        [object setChildren:children];
        return YES;
    }

    return NO;
}


/*
 The Evernote app only has children if it is running.
 */
- (BOOL)objectHasChildren:(QSObject *)object {
    if ([object.primaryType isEqualToString:kQSEvernoteNoteType]) {
        return NO;
    } else {
        return QSAppIsRunning(kQSEvernoteBundle);
    }
}

/*
 Sets the icons for the notes and notebooks
 */
- (void)setQuickIconForObject:(QSObject *)object {
    if ([object.primaryType isEqualToString:kQSEvernoteNotebookType]) {
        [object setIcon:[QSResourceManager imageNamed:kQSEvernoteBundle]];
    } else if ([object.primaryType isEqualToString:kQSEvernoteNoteType]) {
        [object setIcon:[QSResourceManager imageNamed:kQSEvernoteBundle]];
    }
}


@end
