#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_WORD_LEN 100
#define HASH_SIZE 10007

typedef struct WordNode {
    char *word;
    int count;
    struct WordNode *next;
} WordNode;

WordNode *hashTable[HASH_SIZE] = {NULL};

// 哈希函数
unsigned int hash(const char *str) {
    unsigned int h = 0;
    while (*str) {
        h = h * 31 + tolower(*str);
        str++;
    }
    return h % HASH_SIZE;
}

// 插入或更新单词
void insertWord(const char *word) {
    if (strlen(word) == 0) return;
    unsigned int idx = hash(word);
    WordNode *node = hashTable[idx];
    while (node) {
        if (strcasecmp(node->word, word) == 0) {
            node->count++;
            return;
        }
        node = node->next;
    }
    // 新节点
    WordNode *newNode = (WordNode *)malloc(sizeof(WordNode));
    newNode->word = strdup(word);
    newNode->count = 1;
    newNode->next = hashTable[idx];
    hashTable[idx] = newNode;
}

// 清理哈希表
void freeHashTable() {
    for (int i = 0; i < HASH_SIZE; ++i) {
        WordNode *node = hashTable[i];
        while (node) {
            WordNode *tmp = node;
            node = node->next;
            free(tmp->word);
            free(tmp);
        }
        hashTable[i] = NULL; // 重置指针
    }
}

// 处理一行文本
void processLine(char *line) {
    char word[MAX_WORD_LEN];
    int j = 0;
    for (int i = 0; line[i]; i++) {
        if (isalpha(line[i])) {
            word[j++] = tolower(line[i]);
        } else {
            if (j > 0) {
                word[j] = '\0';
                insertWord(word);
                j = 0;
            }
        }
    }
    if (j > 0) {
        word[j] = '\0';
        insertWord(word);
    }
}

// 封装函数：处理文件，返回最高频单词，次数通过 count_out 输出
char* get_most_frequent_word(const char* filename, int* count_out) {
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        perror("无法打开文件");
        return NULL;
    }

    char line[4096];
    while (fgets(line, sizeof(line), fp)) {
        processLine(line);
    }
    fclose(fp);

    char *mostWord = NULL;
    int maxCount = 0;
    for (int i = 0; i < HASH_SIZE; ++i) {
        WordNode *node = hashTable[i];
        while (node) {
            if (node->count > maxCount) {
                maxCount = node->count;
                mostWord = node->word;
            }
            node = node->next;
        }
    }

    if (count_out) {
        *count_out = maxCount;
    }

    return mostWord;
}

// 主函数只负责调用和打印
int main() {
    int count = 0;
    char *word = get_most_frequent_word("Gone_with_the_wind.txt", &count);
    if (word) {
        printf("出现次数最多的单词是 \"%s\"，出现了 %d 次。\n", word, count);
    } else {
        printf("未找到任何单词或文件无法读取。\n");
    }
    freeHashTable();
    return 0;
}
