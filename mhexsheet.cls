% !TeX encoding = UTF-8
\NeedsTeXFormat{LaTeX2e}[2011/06/27]
\RequirePackage{expl3,l3keys,l3keys2e,l3skip}
\ProvidesExplClass{mhexsheet}{2013/09/26}{0.1}{Neatly designed exercise sheets with tons of options.}

% ======================================================================================== %
% ============ Set Class Options for Language Setup and Load scrartcl ==================== %
% ======================================================================================== %
\keys_define:nn { mhexsheet } {
  language .choice:,
  language / german  .tl_set:N = \lmhexlang,
  language / english .tl_set:N = \lmhexlang,
  german             .meta:n   = { language = german  },
  english            .meta:n   = { language = english },

}
\LoadClass[a4paper,11pt,parskip=half-]{scrartcl}


% ======================================================================================== %
% ======== Basic Setup: Language (babel/polyglossia), Encoding, and Fonts ================ %
% ======================================================================================== %

\RequirePackage{iftex}
\tl_set:Nn \l_mhex_babel { ngerman }
\ProcessKeysOptions{mhexsheet}
\ifPDFTeX
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[T1]{fontenc}
  \RequirePackage{libertine}
  \RequirePackage{inconsolata}
  \ifstrequal
    {\lmhexlang}
    {english}
    {\RequirePackage[english]{babel}}
    {\RequirePackage[ngerman]{babel}}
\else
  \RequirePackage{eulervm}
  \RequirePackage{fontspec}
  \defaultfontfeatures{Ligatures=TeX}
  \setromanfont{Linux~Libertine~O}
  \setsansfont{Linux~Biolinum~O}
  \setmonofont{Inconsolata}
  \RequirePackage{polyglossia}
  \ExplSyntaxOff\setmainlanguage\lmhexlang\ExplSyntaxOn
\fi
\RequirePackage{mhex}

% === predefined captions ================================================================ %
\l_mhex_addcaption:Nnn {exercisesheet} {Übungsblatt}    {Exercise~Sheet}
\l_mhex_addcaption:Nnn {solutionsheet} {Lösungsblatt}   {Solution~Sheet}
\l_mhex_addcaption:Nnn {withsolutions} {mit~Lösung}     {including~solutions}
\l_mhex_addcaption:Nnn {page}          {Seite}          {Page}
\l_mhex_addcaption:Nnn {deadline}      {Abgabe~bis}     {Due~date:}
\l_mhex_addcaption:Nnn {lecture}       {Vorlesung}      {Lecture}
\l_mhex_addcaption:Nnn {exercises}     {Übungen}        {Exercises}
\l_mhex_addcaption:Nnn {inclasstitle}  {Präsenzübungen} {In-Class~Exercises}
\l_mhex_addcaption:Nnn {takehometitle} {Hausübungen}    {Turn-In~Exercises}
\l_mhex_addcaption:Nnn {deadlinepre}   {Abgabefrist:}   {Deadline:}
\l_mhex_addcaption:Nnn {exam}          {Klausur}        {Exam}
\l_mhex_addcaption:Nnn {takehome}
  {Bitte~bis~\l_mhex_deadline{}~abgeben}
  {Please~hand~in~by~\l_mhex_deadline}
\l_mhex_addcaption:Nnn {inclass}
  {Zur~Bearbeitung~in~der~Übung~am~\l_mhex_date}
  { To~be~done~in~the~tutorial~on~\l_mhex_date }
\l_mhex_addcaption:Nnn {homepage}
  {Dieses~Übungsblatt~sowie~weitere~Informationen~zur~Übung~
   sind~unter~\url{\l_mhex_homepage}~erhältlich}
  {Download~this~sheet~at~\url{\l_mhex_homepage}}
% ======================================================================================== %

% ======================================================================================== %
% ============================ Load Additional Packages ================================== %
% ======================================================================================== %

\RequirePackage{hyperref}
\RequirePackage{unikoblenzlogo}
\RequirePackage[top=2cm]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{zref-totpages}


% ======================================================================================== %
% ========================= Extend mhex l3keys definitions =============================== %
% ======================================================================================== %

\keys_define:nn { mhex } {
  lecture      .tl_set:N = \l_mhex_lecture,
  lectureshort .tl_set:N = \l_mhex_lectureshort,
  semester     .tl_set:N = \l_mhex_semester,
  deadline     .tl_set:N = \l_mhex_deadline,
  lecturer     .tl_set:N = \l_mhex_lecturer,
  operator     .tl_set:N = \l_mhex_operator,
  homepage     .tl_set:N = \l_mhex_homepage,
  date         .tl_set:N = \l_mhex_date,
  title        .code:n   = \AtBeginDocument{\tl_set:Nn \l_mhex_examtext {#1}},
}
\keys_set:nn { mhex } {
  lecture      = No~Lecture~Given,
  lectureshort = ,
  semester     = ,
  deadline     = ,
  lecturer     = ,
  operator     = ,
  homepage     = ,
  date         = ,
}
\tl_if_empty:NTF
  \l_mhex_lectureshort
  {\tl_set:Nn \l_mhex_lectureshort { \l_mhex_lecture } }  { }




% ======================================================================================== %
% ========================= Maketitle and Related  ======================================= %
% ======================================================================================== %

\DeclareDocumentCommand\maketitle{}
  {
    \rule{\linewidth}{2pt}\\[2mm]
    \begin{minipage}{\dim_eval:n {\textwidth - 5.8cm}}
      \raggedright
      \textsf{
        \l_mhex_lecture
        \tl_if_empty:NTF
          \l_mhex_semester
          {}
          {\enspace \textbullet \enspace \l_mhex_semester}
      } \\
      \textsc{\textsf{
        \LARGE
        \bool_if:NTF
          \l_mhex_exammode
          {\l_mhex_examtext}
          {\l_mhex_exercisesheettext{}~\l_mhex_sheetno}
        \bool_if:NTF
          \l_mhex_solution
          { \large{}~\mbox{(\l_mhex_withsolutionstext)} }
          {  }
      }}\\
      \normalsize\textit{
        \bool_if:NTF
          \l_mhex_exammode
          {\l_mhex_date}
          {
            \tl_if_empty:NTF
              \l_mhex_date
              { 
                \tl_if_empty:NTF
                  \l_mhex_deadline
                  {}
                  {\l_mhex_deadlinetext{}~\l_mhex_deadline }
              }
              { \l_mhex_inclasstext }
              
          }
      }
    \end{minipage}
    
    \begin{minipage}{5.8cm}
      \begin{flushright}
        \unikoblenzlogo
      \end{flushright}
    \end{minipage}
    
    \\[2mm]
    \rule{\linewidth}{2pt}
    
    \begin{center}
      \small
      \bool_if:NTF
        \l_mhex_exammode
        {
          \textbf{
            \l_mhex_lecturer
             \tl_if_empty:NTF
               \l_mhex_operator
               { } {,~\l_mhex_operator}
          }   
        }
        {
          \tl_if_empty:NTF
            \l_mhex_lecturer
            { } {\textbf{\l_mhex_lecturetext :~}   \l_mhex_lecturer\\}
          \tl_if_empty:NTF
            \l_mhex_operator
            { } {\textbf{\l_mhex_exercisestext :~} \l_mhex_operator}
        }
    \end{center}
    \vspace{-2mm}
    \tl_if_empty:NTF
      \l_mhex_homepage
      {  }
      {\small \l_mhex_homepagetext}
  }

% ======================================================================================== %
% ==================== Page Layout: Header and Footer ==================================== %
% ======================================================================================== %


\pagestyle{fancy}
\fancyhead{}
\renewcommand\headrulewidth{0pt}
\renewcommand\footrulewidth{.4pt}
\cfoot{
  \bool_if:NTF
    \l_mhex_solution
    {\l_mhex_solutionsheettext}
    {\bool_if:NTF
      \l_mhex_exammode
      \l_mhex_examtext
      \l_mhex_exercisesheettext
    }
  {}~\l_mhex_sheetno
}
\rfoot{\l_mhex_pagetext{}~\thepage/\ztotpages}
\lfoot{\l_mhex_lectureshort}

\cs_new:Nn \l_mhex_typetitlebox:nn {
  \par
  \colorbox{black!20}{
    \parbox{\textwidth}{
      {\Large\textsc{#1}}
      \hfill
      {\small\textit{(#2)}}
    }
  }
  \bool_set_true:N \l_mhex_explicittype
}
\DeclareDocumentCommand
  \inclass {}
  { \l_mhex_typetitlebox:nn { \l_mhex_inclasstitletext  } {\l_mhex_inclasstext} }
  
\DeclareDocumentCommand
  \takehome {}
  { \l_mhex_typetitlebox:nn { \l_mhex_takehometitletext } {\l_mhex_takehometext}}
