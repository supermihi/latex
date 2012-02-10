#!/bin/sh
latex agopt_ex.ins &&  pdflatex agopt_ex.dtx  && makeindex -s gglo.ist -o agopt_ex.gls agopt_ex.glo && makeindex -s gind.ist -o agopt_ex.ind agopt_ex.idx && pdflatex agopt_ex.dtx
