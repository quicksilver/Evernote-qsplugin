//
//  QSEvernoteTagParser.m
//  Evernote
//
//  Created by Andreas Johansson on 2013-09-15.
//  Copyright (c) 2013 stdin.se. All rights reserved.
//

#import "QSEvernoteTagParser.h"

@implementation QSEvernoteTagParser

- (NSArray *)allTags {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    EvernoteApplication *evernote = [SBApplication applicationWithBundleIdentifier:kQSEvernoteBundle];

    QSObject *object;

    for (EvernoteTag *tag in evernote.tags) {
        NSString *tagName = [NSString stringWithFormat:@"#%@", tag.name];
        object = [QSObject objectWithName:tagName];
        [object setPrimaryType:kQSEvernoteTagType];
        [object setObject:tagName forType:kQSEvernoteTagType];
        [objects addObject:object];
    }

    return objects;
}

@end
