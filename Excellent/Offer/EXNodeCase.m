//
//  EXNodeViewController.m
//  Excellent
//
//  Created by lijia on 2018/1/19.
//  Copyright © 2018年 Li Jia. All rights reserved.
//

#import "EXNodeCase.h"

@interface EXNodeCase ()

@end

@implementation EXNodeCase

+(NSUInteger)getNodeLength:(EXNode*)headNode {
    if (headNode == nil) {
        return 0;
    }
    NSUInteger len = 1;
    while (headNode.next) {
        headNode = headNode.next;
        len += 1;
    }
    return len;
}

+(EXNode*)findCircleCrossNode:(EXNode*)headNode {
    if (headNode == nil) {
        return nil;
    }
    
    EXNode *fastNode = headNode;
    EXNode *slowNode = headNode;
    while (fastNode.next) {
        fastNode = fastNode.next.next;
        slowNode = slowNode.next;
        if (fastNode == slowNode) {
            return fastNode;
        }
    }
    
    return nil;
}

+(BOOL)isCircleNode:(EXNode*)headNode {
    return ([self findCircleCrossNode:headNode] != nil);
}

+(EXNode*)findCircleEnterNode:(EXNode*)headNode crossNode:(EXNode*)crossNode {
    if (headNode == crossNode) {
        return nil;
    }
    
    if (headNode == nil || crossNode == nil) {
        return nil;
    }
    EXNode *p1 = headNode, *p2 = crossNode;
    while (p1 != p2) {
        p1 = p1.next;
        p2 = p2.next;
    }
    return p1;
}

+(EXNode*)findCircleEnterNode:(EXNode*)headNode {
    EXNode *crossNode = [self findCircleCrossNode:headNode];
    if (crossNode) {
        return [self findCircleEnterNode:headNode crossNode:crossNode];
    }
    return nil;
}

+(void)printNodeReversingly:(EXNode*)headNode {
    EXNode *nextNode = headNode;
    if (nextNode) {
        unsigned int len = 128;
        int arr[len];
        bzero(arr, len);
        int index = len - 1;
        while (nextNode) {
            arr[index] = nextNode.value.intValue;
            nextNode = nextNode.next;
            --index;
        }
        
        for (int i = index + 1; i < len; ++i) {
            printf("%d, ", arr[i]);
        }
        printf("\n");
    }
}

+(void)printNodeReversingRecursively:(EXNode*)headNode {
    if (headNode) {
        if (headNode.next) {
            [self printNodeReversingRecursively:headNode.next];
        }
        printf("%d, ", headNode.value.intValue);
    }
}

EXBinaryTreeNode* constructCore(int *startPreorder,  int *endPreorder, int *startInorder, int *endInorder) {
    /* 找到根节点 */
    int rootValue = *startPreorder;
    EXBinaryTreeNode *rootTree = [[EXBinaryTreeNode alloc] init];
    rootTree.value = [NSString stringWithFormat:@"%d",rootValue];
    rootTree.leftNode = rootTree.rightNode = NULL;
    
    /* 确定中序排列根节点 */
    if (startInorder == endPreorder) {
        if (startInorder == endInorder && *startInorder == *endInorder) {
            return rootTree;
        } else {
            printf("invalid input");
        }
    } else {
        int *rootInorder = startInorder;
        while (rootInorder <= endInorder && *rootInorder != rootValue) {
            ++rootInorder;
        }
        
        if (rootInorder == endInorder && *rootInorder != rootValue) {
            printf("invalid input");
        }
        
        int leftLength = (int)(rootInorder - startInorder);
        int *leftPreorderEnd = startPreorder + leftLength;
        if (leftLength > 0) {
            rootTree.leftNode = constructCore(startPreorder + 1, leftPreorderEnd, startInorder, rootInorder - 1);
        }
        if (leftLength < endPreorder - startPreorder) {
            rootTree.rightNode = constructCore(leftPreorderEnd + 1, endPreorder, rootInorder + 1, endInorder);
        }
    }
    return rootTree;
}

EXBinaryTreeNode* constructBinaryTree(int preorder[], int inorder[], int length) {
    if (preorder == NULL || inorder == NULL || length <= 0) {
        return nil;
    }
    int *endPreorder = preorder + length - 1;
    int *endInorder = inorder + length - 1;
    return constructCore(preorder, endPreorder, inorder, endInorder);
}

void recursivePrintTree(EXBinaryTreeNode* tree) {
    if (tree.leftNode) {
        recursivePrintTree(tree.leftNode);
    }
    if (tree.rightNode) {
        recursivePrintTree(tree.rightNode);
    }
    NSLog(@"value :%@",tree.value);
}

EXBinaryTreeNode* findInorderNextTreeNode(EXBinaryTreeNode* treeNode) {
    if (treeNode == nil) {
        return nil;
    }
    EXBinaryTreeNode *nextNode = nil;
    if (treeNode.rightNode) {
        /* 有右节点找到最深的左节点, 如没有选右节点 */
        EXBinaryTreeNode *rightNode = treeNode.rightNode;
        while (rightNode.leftNode) {
            rightNode = rightNode.leftNode;
        }
        nextNode = rightNode;
    } else if (treeNode.parentNode) {
        /* 往上一层找, 直到找到一个左节点 */
        EXBinaryTreeNode *currentNode = treeNode;
        EXBinaryTreeNode *parentNode = treeNode.parentNode;
        while (parentNode && currentNode == parentNode.rightNode) {
            currentNode = parentNode;
            parentNode = parentNode.parentNode;
        }
        nextNode = parentNode;
    }
    return nextNode;
}

/* 在O(1)时间内删除链表节点 */
void deleteNode(EXNode** headNode, EXNode *deleteNode) {
    if (headNode == nil || deleteNode == nil) {
        return;
    }
    if (deleteNode.next != nil) {
        //不是尾部节点, 复制下一个节点数据
        EXNode *next = deleteNode.next;
        deleteNode.value = next.value;
        deleteNode.next = next.next;
    } else if(*headNode == deleteNode) {
        //删除的是头节点
        (*headNode).value = nil;
        (*headNode).next = nil;
        *headNode = nil;
    } else if(deleteNode.next == nil) {
        //删除的为尾部节点
        EXNode* nextNode = *headNode;
        while (nextNode.next != deleteNode) {
            nextNode = nextNode.next;
        }
        if (nextNode) {
            nextNode.next = nil;
        }
    }
}

/* 删除重复的链表节点 */
void deleteDuplicationNode(EXNode** headNode) {
    if (!headNode || *headNode == nil) {
        return;
    }
    //TODO
//    EXNode *preNode = *headNode;
//    EXNode *curNode = *headNode;
//    while (curNode.next) {
//        if (curNode == curNode.next) {
//            EXNode *nextNode = curNode.next;
//            curNode.next = nextNode.next;
//            nextNode.next = nil;
//        } else {
//            preNode = curNode;
//            curNode = curNode.next;
//        }
//
//    }
}

@end



