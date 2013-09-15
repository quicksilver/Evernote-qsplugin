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
    } else if ([[theEntry objectForKey:@"ID"] hasPrefix:@"QSPresetEvernoteTags"]) {
        if (isRunning) {
            QSEvernoteTagParser *tagParser = [[[QSEvernoteTagParser alloc] init] autorelease];
            return [tagParser allTags];
        } else {
            return [QSLib arrayForType:kQSEvernoteTagType];
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
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:1];
    
    if ([object.primaryType isEqualToString:NSFilenamesPboardType]) {
        
        if (QSAppIsRunning(kQSEvernoteBundle)) {
            QSEvernoteNotebookParser *notebookParser = [[[QSEvernoteNotebookParser alloc] init] autorelease];
            [children addObjectsFromArray:[notebookParser allNotebooks]];

            QSEvernoteTagParser *tagParser = [[[QSEvernoteTagParser alloc] init] autorelease];
            [children addObjectsFromArray:[tagParser allTags]];
        } else {
            for (QSObject *obj in [QSLib arrayForType:kQSEvernoteNotebookType]) {
                if ([obj.primaryType isEqualToString:kQSEvernoteNotebookType]) {
                    [children addObject:obj];
                }
            }
            for (QSObject *obj in [QSLib arrayForType:kQSEvernoteTagType]) {
                if ([obj.primaryType isEqualToString:kQSEvernoteTagType]) {
                    [children addObject:obj];
                }
            }
        }
    } else if ([object.primaryType isEqualToString:kQSEvernoteNotebookType]) {
        
        if (QSAppIsRunning(kQSEvernoteBundle)) {
            QSEvernoteNoteParser *noteParser = [[[QSEvernoteNoteParser alloc] init] autorelease];
            [children addObjectsFromArray:[noteParser notesInNotebook:object]];
        } else {
            NSString *notebookName = [object objectForType:kQSEvernoteNotebookType];

            for (QSObject *note in [QSLib arrayForType:kQSEvernoteNoteType]) {
                if ([[note objectForType:kQSEvernoteNotebookType] isEqualToString:notebookName]) {
                    [children addObject:note];
                }
            }
        }
    } else if ([object.primaryType isEqualToString:kQSEvernoteTagType]) {

        if (QSAppIsRunning(kQSEvernoteBundle)) {
            QSEvernoteNoteParser *noteParser = [[[QSEvernoteNoteParser alloc] init] autorelease];
            [children addObjectsFromArray:[noteParser notesWithTag:object]];
        } else {
            NSString *tagName = [object objectForType:kQSEvernoteTagType];

            for (QSObject *note in [QSLib arrayForType:kQSEvernoteNoteType]) {
                NSArray *tags = [note objectForMeta:@"tags"];
                if ([tags indexOfObject:tagName] != NSNotFound) {
                    [children addObject:note];
                }
            }
        }
    }

    [object setChildren:children];

    return YES;
}


/*
 Evernote and Notebooks have children, Notes don't.
 */
- (BOOL)objectHasChildren:(QSObject *)object {
    if ([object.primaryType isEqualToString:kQSEvernoteNoteType]) {
        return NO;
    } else {
        return YES;
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
    } else if ([object.primaryType isEqualToString:kQSEvernoteTagType]) {
        [object setIcon:[QSResourceManager imageNamed:kQSEvernoteBundle]];
    }
}


@end
