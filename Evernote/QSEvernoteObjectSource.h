//
//  QSEvernoteObjectSource.h
//  Evernote
//
//  Created by Andreas Johansson on 2012-08-19.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSEvernoteDefinitions.h"
#import "QSEvernoteNotebookParser.h"

@interface QSEvernoteObjectSource : QSObjectSource

- (BOOL)loadChildrenForObject:(QSObject *)object;
- (BOOL)objectHasChildren:(QSObject *)object;

@end

