# Euler Problemset using SAGEMath

This [SAGEmath](https://www.sagemath.org/) (Python) Jupyter practice notebook exists as a portfolio component to demonstrate mastery to employers. Since I'm a big fan of SAGEmath, this is also somewhat of a case study for why SAGEmath make a lot of relatively complex mathematical questions simple to optimize. 

If you are solving the problems for the sake of learning and found yourself here, please read this excerpt from the [Project Euler](https://projecteuler.net/) page: 
> _There is nothing quite like that "Aha!" moment when you finally beat a problem which you have been working on for some time. It is often through the best of intentions in wishing to share our insights so that others can enjoy that moment too. Sadly, that will rarely be the case for your readers. Real learning is an active process and seeing how it is done is a long way from experiencing that epiphany of discovery. Please do not deny others what you have so richly valued yourself._


### Why SAGEmath for Project Euler Problems

The approach to these problems focuses on using the appropriate tools to tackle appropriate problems. Since mathematical research software have seen significant optimization in NumPy, SciPy, etc., and C++ packages make things go vroom already, SAGEmath is appropriate because:

0. **Accessibility**: Sagemath is _FOSS_ alternative to Magma, Maple, Mathematica, and MATLAB; designed by and for mathematics researchers, and usable for anyone who knows python.
1. **Ease of Use**:
   - [Linux installation](https://doc.sagemath.org/html/en/installation/linux.html#sec-gnu-linux) is super easy on Linux since Python and TeX come prepackaged in many distros. Windows and Mac simple installation also available too.
   - [Jupyter integration] as demonstrated in this project. 
   - [CoCalc](https://cocalc.com/features/sage) allows for collaborative computational work (freemium).
2. **Highly Optimized**: "SageMath allows those students who are more interested in math than `malloc()` to spend more time thinking about math and less time figuring out why their code segfaults."


#### Notes:
- `README.md` is the output of the `euler-problemset-sage.ipynb` file.
- [LaTeX](https://www.latex-project.org/) elements in this document can be viewed using these browser extensions:
   - [Native Mathml (Firefox)](https://addons.mozilla.org/en-US/firefox/addon/native-mathml/) [Source](https://github.com/fred-wang/webextension-native-mathml)
   - [Tex All the Things (Chrome)](https://chrome.google.com/webstore/detail/tex-all-the-things/cbimabofgmfdkicghcadidpemeenbffn?hl=en) [Source](https://github.com/emichael/texthings)


## Problems and Solutions

### Problem 1
If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23. Find the sum of all the multiples of 3 or 5 below 1000.

#### Naive Solution:


```python
# Python Simple Solution (1000 is so smol)

sum([x for x in range(1,1000) if mod(x,3)==0 or mod(x,5)==0])
```




    233168



#### Math Solution:

Note that for an arithimetic sequence, $$\sum_{i=j}^k a_i =  \frac {n (a_j + a_k)} 2, \text{ where $n$ is the number of terms to be summed}$$ 

And in the case of all the multiples of 3 under 1000, we can simply find 
1. How many multiples of 3 exists from 1 up to 999? ($n = \left\lfloor \frac{1000} 3 \right\rfloor = 333$).
2. First Term: 3, Last term: 999.

Furthermore, note that if we create the set of all the multiples of 3 up to 999, and if we then create the set of all multiples of 5 up to 999, the multiples of 15 is counted twice; so we simply need to evaluate the sum of the first two finite arithimetic series and take away the last.


```python
# Using some arithimetic
def sum_multiples_below(limit, divisor):
    ''' Finds sum of all the natural numbers under the limit 
        that are divisible by the divisor'''
    # The -1 on the upperbound is cuz the problem is "strictly" less than.
    maxfactor = floor((limit-1)/divisor) 
    return (maxfactor)/2*(divisor + maxfactor*divisor)

sum_multiples_below(1000, 3) + sum_multiples_below(1000, 5) - sum_multiples_below(1000,15)

```




    233168



A Quick Comparision between the two methods:


```python
%timeit sum([x for x in range(1,1000000) if mod(x,3)==0 or mod(x,5)==0])

%timeit sum_multiples_below(1000000, 3) + sum_multiples_below(1000000, 5) - sum_multiples_below(1000000,15)
```

    4.33 s ± 32.7 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)
    5.38 µs ± 34.3 ns per loop (mean ± std. dev. of 7 runs, 100,000 loops each)


### Problem 2

Each new term in the Fibonacci sequence is generated by adding the previous two terms. By starting with 1 and 2, the first 10 terms will be: 
   
   1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ... 
   
   By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.

#### Naive Solution:
Since the requirements is only up to 4 million, we're not really going so far down the fibonaccci sequence. 


```python
 def even_fib_sum(upperbound):
    evensum = 0
    i = 0
    F = 0
    while F < upperbound:
        if mod(F,2) == 0:
            evensum += F
        i += 1
        F = fibonacci(i)
    return evensum

print(even_fib_sum(4000000))
```

    4613732


#### Math Solution: 

First, recall the formal definition of the Fibonacci sequence. Given some natural number $n$, the $n$-th Fibonacci number, $F(n)$ is defined to be:

$$ F(n) = F(n-1) + F(n-2) \text{ with } F(0) = 0 \text{ and } F(1) = 1.$$

__Claims:__


1. Every Fibnocci number whose index is a multiple of three is even, and only those are even.

2. The sum of _even_ Fibonacci numbers beginning from $F(0)$ up to some $F(n)$ is exactly half of the sum of all the Fibonacci numbers up to $F(n)$

3. This sum can be evaluated with $\displaystyle\frac{(F(n+2)-1)} 2$

__Proofs:__ 

Claim 1: _Every Fibnocci number whose index is a multiple of three is even, and only those are even._

Base case:
$$\begin{align*}
F(1), F(2) \text{ is odd } &\implies F(3) \text{ is even }; \\
F(2) \text{ is odd and } F(3) \text{ is even } &\implies F(4) \text{ is odd }; \\
F(3) \text{ is even and }  F(4) \text{ is odd } &\implies F(5) \text{ is odd }; \\
F(4) \text{ is odd and } F(5) \text{ is odd } &\implies F(6) \text{ is even }.
\end{align*}$$

Assuming that there exists two odd numbers in the sequence and the following must be even, then the same structure holds, and $F(n-2), F(n-1)$ is odd $\implies F(n)$ must be even. Replacing the indcies of the above statements one will arrive then to the statement: $F(n)$ is even must imply F(n+3) is also even. Since F(3) is even, all index of even Fibnocci numbers are multiples of three. 
Q.E.D.

That means we're really just summing up every third Fibnocci number.

Proofs: 

Claim 2: _The sum of even Fibonacci numbers beginning from $F(0)$ up to some $F(n)$ is exactly half of the sum of all the Fibonacci numbers up to $F(n)$_

$$\begin{align*}
\sum_{i=0}^{k} F(3i) &=  F(3) + F(6) + \cdots + F(3k)\\
&\text{ by subsitution definiton of each term:} \\
\sum_{i=0}^{k} F(3i) &=  (F(1) + F(2)) + (F(4) + F(5)) + \cdots + (F(3k-2) + F(3k-1))\\ 
& \text{ add the above two lines } \\
\implies 2 \sum_{i=0}^{k} F(3i) &= F(1) + F(2) + F(3) + \cdots + F(3k) \\
\implies \sum_{i=0}^{k} F(3i) &= \frac 1 2 \sum_{i=0}^{3k} F(i) \\ 
\end{align*}$$


Recall a well known lemma on the sum of the first $k$ terms of the Fibnocci sequence is exactly the $k+2$-th Fibnocci number minus one: $$\displaystyle\sum_{i=1}^k F(i) = F(k+2)-1,$$ which in turn imply $$\sum_{i=0}^{k} F(3i) = \frac{F(3k+2)-1} 2 $$ where $3k$ is the index of the largest even Fibonocci number under the defined upperbound. This index $3k$ such that $F(n) < M$ for some upperbound $M$ requires a couple of steps:
1. Note $F_{3k} \approx \left\lfloor\frac{\Phi^{3k}}{\sqrt{5}}\right\rfloor$
2. Thus, Given some $M$, we can estimate $n$ by examining the inverse:
$$ \begin{align*}
M \approx \frac{\Phi^{3k}}{\sqrt{5}}\\
\implies \ln(\sqrt{5} M) &\approx 3k \ln(\Phi) \\
\implies \frac{\ln(\sqrt{5} M)}{\ln(\Phi)} &\approx 3k
\end{align*}$$


```python
def even_fib_sum_quick(upperbound):
    # Quick estimate of Fibnacci index since Fib(n) is approx Phi^n / sqrt(5).
    max_fib_index_est = int(round((ln(upperbound * sqrt(5))/ln(golden_ratio)), 0))
    
    # Nearest even fibonacci has index that is a multiple of 3
    max_even_fib_index_est = max_fib_index_est - (max_fib_index_est % 3)
    
    return round((fibonacci(max_even_fib_index_est+2)-1)/2,0)

print(even_fib_sum_quick(4000000))
```

    4613732



```python
# Comparing the Methods
%timeit even_fib_sum(1e100)
%timeit even_fib_sum_quick(1e100)
```

    2.42 ms ± 162 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
    222 µs ± 1.19 µs per loop (mean ± std. dev. of 7 runs, 1,000 loops each)


#### Problem 3

The prime factors of 13195 are 5, 7, 13 and 29.
What is the largest prime factor of the number 600851475143?

__Remarks:__
Prime factorization is already optimized in SAGEmath.


```python
%timeit factor(600851475143)

factor(600851475143)
```

    5.63 µs ± 113 ns per loop (mean ± std. dev. of 7 runs, 100,000 loops each)





    71 * 839 * 1471 * 6857



#### Problem 4
A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit numbers.


```python
m = 999
n = 999

palindrome_prod = []

while m > 100:
    while n >= m:
        prod = m*n
        if Word(str(prod)).is_palindrome():
            palindrome_prod.append(prod)
        n -= 1
    m -= 1
    n = 999

print(max(palindrome_prod))
```

    906609


2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?


```python
%timeit lcm(range(1,21))
lcm(range(1,21))
```

The sum of the squares of the first ten natural numbers is 385

The square of the sum of the first ten natural numbers is 3025

Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is .

Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.


```python
sum(range(1,101))^2 - sum([x^2 for x in range(1,101)])
```




    25164150




```python

```
