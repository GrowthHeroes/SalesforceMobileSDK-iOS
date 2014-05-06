/*
 Copyright (c) 2011, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SFSoupIndex.h"

NSString * const kSoupIndexTypeString   = @"string";
NSString * const kSoupIndexTypeInteger  = @"integer";
NSString * const kSoupIndexTypeFloating = @"floating";
NSString * const kSoupIndexPath         = @"path";
NSString * const kSoupIndexType         = @"type";
NSString * const kSoupIndexColumnName   = @"columnName";


@implementation SFSoupIndex

@synthesize path = _path;
@synthesize indexType = _indexType;
@synthesize columnName = _columnName;

- (id)initWithPath:(NSString*)path indexType:(NSString*)type columnName:(NSString*)columnName {
    self = [super init];
    if (nil != self) {
        self.path = path;
        self.indexType = type;
        _columnName = columnName;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict {
    self = [self initWithPath:[dict objectForKey:kSoupIndexPath]
                    indexType:[dict objectForKey:kSoupIndexType]
                   columnName:nil
            ];
    return self;
}

- (void) dealloc {
    SFRelease(_columnName);
    SFRelease(_indexType);
    SFRelease(_path);
}

/**
 Maps the IndexSpec type to the SQL column type
 */
- (NSString*)columnType {
    NSString *result = @"TEXT";
    if ([self.indexType isEqualToString:kSoupIndexTypeString]) {
        result = @"TEXT";
    } else if ([self.indexType isEqualToString:kSoupIndexTypeInteger]) {
        result = @"INTEGER";
    } else if ([self.indexType isEqualToString:kSoupIndexTypeFloating]) {
        result = @"REAL";
    }
    return  result;
}
    
#pragma mark - Converting to JSON
    
- (NSDictionary*)asDictionary
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:self.path forKey:kSoupIndexPath];
    [result setObject:self.indexType forKey:kSoupIndexType];
    return result;
}

#pragma mark - Useful methods

+ (NSDictionary*) mapForSoupIndexes:(NSArray*)soupIndexes
{
    NSMutableDictionary* map = [NSMutableDictionary dictionary];
    for (SFSoupIndex* soupIndex in soupIndexes) {
        map[soupIndex.path] = soupIndex;
    }
    return map;
}


@end
