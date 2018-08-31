---
layout: post
section-type: post
title: Statistics Study Notes
category: data_science
tags: [ 'data_science', 'statistics' ]
---

<!-- TOC -->

- [Measures of Central Tendency](#measures-of-central-tendency)
    - [Arithmetic mean](#arithmetic-mean)
    - [Median](#median)
    - [Mode](#mode)
    - [Geometric mean](#geometric-mean)
    - [Harmonic mean](#harmonic-mean)
- [Measures of Dispersion](#measures-of-dispersion)
    - [Range](#range)
    - [Mean Absolute Deviation (MAD)](#mean-absolute-deviation-mad)
- [Variance and standard deviation](#variance-and-standard-deviation)
    - [Semivariance and semideviation](#semivariance-and-semideviation)

<!-- /TOC -->


```python
import scipy.stats as stats
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

np.random.seed(121)
```

# Measures of Central Tendency

## Arithmetic mean

- The arithmetic mean is used very frequently to summarize numerical data, and is usually the one assumed to be meant by the word "average."

- It is defined as the sum of the observations divided by the number of observations:


```python
# We'll use these two data sets as examples
x1 = [1, 2, 2, 3, 4, 5, 5, 7]
x2 = x1 + [100]

print 'Mean of x1:', sum(x1), '/', len(x1), '=', np.mean(x1)
print 'Mean of x2:', sum(x2), '/', len(x2), '=', np.mean(x2)
```

    Mean of x1: 29 / 8 = 3.625
    Mean of x2: 129 / 9 = 14.3333333333


We can also define a <i>weighted</i> arithmetic mean, which is useful for explicitly specifying the number of times each observation should be counted. For instance, in computing the average value of a portfolio, it is more convenient to say that 70% of your stocks are of type X rather than making a list of every share you hold.

The weighted arithmetic mean is defined as
$$\sum_{i=1}^n w_i X_i $$

where $\sum_{i=1}^n w_i = 1$. In the usual arithmetic mean, we have $w_i = 1/n$ for all $i$.

## Median

- The median of a set of data is the number which appears in the middle of the list when it is sorted in increasing or decreasing order.

- The median is less affected by extreme values in the data than the arithmetic mean.

- It tells us the value that splits the data set in half, but not how much smaller or larger the other values are.


```python
print 'Median of x1:', np.median(x1)
print 'Median of x2:', np.median(x2)
```

    Median of x1: 3.5
    Median of x2: 4.0


## Mode

- The mode is the most frequently occuring value in a data set.

- It can be applied to non-numerical data, unlike the mean and the median.

- One situation in which it is useful is for data whose possible values are independent.
    - For example, in the outcomes of a weighted die, coming up 6 often does not mean it is likely to come up 5; so knowing that the data set has a mode of 6 is more useful than knowing it has a mean of 4.5.


```python
# Scipy has a built-in mode function, but it will return exactly one value
# even if two values occur the same number of times, or if no value appears more than once
print 'One mode of x1:', stats.mode(x1)[0][0]

# So we will write our own
def mode(l):
    # Count the number of times each element appears in the list
    counts = {}
    for e in l:
        if e in counts:
            counts[e] += 1
        else:
            counts[e] = 1

    # Return the elements that appear the most times
    maxcount = 0
    modes = {}
    for (key, value) in counts.iteritems():
        if value > maxcount:
            maxcount = value
            modes = {key}
        elif value == maxcount:
            modes.add(key)

    if maxcount > 1 or len(l) == 1:
        return list(modes)
    return 'No mode'

print 'All of the modes of x1:', mode(x1)
```

    One mode of x1: 2
    All of the modes of x1: [2, 5]


For data that can take on many different values, such as returns data, there may not be any values that appear more than once.

In this case we can bin values, like we do when constructing a histogram, and then find the mode of the data set where each value is replaced with the name of its bin.


```python
# Get return data for an asset and compute the mode of the data set
start = '2014-01-01'
end = '2015-01-01'
pricing = get_pricing('SPY', fields='price', start_date=start, end_date=end)
returns = pricing.pct_change()[1:]
print 'Mode of returns:', mode(returns)

# Since all of the returns are distinct, we use a frequency distribution to get an alternative mode.
# np.histogram returns the frequency distribution over the bins as well as the endpoints of the bins
hist, bins = np.histogram(returns, 20) # Break data up into 20 bins
maxfreq = max(hist)
# Find all of the bins that are hit with frequency maxfreq, then print the intervals corresponding to them
print 'Mode of bins:', [(bins[i], bins[i+1]) for i, j in enumerate(hist) if j == maxfreq]
```

    Mode of returns: No mode
    Mode of bins: [(-0.001330629195540084, 0.00097352774911502182)]


## Geometric mean

While the arithmetic mean averages using addition, the geometric mean uses multiplication:
$$ G = \sqrt[n]{X_1X_1\ldots X_n} $$

for observations $X_i \geq 0$. We can also rewrite it as an arithmetic mean using logarithms:
$$ \ln G = \frac{\sum_{i=1}^n \ln X_i}{n} $$

The geometric mean is always less than or equal to the arithmetic mean (when working with nonnegative observations), with equality only when all of the observations are the same.


```python
# Use scipy's gmean function to compute the geometric mean
print 'Geometric mean of x1:', stats.gmean(x1)
print 'Geometric mean of x2:', stats.gmean(x2)
```

    Geometric mean of x1: 3.09410402498
    Geometric mean of x2: 4.55253458762


What if we want to compute the geometric mean when we have negative observations? This problem is easy to solve in the case of asset returns, where our values are always at least $-1$. We can add 1 to a return $R_t$ to get $1 + R_t$, which is the ratio of the price of the asset for two consecutive periods (as opposed to the percent change between the prices, $R_t$). This quantity will always be nonnegative. So we can compute the geometric mean return,
$$ R_G = \sqrt[T]{(1 + R_1)\ldots (1 + R_T)} - 1$$


```python
# Add 1 to every value in the returns array and then compute R_G
ratios = returns + np.ones(len(returns))
R_G = stats.gmean(ratios) - 1
print 'Geometric mean of returns:', R_G
```

    Geometric mean of returns: 0.000540898532267


The geometric mean is defined so that if the rate of return over the whole time period were constant and equal to $R_G$, the final price of the security would be the same as in the case of returns $R_1, \ldots, R_T$.


```python
T = len(returns)
init_price = pricing[0]
final_price = pricing[T]
print 'Initial price:', init_price
print 'Final price:', final_price
print 'Final price as computed with R_G:', init_price*(1 + R_G)**T
```

    Initial price: 179.444
    Final price: 205.53
    Final price as computed with R_G: 205.53


## Harmonic mean

The harmonic mean is less commonly used than the other types of means. It is defined as
$$ H = \frac{n}{\sum_{i=1}^n \frac{1}{X_i}} $$

As with the geometric mean, we can rewrite the harmonic mean to look like an arithmetic mean. The reciprocal of the harmonic mean is the arithmetic mean of the reciprocals of the observations:
$$ \frac{1}{H} = \frac{\sum_{i=1}^n \frac{1}{X_i}}{n} $$

The harmonic mean for nonnegative numbers $X_i$ is always at most the geometric mean (which is at most the arithmetic mean), and they are equal only when all of the observations are equal.


```python
print 'Harmonic mean of x1:', stats.hmean(x1)
print 'Harmonic mean of x2:', stats.hmean(x2)
```

    Harmonic mean of x1: 2.55902513328
    Harmonic mean of x2: 2.86972365624


The harmonic mean can be used when the data can be naturally phrased in terms of ratios. For instance, in the dollar-cost averaging strategy, a fixed amount is spent on shares of a stock at regular intervals. The higher the price of the stock, then, the fewer shares an investor following this strategy buys. The average (arithmetic mean) amount they pay for the stock is the harmonic mean of the prices.

# Measures of Dispersion

- Dispersion measures how spread out a set of data is.

- If returns have been very tight around a central value, then we have less reason to worry. If returns have been all over the place, that is risky.



```python
# Generate 20 random integers < 100
X = np.random.randint(100, size=20)

# Sort them
X = np.sort(X)
print 'X: %s' %(X)

mu = np.mean(X)
print 'Mean of X:', mu
```

    X: [ 3  8 34 39 46 52 52 52 54 57 60 65 66 75 83 85 88 94 95 96]
    Mean of X: 60.2



```python
sns.distplot(X)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x7f66e08fa250>




![png]('/assets/img/posts/quant_study_notes/output_23_1.png')


## Range

- Range is simply the difference between the maximum and minimum values in a dataset.
- Not surprisingly, it is very sensitive to outliers.


```python
print 'Range of X: %s' %(np.ptp(X))
```

    Range of X: 93


## Mean Absolute Deviation (MAD)

- The mean absolute deviation is the average of the distances of observations from the arithmetic mean.
- We use the absolute value of the deviation, so that 5 above the mean and 5 below the mean both contribute 5, because otherwise the deviations always sum to 0.

$$ MAD = \frac{\sum_{i=1}^n |X_i - \mu|}{n} $$

where $n$ is the number of observations and $\mu$ is their mean.


```python
abs_dispersion = [np.abs(mu - x) for x in X]
MAD = np.sum(abs_dispersion)/len(abs_dispersion)
print 'Mean absolute deviation of X:', MAD
```

    Mean absolute deviation of X: 20.52


# Variance and standard deviation

- The variance $\sigma^2$ is defined as the average of the squared deviations around the mean:
$$ \sigma^2 = \frac{\sum_{i=1}^n (X_i - \mu)^2}{n} $$

- This is sometimes more convenient than the mean absolute deviation because absolute value is not differentiable, while squaring is smooth, and some optimization algorithms rely on differentiability.



- __Standard deviation__ is defined as the square root of the variance, $\sigma$.
- It is the easier of the two to interpret because it is in the same units as the observations.


```python
print 'Variance of X:', np.var(X)
print 'Standard deviation of X:', np.std(X)
```

    Variance of X: 670.16
    Standard deviation of X: 25.8874486962


- One way to interpret standard deviation is by referring to **Chebyshev's inequality** (also called the **Bienaymé-Chebyshev inequality**) .
- This tells us that the proportion of samples within $k$ standard deviations (that is, within a distance of $k \cdot$ standard deviation) of the mean is at least $1 - 1/k^2$ for all $k>1$.
- In probability theory, Chebyshev's inequality guarantees that, for a wide class of probability distributions, no more than a certain fraction of values can be more than a certain distance from the mean.
- Specifically, no more than 1/k2 of the distribution's values can be more than k standard deviations away from the mean (or equivalently, at least 1−1/k2 of the distribution's values are within k standard deviations of the mean).


Let's check that this is true for our data set.


```python
k = 1.25
dist = k*np.std(X)
l = [x for x in X if abs(x - mu) <= dist]
print 'Observations within', k, 'stds of mean:', l
print 'Confirming that', float(len(l))/len(X), '>', 1 - 1/k**2
```

    Observations within 1.25 stds of mean: [34, 39, 46, 52, 52, 52, 54, 57, 60, 65, 66, 75, 83, 85, 88]
    Confirming that 0.75 > 0.36


## Semivariance and semideviation

- Although variance and standard deviation tell us how volatile a quantity is, they do not differentiate between deviations upward and deviations downward.
- Often, such as in the case of returns on an asset, we are more worried about deviations downward.
- This is addressed by semivariance and semideviation, which only count the observations that fall below the mean.


Semivariance is defined as:

$$ \frac{\sum_{X_i < \mu} (X_i - \mu)^2}{n_<} $$

where $n_<$ is the number of observations which are smaller than the mean.

Semideviation is the square root of the semivariance.


```python
# Because there is no built-in semideviation, we'll compute it ourselves
lows = [e for e in X if e <= mu]

semivar = np.sum( (lows - mu) ** 2 ) / len(lows)

print 'Semivariance of X:', semivar
print 'Semideviation of X:', np.sqrt(semivar)
```

    Semivariance of X: 689.512727273
    Semideviation of X: 26.2585743572


A related notion is target semivariance (and target semideviation), where we average the distance from a target of values which fall below that target:
$$ \frac{\sum_{X_i < B} (X_i - B)^2}{n_{<B}} $$



```python
B = 19
lows_B = [e for e in X if e <= B]
semivar_B = sum(map(lambda x: (x - B)**2,lows_B))/len(lows_B)

print 'Target semivariance of X:', semivar_B
print 'Target semideviation of X:', np.sqrt(semivar_B)
```

    Target semivariance of X: 188
    Target semideviation of X: 13.7113092008


- sources:
    - [quantopian](www.quantopian.com/lectures)
    - [quantopian/research](github.com/quantopian/research_public)
