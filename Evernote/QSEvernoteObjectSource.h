//
//  QSEvernoteObjectSource.h
//  Evernote
//
//  Created by Andreas Johansson on 2012-08-19.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSEvernoteDefinitions.h"
#import "QSEvernoteNoteParser.h"
#import "QSEvernoteNotebookParser.h"
#import "QSEvernoteTagParser.h"

@interface QSEvernoteObjectSource : QSObjectSource

- (NSArray *)objectsForEntry:(NSDictionary *)theEntry;
- (BOOL)loadChildrenForObject:(QSObject *)object;
- (BOOL)objectHasChildren:(QSObject *)object;

@end

