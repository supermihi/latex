% !TeX encoding = UTF-8
\NeedsTeXFormat{LaTeX2e}[2011/06/27]
\RequirePackage{expl3,l3keys,l3keys2e,l3skip}
\ProvidesExplClass{mhexsheet}{2013/09/26}{0.1}{Exercise Sheets by Michael Helmling}
\RequirePackage{etoolbox}

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
  
  showanswers .bool_set:N = \l_mhex_showanswers
}
\keys_set:nn { mhexsheet } {
  language    = german,
  showanswers = false
}

\keys_define:nn { mhex } {
  lecture      .tl_set:N = \l_mhex_lecture,
  lectureshort .tl_set:N = \l_mhex_lectureshort,
  semester     .tl_set:N = \l_mhex_semester,
  deadline     .tl_set:N = \l_mhex_deadline,
  lecturer     .tl_set:N = \l_mhex_lecturer,
  operator     .tl_set:N = \l_mhex_operator,
  homepage     .tl_set:N = \l_mhex_homepage,
  inclassdate  .tl_set:N = \l_mhex_inclassdate
}
\keys_set:nn { mhex } {
  lecture      = No~Lecture~Given,
  lectureshort = No~Lecture,
  semester     = No~Semester~Given,
  deadline     = No~Deadline~Given,
  lecturer     = No~Lecturer~Given,
  operator     = No~Operator~Given,
  homepage     =,
  inclassdate  =,
}

\ProcessKeysOptions{mhexsheet}

\LoadClass[a4paper,11pt,parskip=half-]{scrartcl}


\RequirePackage{mhex}
\RequirePackage{iftex}
\RequirePackage{unikoblenzlogo}
\RequirePackage{amsfonts,amssymb}

\ifPDFTeX
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[T1]{fontenc}
  \RequirePackage{libertine}
  \RequirePackage{inconsolata}
  \RequirePackage[\l_mhex_babel]{babel}
\else
  \RequirePackage{eulervm}
  \RequirePackage{fontspec}
  \setromanfont{Linux~Libertine~O}
  \setsansfont{Linux~Biolinum~O}
  \setmonofont{Inconsolata}
  \defaultfontfeatures{Ligatures=TeX}
  \RequirePackage{polyglossia}
  \ExplSyntaxOff
    \setmainlanguage{\mhexlang}
  \ExplSyntaxOn
  \RequirePackage{hyperref}
\fi
\RequirePackage{fancyhdr}
\RequirePackage{zref-totpages}

% TITLE STUFF

\newcommand\titledateline{
  \ifstrempty{ \l_mhex_deadline }
    { \l_mhex_inclasstext }
    { \l_mhex_deadlinetext{}~\l_mhex_deadline }
}
\DeclareDocumentCommand\maketitle{}
  {
    \hrule
    \vspace{2mm}
    \begin{minipage}{\dim_eval:n {\textwidth - 5.8cm}}
      \textsf{\l_mhex_lecture \enspace \textbullet \enspace \l_mhex_semester} \\
      \textsc{
        \LARGE \l_mhex_exercisesheettext{}~\l_mhex_sheetno
        \bool_if:NTF
          \l_mhex_showanswers
          { \Large{} (~\l_mhex_withsolutionstext) }
          {  }
      }\\
      \normalsize\textit{\titledateline}
    \end{minipage}
    
    \begin{minipage}{5.8cm}
      \begin{flushright}
        \unikoblenzlogo
      \end{flushright}
    \end{minipage}
    
    \vspace{2mm}
    \hrule
    
    \begin{center}
      \small
      \textbf{\l_mhex_lecturetext :~}   \l_mhex_lecturer\\
      \textbf{\l_mhex_exercisestext :~} \l_mhex_operator
    \end{center}
    \vspace{-2mm}
    \tl_if_empty:NTF
      \l_mhex_homepage
      {  }
      {\small \l_mhex_homepagetext}
  }

% HEADER and FOOTER SETUP

\pagestyle{fancy}
\fancyhead{}
\renewcommand\headrulewidth{0pt}
\renewcommand\footrulewidth{.4pt}
\cfoot{
  \bool_if:NTF
    \l_mhex_solution
    \l_mhex_solutionsheettext
    \l_mhex_exercisesheettext
  \l_mhex_sheetno
}
\rfoot{\l_mhex_pagetext{}~\thepage/\ztotpages}
\lfoot{\l_mhex_lectureshort}