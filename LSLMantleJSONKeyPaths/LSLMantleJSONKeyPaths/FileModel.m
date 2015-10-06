//
//  FileModel.m
//  GetFileName
//
//  Created by LiuShulong on 9/21/15.
//  Copyright (c) 2015 LiuShulong. All rights reserved.
//

#import "FileModel.h"
#import "XCodePrivate.h"

@interface FileModel ()

@property (nonatomic, readonly) PBXFileReference *pbxFileReference;

@end

@implementation FileModel

@synthesize isTestFile = _isTestFile;
@synthesize isHeaderFile = _isHeaderFile;
@synthesize isSourceFile = _isSourceFile;

- (instancetype)initWithPBXReference:(PBXFileReference *)pbxReference {
    if (self = [super init]) {
        _pbxFileReference = pbxReference;
        
        NSSet *targets = [self.pbxFileReference includingTargets];
        if (targets.count) {
            _isTestFile = YES;
        } else {
            _isHeaderFile = YES;
        }
        
        for (PBXTarget *target in [targets allObjects]) {
            if (![target _looksLikeUnitTestTarget]) {
                _isTestFile = NO;
            }
        }
        
        if (!self.isTestFile) {
            if ([self.pbxFileReference.name.pathExtension isEqualToString:@"m"]) {
                _isSourceFile = YES;
            } else {
                _isHeaderFile = YES;
            }
        }
    }
    return self;
}

- (NSString *)name {
    return self.pbxFileReference.name;
}

- (NSString *)absolutePath {
    return self.pbxFileReference.absolutePath;
}

- (PBXContainer *)container {
    return self.pbxFileReference.container;
}


@end
