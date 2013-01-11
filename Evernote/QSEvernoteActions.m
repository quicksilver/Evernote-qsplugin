//
//  QSEvernoteActionProvider.m
//  Evernote
//
//  Created by Andreas Johansson on 2012-08-25.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSEvernoteActions.h"

@implementation QSEvernoteActions


- (QSObject *) openNotebook:(QSObject *)directObj {
    NSString *commands = [NSString stringWithFormat:
                          @"open collection window with query string \"%@\"\nactivate",
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
    if (directObj.primaryType == kQSEvernoteNotebookType) {
        return [NSArray arrayWithObjects:
                @"QSEvernoteOpenNotebook",
                @"QSEvernoteRevealNotebook",
                nil];
    } else if (directObj.primaryType == kQSEvernoteNoteType) {
        return [NSArray arrayWithObjects:
                @"QSEvernoteOpenNote",
                @"QSEvernoteRevealNote",
                @"QSEvernoteOpenNotebook",
                @"QSEvernoteRevealNotebook",
                nil];
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
    
    if (errors) {
        for (id key in errors) {
            NSLog(@"%@: %@\n", key, [errors objectForKey:key]);
        }
    }
}


@end
