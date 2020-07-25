Sierpinski Sound
==================

Triangle Background:
----------------------------------------------

The Sierpinski Triangle is a fractal. According to [Wikipedia](http://en.wikipedia.org/wiki/Sierpinski_triangle) it was named after "mathematician Waclaw Sierpinski who described it in 1915. However, similar patterns appear already in the 13th-century Cosmati mosaics in the cathedral of Anagni, Italy." You can create the Sierpinski Triangle (and very similar fractals) with surprisingly little code. The following picture and instructions are also from Wikipedia.

![Alt text](http://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Sierpinski_triangle_evolution.svg/512px-Sierpinski_triangle_evolution.svg.png)

Start with any triangle, though the usual Sierpinski triangle uses an equilateral triangle. Shrink the triangle to ½ height and ½ width, make three copies, and position the three shrunken triangles so that each triangle touches the two other triangles at a corner (image 2). Note the emergence of the central hole - because the three shrunken triangles can between them cover only 3/4 of the area of the original. (Holes are an important feature of Sierpinski's triangle.) Repeat step 2 with each of the smaller triangles (image 3 and so on).

Sound Add-On:
----------------------------------------------

Using the audioin <device number> and audioout <device number> commands and then running start, audio can be routed through the triangle. Use the debug output or devicelist command to get audio device numbers.
