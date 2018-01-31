//
//  EXBinaryTree.h
//  Excellent
//
//  Created by lijia on 2018/1/24.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * 二叉树节点
 */
@interface EXBinaryTreeNode : NSObject
@property (nonatomic, assign) NSString                 *value;
@property (nonatomic, strong) EXBinaryTreeNode         *leftNode;
@property (nonatomic, strong) EXBinaryTreeNode         *rightNode;
@property (nonatomic, strong) EXBinaryTreeNode         *parentNode;
@end
