---
layout: post
section-type: post
title: This Parameter in JavaScript
category: javascript
tags: [ 'javascript', 'nodejs' ]
---
# 'This' Parameter in JavaScript

## Q: How to get the actual value of the parameter `this`?

### Answer

- `this` will alwas take the value of the apearing on the left side of the `.`

{% highlight javascript %}
var fn = function(one, two){
  console.log(this, one, two);
}

var r = {r: 'r'}, g = 'g', b = 'b';

r.method = fn;

r.method(g, b); // this will log => r, g, b
{% endhighlight %}

- If there is no `.` in method call `this` will refer to the `global` object

{% highlight javascript %}
var fn = function(one, two){
  console.log(this, one, two);
}

var r = {}, g = 'g', b = 'b';

fn(g, b); // this will log => <global> , g, b
{% endhighlight %}

- What if we want to define `this` our selfes without making the methon as a property of another object

  - **We can do that by using `call` method**

{% highlight javascript %}

var fn = function(one, two){
  console.log(this, one, two);
}

var r = {}, g = 'g', b = 'b';

fn.call(r, g, b); // this will log => r, g, b

{% endhighlight %}

- Even we can overwrite the default `.` rule to pass a custom object to `this` to refer to using `call` method like that

{% highlight javascript %}
var fn = function(one, two){
  console.log(this, one, two);
}

var r = {}, g = 'g', b = 'b', y = 'y';

r.method = fn;

r.method.call(y, g, b); // this will log => y, g, b
{% endhighlight %}

- what will happen When some function is passed as a parameter to another function `this`

{% highlight javascript %}

var fn = function(one, two){
  console.log(this, one, two);
}

var r = {}, g = 'g', b = 'b', y = 'y';

setTimeout(fn, 100); // this will log => <global>, undefined, undefined

{% endhighlight %}

- consider also this example
  - The only moment that matter is when the function get invoked not when it is passed, So this will also print out `global` not `r`

{% highlight javascript %}

var fn = function(one, two){
  console.log(this, one, two);
}

var r = {}, g = 'g', b = 'b', y = 'y';

r.method = fn;

setTimeout(r.method, 100);// this will also log => <global>, undefined, undefined

{% endhighlight %}

- Now let's try this example, `this` will behave like normal in such case as the calling time is what we are caring of

{% highlight javascript %}

var fn = function(one, two){
  console.log(this, one, two);
}

var r = {}, g = 'g', b = 'b', y = 'y';

r.method = fn;

setTimeout(function(){
  r.method(g,b);
}, 100); // this will log => r, g, b

{% endhighlight %}

- For the last example we can see new object empty object created in case we used `new` with our call

{% highlight javascript %}
var fn = function(one, two){
  console.log(this, one, two);
}

var r = {}, g = 'g', b = 'b';

r.method = fn;

new r.method(g, b); // this will log => {}, g, b
{% endhighlight %}
