#include <stdio.h>

void inplace_merge(int* arr, int* lopp);
void quick(int* arr, int* lopp);

void main(){
    int n;
    scanf("%d", &n);
    int arr[n], i;
    for (i=0; i<n; i++){
        scanf("%d", &arr[i]);
    }
    
    //quick(arr, &arr[n-1]);
    inplace_merge(arr, &arr[n-1]);
    
    for (i=0; i<n; i++){
        printf("%d ", arr[i]);
    }
    printf("\n");
    
}