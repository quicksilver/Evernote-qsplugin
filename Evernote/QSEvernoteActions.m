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


- (NSArray *) validActionsForDirectObject:(QSObject *)directObj indirectObject:(QSObject *)indirectObj {
    return [NSArray arrayWithObjects:
            @"QSEvernoteOpenNotebook",
            @"QSEvernoteRevealNotebook",
            nil];
}


- (NSString *) notebookQuery:(QSObject *)notebook {
    return [NSString stringWithFormat:@"notebook:\"%@\"", [notebook objectForType:kQSEvernoteNotebookType]];
}


- (void) tellEvernote:(NSString *)commands {
    NSString *source = [NSString stringWithFormat:
                        @"tell application \"Evernote\"\n%@\nend tell",
                        commands];
    
    NSAppleScript *scriptObject = [[NSAppleScript alloc] initWithSource:source];
    [scriptObject executeAndReturnError:nil];
    [scriptObject release];
}


@end
