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

// hash function
unsigned int hash(const char *str) {
    unsigned int h = 0;
    while (*str) {
        h = h * 31 + tolower(*str);
        str++;
    }
    return h % HASH_SIZE;
}

// insert or update words 
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
    // new point
    WordNode *newNode = (WordNode *)malloc(sizeof(WordNode));
    newNode->word = strdup(word);
    newNode->count = 1;
    newNode->next = hashTable[idx];
    hashTable[idx] = newNode;
}

// clear hash table
void freeHashTable() {
    for (int i = 0; i < HASH_SIZE; ++i) {
        WordNode *node = hashTable[i];
        while (node) {
            WordNode *tmp = node;
            node = node->next;
            free(tmp->word);
            free(tmp);
        }
        hashTable[i] = NULL; // reset pointer
    }
}


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
/**
 * Processes a file to determine the most frequent word.
 * 
 * This function reads the content of the specified file, analyzes the word frequencies,
 * and identifies the word that appears most frequently. The frequency of this word is
 * returned via the count_out parameter. *
 * 
 * @param filepath The path to the file to be processed.
 * @param count_out A pointer to an integer where the function will store the frequency
 *                  of the most frequent word.
 * @return The most frequent word in the file as a dynamically allocated string.
 *         The caller is responsible for freeing the memory.
 */
char* get_most_frequent_word(const char* filename, int* count_out) {
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        perror("Can not open file");
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


int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    int count = 0;
    char *word = get_most_frequent_word(argv[1], &count);
    if (word) {
        printf("The most frequent word is \"%s\", which appeared %d times.\n", word, count);
    } else {
        printf("Could not find any words or could not read the file.\n");
    }
    freeHashTable();
    return 0;
}
