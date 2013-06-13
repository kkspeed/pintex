pintex
======

Beamer + Pinpoint


Introduction
------
Beamer is a great LaTeX package to rapidly make professional slides. Yet, when 
compiled to PDF, it lacks support for fancy animation, text overlay, embeded 
videos etc.

Pinpoint, a comparatively young project aiming to become
"A tool for making hackers do excellent presentations". Writing a pinpoint
script is easy and painless but I really miss the flexibility Beamer gives me.

Thus, pintex comes. It aims to make Beamer and Pinpoint work together to give
Beamer slides more fancy effects yet preserves its flexibility in arranging text.

There is a similar implementation with ConTeXT
([Find here](http://garfileo.is-programmer.com/2011/7/25/pincomment-command-for-pinpoint-speaker-view.28245.html)),
but I'd like to make sth that works with more LaTeX implementations.

Compiling
------
(Currently) the project only has 1 file: pintex.hs (This is my first time to 
write actual Haskell code, feel free to point out any weakness, non-idiomatic
style etc.). To compile it, you'll need a haskell compiler (I test with GHC).

    ghc pintex.hs -o pintex

Also, you'll need the following dependencies:

1. HSH: provide shell functionality.

2. regex-pcre: provide Perl style regex implementation.

Usage
------
To use pintex, you'll need to ensure that you have xelatex and imagemagick 
installed(sorry about the hard coded xelatex command, I'll try to improve it
later). Also, your slides should only be specified with:

    \begin{frame}
    \end{frame}

and it should appear at the start of the line(default indentation for most 
editors).

In the .tex file, please add the following lines to enable "pinpoint" 
envirionment. 

    \usepackage{environ}
    \NewEnviron{pinpoint}{}


The environment ensures that Beamer treat anything insied pinpoint environment
as nothing and allow the tex file to compile as usual.

Then in the tex file,  you can use:

    \begin{pinpoint}
    \end{pinpoint}

to add pinpoint code inside. A pinpoint environment appear outside of the frame
environment will make the commands totally escaped, and thus, it's your
responsibility to write thorough pinpoint code.

On the other hand, a pinpoint environment appear inside the frame environment
will only contain the text part(the header is created automatically when pintex
see begin{frame}). Also, a "pause" command in beamer will also cause a new 
slides in pinpoint.

To add more style to your frame, you can use % pin: followed by pinpoint
commands after "pause" for begin{frame}. eg:

    \begin{frame} %pin: [text-align=left]
    \end{frame}

Then to make a pinpoint script, run:

    pintex input.tex output.pin

You'll see a lot of png files generated from the originally pdf file acting as
background in the pinpoint presentation.

Note
------
This project is at its very beginning and I'm just trying to make some slides
with it to meet several deadlines. Thus, any improvement may be delayed to a month later.
My next steps would be:

1. Provide more flexibility in configuration such as specifying LaTeX 
   implemntation

2. Work with intermediate results produced by LaTeX compiler instead of the .tex 
   file itself
