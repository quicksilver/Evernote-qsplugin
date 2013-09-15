//
//  QSEvernoteActionProvider.m
//  Evernote
//
//  Created by Andreas Johansson on 2012-08-25.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSEvernoteActions.h"

@implementation QSEvernoteActions


- (QSObject *) search:(QSObject *)directObj for:(QSObject *)indirectObj {
    NSString *query = nil;

    if ([directObj.primaryType isEqualToString:NSFilenamesPboardType]) {
        query = [self escapeString:[indirectObj objectForType:NSStringPboardType]];
    } else if ([directObj.primaryType isEqualToString:kQSEvernoteNotebookType]) {
        query = [NSString stringWithFormat:
                 @"%@ %@",
                 [self notebookQuery:directObj],
                 [self escapeString:[indirectObj objectForType:NSStringPboardType]]];
    }

    if (query) {
        NSString *commands = [NSString stringWithFormat:
                              @"activate\nset query string of window 1 to \"%@\"",
                              query];
        [self tellEvernote:commands];
    }

    return nil;
}


- (QSObject *) openNotebook:(QSObject *)directObj {
    NSString *commands = [NSString stringWithFormat:
                          @"set mywin to open collection window\nset query string of mywin to \"%@\"\nactivate",
                          [self notebookQuery:directObj]];
    [self tellEvernote:commands];
    return nil;
}


- (QSObject *) revealNotebook:(QSObject *)directObj {
    NSString *commands = [NSString stringWithFormat:
                          @"activate\nset query string of window 1 to \"%@\"",
                          [self notebookQuery:directObj]];
    [self tellEvernote:commands];
    return nil;
}


- (QSObject *) openNote:(QSObject *)directObj {
    EvernoteNote *note = (EvernoteNote *)[directObj objectForType:kQSEvernoteNoteType];
    
    EvernoteApplication *evernote = [SBApplication applicationWithBundleIdentifier:kQSEvernoteBundle];
    
    [evernote openNoteWindowWith:note];
    [evernote activate];
    return nil;
}


- (QSObject *) revealNote:(QSObject *)directObj {
    EvernoteNote *note = (EvernoteNote *)[directObj objectForType:kQSEvernoteNoteType];
    
    NSString *commands = [NSString stringWithFormat:
                             @"activate\nset query string of window 1 to \"intitle:\\\"%@\\\" notebook:\\\"%@\\\" created:%@\"",
                             note.title,
                             note.notebook.name,
                             [note.creationDate descriptionWithCalendarFormat:@"%Y%m%dT%H%M%s"
                                                                     timeZone:nil
                                                                       locale:nil]
                             ];
    
    [self tellEvernote:commands];
    
    return nil;
}


- (NSArray *) validActionsForDirectObject:(QSObject *)directObj indirectObject:(QSObject *)indirectObj {
    if ([directObj.primaryType isEqual:kQSEvernoteNotebookType]) {
        return [NSArray arrayWithObjects:
                @"QSEvernoteOpenNotebook",
                @"QSEvernoteRevealNotebook",
                nil];
    } else if ([directObj.primaryType isEqual:kQSEvernoteNoteType]) {
        return [NSArray arrayWithObjects:
                @"QSEvernoteOpenNote",
                @"QSEvernoteRevealNote",
                @"QSEvernoteOpenNotebook",
                @"QSEvernoteRevealNotebook",
                nil];
    }
    
    return nil;
}


- (NSArray *)validIndirectObjectsForAction:(NSString *)action directObject:(QSObject *)directObj {
    if ([action isEqualToString:@"QSEvernoteSearch"] || [action isEqualToString:@"QSEvernoteSearchNotebook"]) {
        return [NSArray arrayWithObject:[QSObject textProxyObjectWithDefaultValue:@""]];
    }

    return nil;
}


- (NSString *) notebookQuery:(QSObject *)notebook {
    return [NSString stringWithFormat:@"notebook:\\\"%@\\\"",
            [notebook objectForType:kQSEvernoteNotebookType]];
}


- (void) tellEvernote:(NSString *)commands {
    NSString *source = [NSString stringWithFormat:
                        @"tell application \"Evernote\"\n%@\nend tell",
                        commands];
    
    NSAppleScript *scriptObject = [[[NSAppleScript alloc] initWithSource:source] autorelease];
    NSDictionary *errors;
    [scriptObject executeAndReturnError:&errors];
}


/*
 Escapes all special characters in a string before usage in an Applescript string
 */
- (NSString *) escapeString:(NSString *)string {
    NSString *escapeString = QSApplescriptStringEscape;

    NSUInteger i;
    for (i = 0; i < [escapeString length]; i++){
        NSString *thisString = [escapeString substringWithRange:NSMakeRange(i,1)];
        string = [[string componentsSeparatedByString:thisString] componentsJoinedByString:[@"\\" stringByAppendingString:thisString]];
    }
    return string;
}


@end
