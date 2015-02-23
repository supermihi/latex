LaTeX packages and definitions by Michael Helmling
==================================================

This repository contains LaTeX packages created by myself. Some of them are for mainly for personal use, some might be interested for others as well.

Exercise sheets: `mhex.sty` and `mhexsheet.cls`
-----------------------------------------------
The class `mhexsheet` is used for exercise typesetting. It contains environments for exercises and solutions; the latter can be conveniently turned on or off by a package option. The class also creates an exercise title depending on the metadata provided. It is pre-configured for use at the University of Koblenz-Landau (by means of the default logo), but that is easy to change. Translations are available in English and German. See the `mhex-examples` directory for usage examples.

The `exercise` and `solution` environments can be used separately from the class by including the `mhex` package.

An older version of the exercise sheet class is contained in the `agopt_ex` directory.

Logo of the University of Koblenz-Landau
----------------------------------------
The package `unikoblenzlogo` defines the single command `\unikoblenzlogo` which typesets the official logo of my university using tikz (no needs for includegraphics).

General document setup packages (`mh_basic`, `mh_theorems`, `mh_tikz`)
----------------------------------------------------------------------
These are convenience packages which set up the document in the way I prefer and load some common packages. `mh_basic` is the most sophisticated one, allowing a number of options. It configures fonts and language in a way that works with `pdflatex` as well as `xelatex` or `lualatex`.

Feel free to use, distribute and modify anything you find in this repository at your free will.
