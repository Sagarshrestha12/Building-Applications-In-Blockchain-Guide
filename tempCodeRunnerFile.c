#include<stdio.h>
int main()
{
   int i,j=0,k=0,l;
   printf("This program is to find the negative and positive number\n");
   printf("Enter the number of digit you want to print\n");
   scanf("%d",&l);
   int a[l];
   for(i=0;i<l;i++)
   {
       printf("a[%d]=",i+1);
       scanf("%d",&a[i]);
   }
   printf("The positive number is given by:");
   for(i=0;i<l;i++)
   {
       if(a[i]>=0)
       {
           k++;
           printf("%d,",a[i]);
       }
   }
   printf("\nThe number of positive number is %d",k);
   printf("\n The negative number is given by:\n");
   for(i=0;i<l;i++)
   {
       if(a[i]<0)
       {
           j++;
           printf("%d",a[i]);
       }
   }
    printf("\nThe number of negative number is %d\n",j);
    return 1;
}