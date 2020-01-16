# QuickSort_using_Memory-Mapped_IO_MIPS_ASSEMBLY

As a project for Intro to Software Systems, I have implemented the quicksort algorithm using MIPS Assembly Language. Here are the specs for further detail on implementation, outlined below.


SPECS
------

You are required to implement the quicksort algorithm using the MIPS assembly language by completing the quicksort.asm template file provided to you. Your program must use memory-mapped I/O for both the inputs and outputs.

1. As inputs, consider only numbers that have up to two digits.
2. The numbers will be separated by a single blank space.
3. Your program should work correctly on any valid inputs. Also, it should ignore any unknown keys (see the table below for known keys). You may also assume that the user will not enter three consecutive digits.
4. Your program must echo (print) the digits entered by the user.
5. Note that entries such as ’c’, ’s’ and ’q’ are not to be echoed on the screen.
6. You may assume that the program will not be tested on negative numbers.
7. You may also assume a fixed size array (containing at-least 10 elements).
8. In the event that the user presses s with less than 10 numbers having being entered, the results displayed should be only for the numbers entered.
9. If the array has not been cleared (i.e ’c’ has not been pressed), the elements of the array entered previously should be combined with the new entries, before the sorting algorithm is applied.
2
10. You may assume that no attempt will be made to check for the overflow of the array, i.e., that the count of numbers entered will never exceed the size of the array.

key      Meaning                     Echo
0-9      The Digits 0-9              Yes
SPACE    Blank Space                 Yes
c        Clear/Re-initialize array    No
s        Display sorted array         No
q        Quit the program             No

SAMPLE EXECUTION
----------------

  Welcome to QuickSort
  12 3 4 67 89 <s>
  The sorted array is: 3 4 12 67 89
  99 78 <c>
  The array is re-initialized
  20 13 56 99 <s>
  The sorted array is: 13 20 56 99
  3 40 99 78 0 10 <s>
  The sorted array is: 0 3 10 13 20 40 56 78 99 99
  <q>
  <program ends>


