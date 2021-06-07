#include <stdio.h>

//void mergeSort(int* arr, int len);
//int factorial(int* arr, int a);
void quick(int* arr, int* lopp);

void main(){
    int n, m, r;
    scanf("%d", &n);
    //scanf("%d", &m);
    int arr[n], i;
    for (i=0; i<n; i++){
        scanf("%d", &arr[i]);
    }
    
    quick(arr, &arr[n-1]);
    
    for (i=0; i<n; i++){
        printf("%d ", arr[i]);
    }
    printf("\n");
    /*
    r = factorial(arr, m);
    
    for (i=0; i<n; i++){
        printf("%d", arr[i]);
    }
    printf("\n%d\n", r);
    */
}