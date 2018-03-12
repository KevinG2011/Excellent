//
//  EXNodeController.h
//  Excellent
//
//  Created by lijia on 2018/1/19.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXNode.h"
#import "EXBinaryTreeNode.h"

@interface EXNodeCase : NSObject

/**
 *  获取链表长度
 */
+(NSUInteger)getNodeLength:(EXNode*)headNode;

/**
 *  是环形链表返回相遇交点
 *  不是的话返回空
 */
+(EXNode*)findCircleCrossNode:(EXNode*)headNode;

/**
 *  链表是否为环形链表
 */
+(BOOL)isCircleNode:(EXNode*)headNode;

/**
 *  获取环形链表环入口点.
 *  由以下公式推导.
 *  (a + x) * 2 = a + r + x
 *     慢指针      快指针
 *  a = r - x
 */
+(EXNode*)findCircleEnterNode:(EXNode*)headNode crossNode:(EXNode*)crossNode;

/**
 *  如果是环形列表, 返回环入口点; 否则返回空
 */
+(EXNode*)findCircleEnterNode:(EXNode*)headNode;

/**
 *  从尾到头反相打印链表(不改变原有链表结构), 循环方式
 */
+(void)printNodeReversingly:(EXNode*)headNode;

/**
 *  从尾到头反相打印链表(不改变原有链表结构), 递归方式,
 *  可能会导致栈溢出
 */
+(void)printNodeReversingRecursively:(EXNode*)headNode;

/**
 *  重建二叉树
 *  前序遍历{1, 2, 4, 7, 3, 5, 6, 8} 根->左子树->右子树
 *  中序遍历{4, 7, 2, 1, 5, 3, 8, 6} 左子树->根->右子树
 *  参数 preorder 前序遍历结果
 *  参数 inorder  中序遍历结果
 */
EXBinaryTreeNode* constructBinaryTree(int preorder[], int inorder[], int length);

/**
 *  递归遍历二叉树
 */
void recursivePrintTree(EXBinaryTreeNode* tree);

/**
 *  查找二叉树中序遍历的下一个节点
 *        2
 *       / \
 *      1   5
 *       \ / \
 *       4 3  8
 *       /   / \
 *      3   6  11
 */
EXBinaryTreeNode* findInorderNextTreeNode(EXBinaryTreeNode* tree);

/*
 * 在O(1)时间内删除链表节点 (复制法)
 */
void deleteNode(EXNode** headNode, EXNode *deleteNode);

/*
 * 删除重复的链表节点
 */
void deleteDuplicationNode(EXNode** headNode);

/*
 * 链表的倒数第k个节点
 */
EXNode* findKthNodeToTail(EXNode* headNode, int k);
@end



