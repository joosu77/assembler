#include <stdio.h>

void inplace_merge(int* arr, int* lopp);
void quick(int* arr, int* lopp);
int bin_search(int* arr, int len, int val);

void main(){
    int n, m, r;
    scanf("%d %d", &n, &m);
    int arr[n], i;
    for (i=0; i<n; i++){
        scanf("%d", &arr[i]);
    }
    
    //quick(arr, &arr[n-1]);
    //inplace_merge(arr, &arr[n-1]);
    r = bin_search(arr, n, m);
    
    /*for (i=0; i<n; i++){
        printf("%d ", arr[i]);
    }*/
    printf("%d\n", r);
    
}