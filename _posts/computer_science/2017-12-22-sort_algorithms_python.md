---
layout: post
section-type: post
title: Array sort algorithms in Python
category: computer_science
tags: [ 'sort', 'data_structure', 'algorithm', 'python' ]
---
# Array sort algorithms in Python

## Definitions

**What is stable sorting?**

A sorting algorithm is said to be stable if two objects with equal keys appear in the same order in sorted output as they appear in the input array to be sorted.

**What is in-place sorting?**

An in-place sorting algorithm uses constant extra space even for producing the output (modifies the given array only). For example, Insertion Sort and Selection Sorts are in-place sorting algorithms and a typical implementation of Merge Sort is not in-place.

**What are Internal and External Sortings?**

When all data that needs to be sorted cannot be placed in-memory at a time, the sorting is called external sorting. External Sorting is used for massive amount of data. Merge Sort and its variations are typically used for external sorting. Some extrenal storage like hard-disk, CD, etc is used for external storage.

When all data is placed in-memory, then sorting is called internal sorting.

## Insertion Sort
Insertion sort is a simple sorting algorithm that is relatively efficient for small lists and mostly sorted lists, and is often used as part of more sophisticated algorithms.

| ---- | ---:|
Class | Sorting algorithm
Data structure | Array
Worst-case performance | О(n2) comparisons, swaps
Best-case performance | O(n) comparisons, O(1) swaps
Average performance | О(n2) comparisons, swaps
Worst-case space complexity | О(n) total, O(1) auxiliary
Boundary Cases| Insertion sort takes maximum time to sort if elements are sorted in reverse order. And it takes minimum time (Order of n) when elements are already sorted.
Algorithmic Paradigm| Incremental Approach
Sorting In Place | Yes
Stable | Yes
Online| Yes
Uses| Insertion sort is used when number of elements is small. It can also be useful when input array is almost sorted, only few elements are misplaced in complete big array.

![]({{site.baseurl}}/assets/img/posts/sort/Insertion_sort.gif)
![]({{site.baseurl}}/assets/img/posts/sort/Insertion-sort-example-300px.gif)

{% highlight python %}
def insertion_sort(arr):
    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1
        while j >= 0 and arr[j] and key < arr[j]:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key
    return arr

if __name__ == '__main__':
    test1 = insertion_sort([12, 11, 13, 5, 6])
    if not test1 == [5, 6, 11, 12, 13]: raise AssertionError
{% endhighlight %}

## Merge sort

|-----|-----:|
Class | Sorting algorithm
Data | structure Array
Worst-case performance | O(n log n)
Best-case performance | O(n log n) typical, O(n) natural variant
Average performance | O(n log n)
Worst-case space complexity | О(n) total, O(n) auxiliary
Algorithmic Paradigm | Divide and Conquer
Sorting In Place| No in a typical implementation
Stable| Yes

![]({{site.baseurl}}/assets/img/posts/sort/Merge-sort-example-300px.gif)

{% highlight Python %}
def merge(l, r):
    i = 0
    j = 0
    s = []

    while i < len(l) and j < len(r):
        if (l[i] <= r[j]):
            s.append(l[i])
            i += 1
        else:
            s.append(r[j])
            j += 1

    while i < len(l):
        s.append(l[i])
        i += 1

    while j < len(r):
        s.append(r[j])
        j += 1
    return s

def merge_sort(arr):
    ln = len(arr)

    if ln > 1:
        m  = int(ln / 2)
        l = arr[ : m]
        r = arr[m: ]
        ls = merge_sort(l)
        rs = merge_sort(r)
        return merge(ls, rs)
    else:
        return arr

if __name__ == '__main__':
    test0 = merge_sort([7, 89, 60])
    if not test0 == [7, 60, 89]: raise AssertionError

    test1 = merge_sort([12, 11, 13, 5, 6])
    if not test1 == [5, 6, 11, 12, 13]: raise AssertionError

    test2 = merge_sort([12, 11, 13, 5, 6, 13])
    if not test2 == [5, 6, 11, 12, 13, 13]: raise AssertionError

    test3 = merge_sort([12, 5, 11, 13, 5, 6, 13])
    if not test3 == [5, 5, 6, 11, 12, 13, 13]: raise AssertionError
{% endhighlight %}

## Quick Sort

| ---- | -----: |----|
Class |  Sorting algorithm
Worst-case performance|O(n2)
Best-case performance | O(n log n) (simple partition) | or O(n) (three-way partition and equal keys)
Average performance | O(n log n)
Worst-case space complexity | O(n) auxiliary (naive) | O(log n) auxiliary (Sedgewick 1978)

![]({{site.baseurl}}/assets/img/posts/sort/Sorting_quicksort_anim.gif)

{% highlight Python %}
def partition(array, begin, end):
    pivot = begin
    for i in range(begin + 1, end + 1):
        if array[i] <= array[begin]:
            pivot += 1
            array[i], array[pivot] = array[pivot], array[i]
    array[pivot], array[begin] = array[begin], array[pivot]
    return pivot

def quick_sort(array, begin=0, end=None):
    if end is None:
        end = len(array) - 1
    def _quicksort(array, begin, end):
        if begin >= end:
            return
        pivot = partition(array, begin, end)
        _quicksort(array, begin, pivot - 1)
        _quicksort(array, pivot + 1, end)
        return array
    return _quicksort(array, begin, end)

if __name__ == '__main__':
    test0 = quick_sort([7, 89, 60])
    print('test0', test0)
    if test0 != [7, 60, 89]: raise AssertionError

    test1 = quick_sort([12, 11, 13, 5, 6])
    print('test1', test1)
    if test1 != [5, 6, 11, 12, 13]: raise AssertionError

    test2 = quick_sort([12, 11, 13, 5, 6, 13])
    print('test2', test2)
    if test2 != [5, 6, 11, 12, 13, 13]: raise AssertionError

    test3 = quick_sort([12, 5, 11, 13, 5, 6, 13])
    print('test3', test3)
    if test3 != [5, 5, 6, 11, 12, 13, 13]: raise AssertionError
{% endhighlight %}
