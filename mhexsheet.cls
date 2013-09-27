\NeedsTeXFormat{LaTeX2e}[2011/06/27]
\RequirePackage{expl3,l3keys2e}
\ProvidesExplClass{mhexsheet}{2013/09/26}{0.1}{Exercise Sheets by Michael Helmling}
\RequirePackage{etoolbox}

%\DeclareOption*{
%  \PassOptionsToClass{\CurrentOption}{scrartcl}%
%}

\cs_new:Nn \mhexsheet_loadenglishcaptions: {
  \tl_set:Nn \l_mhex_exercisesheettext { Exercise~Sheet }
  \tl_set:Nn \l_mhex_solutionsheettext { Solution~Sheet }
  \tl_set:Nn \l_mhex_withsolutionstext { including~solutions }
  \tl_set:Nn \l_mhex_pagetext          { Page }
  \tl_set:Nn \l_mhex_deadlinetext      { Due~date: }
  \tl_set:Nn \l_mhex_lecturetext       { Lecture }
  \tl_set:Nn \l_mhex_exercisestext     { Exercises }
  \tl_set:Nn \l_mhex_homepagetext      { Download~this~sheet~at~\url{\l_mhex_homepage} }
  \tl_set:Nn \l_mhex_inclasstitletext  { In-Class~Exercises }
  \tl_set:Nn \l_mhex_inclasstext       { To~be~done~in~the~tutorial~on~\l_mhex_inclassdate }
  \tl_set:Nn \l_mhex_takehometitletext { Turn-In~Exercises }
  \tl_set:Nn \l_mhex_takehometext      { Please~hand~in~by~\l_mhex_deadline }
  \tl_set:Nn \l_mhex_deadlinepretext   { Deadline: }
}
\cs_new:Nn \mhexsheet_loadgermancaptions: {
  \tl_set:Nn \l_mhex_exercisesheettext { Übungsblatt }
  \tl_set:Nn \l_mhex_solutionsheettext { Lösungsblatt }
  \tl_set:Nn \l_mhex_withsolutionstext { mit~Lösung }
  \tl_set:Nn \l_mhex_pagetext          { Seite }
  \tl_set:Nn \l_mhex_deadlinetext      { Abgabe~bis}
  \tl_set:Nn \l_mhex_lecturetext       { Vorlesung }
  \tl_set:Nn \l_mhex_exercisestext     { Übungen }
  \tl_set:Nn \l_mhex_homepagetext      { Dieses~Übungsblatt~sowie~weitere~Informationen~zur~Übung~sind~unter~\url{\l_mhex_homepage}~erhältlich }
  \tl_set:Nn \l_mhex_inclasstitletext  { Präsenzübungen }
  \tl_set:Nn \l_mhex_inclasstext       { Zur~Bearbeitung~in~der~Übung~am~\l_mhex_inclassdate }
  \tl_set:Nn \l_mhex_takehometitletext { Hausübungen }
  \tl_set:Nn \l_mhex_takehometext      { Bitte~bis~\l_mhex_deadline{}~abgeben}
  \tl_set:Nn \l_mhex_deadlinepretext   { Abgabefrist: }
}

\keys_define:nn { mhexsheet } {
  language .choice:,
  language / german  .code:n = {
                                 \tl_set:Nn \mhexlang  { german  }
                                 \tl_set:Nn \l_mhex_babel { ngerman }
                                 \mhexsheet_loadgermancaptions:
                               },
  language / english .code:n = {
                                 \tl_set:Nn \mhexlang  { english }
                                 \tl_set:Nn \l_mhex_babel { english }
                                 \mhexsheet_loadenglishcaptions:
                               },
  german  .meta:n = {
    language = german
  },
  english .meta:n = {
    language = english
  },
  
  showanswers .bool_set:N = \l_mhex_showanswers,
}
\keys_set:nn {mhexsheet} {
  language    = german,
  showanswers = false
}
\ProcessKeysOptions{mhexsheet}\relax

\LoadClass[a4paper,11pt,parskip=half-]{scrartcl}
\RequirePackage{mhex}
\RequirePackage{iftex}
\ifPDFTeX
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[T1]{fontenc}
  \RequirePackage[\l_mhex_babel]{babel}
\else
  \RequirePackage{amsfonts,amssymb}
  \RequirePackage{eulervm}
  \RequirePackage{fontspec}
  \RequirePackage{polyglossia}
  \ExplSyntaxOff
    \setmainlanguage{\mhexlang}
  \ExplSyntaxOn
  \RequirePackage{hyperref}
\fi




\cs_new:Npn \Lecture     #1  {\tl_set:Nn \l_mhex_lecture     { #1 }}
\cs_new:Npn \Semester    #1  {\tl_set:Nn \l_mhex_semester    { #1 }}
\cs_new:Npn \Deadline    #1  {\tl_set:Nn \l_mhex_deadline    { #1 }}
\cs_new:Npn \Lecturer    #1  {\tl_set:Nn \l_mhex_lecturer    { #1 }}
\cs_new:Npn \Operator    #1  {\tl_set:Nn \l_mhex_operator    { #1 }}
\cs_new:Npn \Homepage    #1  {\tl_set:Nn \l_mhex_homepage    { #1 }}
\cs_new:Npn \Inclassdate #1  {\tl_set:Nn \l_mhex_inclassdate { #1 }}

\tl_set:Nn \l_mhex_lecture  { No~Lecture }
\tl_set:Nn \l_mhex_semester { WS~1999/00 }
\tl_set:Nn \l_mhex_deadline { 19.09.1990 }
\tl_set:Nn \l_mhex_lecturer { Jack~Edmonds }
\tl_set:Nn \l_mhex_operator { Martin~Grötschel }
\tl_set:Nn \l_mhex_homepage { www.mathe.de }
\tl_set:Nn \l_mhex_inclassdate { 20.09.1990 }



\newcommand\titledateline{
  \ifstrempty{ \l_mhex_deadline }
    { \l_mhex_inclasstext }
    { \l_mhex_deadlinetext{}~\l_mhex_deadline }
}
\DeclareDocumentCommand\maketitle{}
  {
    \hrule
    \vspace{2mm}
    \begin{minipage}{0.55\textwidth}
    {\sffamily \l_mhex_lecture{}\enspace\textbullet\enspace\l_mhex_semester\\
    \LARGE \scshape  \l_mhex_exercisesheettext{}~\l_mhex_sheetno
    \bool_if:NTF \l_mhex_showanswers {%
      {\Large{} (~\l_mhex_withsolutionstext)}%
    }{}\\
    \small \upshape \itshape \rmfamily \titledateline }
    \end{minipage}
    \begin{minipage}{0.44\textwidth}
      \begin{flushright}
        LOGO
      \end{flushright}
    \end{minipage}\vspace{2mm}\hrule
    \begin{center}\small
      \textbf{\l_mhex_lecturetext :~} \l_mhex_lecturer\\
      \textbf{\l_mhex_exercisestext :~} \l_mhex_operator
    \end{center}\vspace{-2mm}
    \ifstrempty{\l_mhex_homepage}{}{
      {\small \l_mhex_homepagetext}
    }
  }
