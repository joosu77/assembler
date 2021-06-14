#include <stdio.h>
#include <stdlib.h>
#include "deque.h"

struct Node {
    struct Node* jarg;
    struct Node* eel;
    int val;
};

struct Deque {
    struct Node* pea;
    struct Node* saba;
};

void lykka_pahe(struct Deque* d, int val){
    struct Node* uus = malloc(sizeof(struct Node));
    uus->val = val;
    uus->eel = NULL;
    uus->jarg = NULL;
    if (d->pea == NULL){
        d->pea = uus;
        d->saba = uus;
    } else {
        d->pea->jarg = uus;
        uus->eel = d->pea;
        d->pea = uus;
    }
}

int vota_pea(struct Deque* d){
    int res = d->pea->val;
    if (d->pea->jarg == NULL){
        free(d->saba);
        d->saba = NULL;
        d->pea = NULL;
    } else {
        d->pea = d->pea->eel;
        free(d->pea->jarg);
    }
    return res;
}

int piilu_pead(struct Deque* d){
    return d->pea->val;
}

void lykka_sabba(struct Deque* d, int val){
    struct Node* uus = malloc(sizeof(struct Node));
    uus->val = val;
    uus->eel = NULL;
    uus->jarg = NULL;
    if (d->pea == NULL){
        d->pea = uus;
        d->saba = uus;
    } else {
        d->saba->eel = uus;
        uus->jarg = d->saba;
        d->saba = uus;
    }
}

int vota_saba(struct Deque* d){
    int res = d->saba->val;
    if (d->saba->jarg == NULL){
        free(d->saba);
        d->saba = NULL;
        d->pea = NULL;
    } else {
        d->saba = d->saba->jarg;
        free(d->saba->eel);
    }
    return res;
}

int piilu_saba(struct Deque* d){
    return d->saba->val;
}

struct Deque* loo_deque(){
    struct Deque* d = malloc(sizeof(struct Deque));
    d->pea = NULL;
    d->saba = NULL;
    return d;
}

/*int main(){
    struct Deque* d = malloc(sizeof(struct Deque));
    d->pea = malloc(sizeof(struct Node));
    d->saba = d->pea;
    
    lykka_pahe(d, 1);
    printf("%d\n", vota_pea(d));
}*/