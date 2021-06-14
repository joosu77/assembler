#include <stdio.h>
#include "deque.h"

//void mergeSort(int* arr, int len);
int test(int a);
//void quick(int* arr, int* lopp);

void main(){
    struct Deque* d = loo_deque();
    lykka_pahe(d, 10);
    lykka_pahe(d, 5);
    printf("%d\n", vota_saba(d));
    printf("%d\n", vota_saba(d));
    
    
    /*int n, m, r;
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
    */
    
    
    /*
    int arr1[] = {4,3};
    int arr2[] = {2,1};
    int m=2;
    int n = 2;
    int i,j;
    
    for (int i=n-1;i>=0;i--){
        int last = arr1[m-1];
        for (j=m-2; j>=0 && arr1[j] > arr2[i]; j--){
            arr1[j+1] = arr1[j];
        }
        if (j!=m-2 || last > arr2[i]){
            arr1[j+1] = arr2[i];
            arr2[i] = last;
        }
    }
    for (i=0; i<m; i++){
        printf("%d", arr1[i]);
    }
    for (i=0; i<n; i++){
        printf("%d", arr2[i]);
    }
    */
    
    /*
    int n,m,r;
    scanf("%d", &n);
    int arr[n];
    r = test(n);
    
    for (i=0; i<n; i++){
        printf("%d", arr[i]);
    }
    printf("\n%d\n", r);
    */
}