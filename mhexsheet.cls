% !TeX encoding = UTF-8
\NeedsTeXFormat{LaTeX2e}[2011/06/27]
\RequirePackage{expl3,l3keys,l3keys2e,l3skip,l3tl}
\RequirePackage{l3seq}[2013/05/26] % \seq_use:Nn introduced in this version
\ProvidesExplClass{mhexsheet}{2013/10/10}{3}{Neatly designed exercise sheets with tons of options.}

% ======================================================================================== %
% ============ Set Class Options for Language Setup and Load scrartcl ==================== %
% ======================================================================================== %
\keys_define:nn { mhexsheet } {
  german             .code:n = {\tl_set:Nn \lmhexlang {german}},
  english            .code:n = {\tl_set:Nn \lmhexlang {english}},
}
\LoadClass[a4paper,11pt,parskip=half-]{scrartcl}


% ======================================================================================== %
% ======== Basic Setup: Language (babel/polyglossia), Encoding, and Fonts ================ %
% ======================================================================================== %

\tl_set:Nn \l_mhex_babel { ngerman }
\RequirePackage{amsmath,amsfonts,amssymb}
\ProcessKeysOptions{mhexsheet}
\pdftex_if_engine:TF
  {
    \RequirePackage[utf8]{inputenc}
    \RequirePackage[T1]{fontenc}
    \RequirePackage{libertine}
    \RequirePackage{zi4}
    \RequirePackage{euler}
    \str_if_eq:VnTF
      \lmhexlang
      {english}
      {\RequirePackage[english]{babel}}
      {\RequirePackage[ngerman]{babel}}
  }
  {
    \RequirePackage{fontspec}
    \defaultfontfeatures{Ligatures=TeX}
    \setmainfont{Linux~Libertine~O}
    \setsansfont{Linux~Biolinum~O}
    \setmonofont[Scale=MatchLowercase]{Inconsolata}
    \RequirePackage[math-style=upright]{unicode-math}
    \setmathfont{Neo~Euler}
    % these fonts are just nicer from the XITS set::
    \setmathfont[range={\mathcal,\mathbfcal,\mathbb},StylisticSet=1]{XITS~Math}
    \RequirePackage{polyglossia}
    % there seems to be a bug somewhere making this Expl.. stuff necessary
    \ExplSyntaxOff\setmainlanguage{\lmhexlang}\ExplSyntaxOn
  }
\RequirePackage{csquotes}
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
\RequirePackage[scale=.8]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{zref-totpages}


% ======================================================================================== %
% ========================= Extend mhex l3keys definitions =============================== %
% ======================================================================================== %

\keys_define:nn { mhex } {
  lecture      .tl_set:N    = \l_mhex_lecture,
  lectureshort .tl_set:N    = \l_mhex_lectureshort,
  semester     .tl_set:N    = \l_mhex_semester,
  deadline     .tl_set:N    = \l_mhex_deadline,
  lecturer     .clist_set:N = \l_mhex_lecturer,
  operator     .clist_set:N = \l_mhex_operator,
  homepage     .tl_set:N    = \l_mhex_homepage,
  date         .tl_set:N    = \l_mhex_date,
  title        .code:n      = \AtBeginDocument{\tl_set:Nn \l_mhex_examtext {#1}},
  logo         .code:n      = {\cs_set:Nn \l_mhex_logo: {#1}
                              \bool_set_true:N \l_mhex_customlogo},
  logowidth    .dim_set:N = \l_mhex_logowidth,
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
  logo         = \unikoblenzlogo,
  logowidth    = 161pt,
}
\bool_set_false:N \l_mhex_customlogo
\tl_if_empty:NTF
  \l_mhex_lectureshort
  {\tl_set:Nn \l_mhex_lectureshort { \l_mhex_lecture } }  { }

\AtBeginDocument{
  \bool_if:NTF
    \l_mhex_customlogo
    {}
    {\RequirePackage{unikoblenzlogo}}
}


% ======================================================================================== %
% ==================================== Maketitle ========================================= %
% ======================================================================================== %

\DeclareDocumentCommand\maketitle{}
  {
    \rule{\linewidth}{2pt}\\[4pt]
    \begin{minipage}{\dim_eval:n {\textwidth - \l_mhex_logowidth}}
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
    
    \begin{minipage}{\l_mhex_logowidth}
      \begin{flushright}
        \l_mhex_logo:
      \end{flushright}
    \end{minipage}\\[3pt]
    \rule{\linewidth}{2pt}\\[2pt]
    
    \bool_new:N \l_mhex_subtitle
    \seq_new:N \l_mhex_people
    \bool_if:NTF
      \l_mhex_exammode
      {
        \clist_concat:NNN \l_mhex_cpeople \l_mhex_lecturer \l_mhex_operator
        \clist_map_inline:Nn \l_mhex_cpeople {\seq_put_right:Nn \l_mhex_people {##1}}
        \seq_if_empty:NTF \l_mhex_people
          {}
          {{\centering
            \small
            \textbf{\seq_use:Nn \l_mhex_people {\enspace\textbullet\enspace}}
            \\[-1pt]
           }
           \bool_set_true:N \l_mhex_subtitle
          }
      }
      {
        \tl_if_empty:NTF
          \l_mhex_lecturer
          {}{\seq_put_right:Nn
            \l_mhex_people
            {\textbf{\l_mhex_lecturetext :\enspace}
             \clist_use:Nn \l_mhex_lecturer {\nobreakspace\textbullet\nobreakspace}}
            }
        \tl_if_empty:NTF
          \l_mhex_operator
          {}{\seq_put_right:Nn
            \l_mhex_people
            {\textbf{\l_mhex_exercisestext :\enspace}
             \clist_use:Nn\l_mhex_operator{\nobreakspace\textbullet\nobreakspace}}
            }
        \seq_if_empty:NTF \l_mhex_people
          {}
          {{\centering
            \small
            \seq_use:Nn \l_mhex_people {\\}
            \\[-1pt]
           }
           \bool_set_true:N \l_mhex_subtitle
          }
       }
    \tl_if_empty:NTF
      \l_mhex_homepage
      {}
      {
        \bool_set_true:N \l_mhex_subtitle
        {\small \l_mhex_homepagetext}\\[-3pt]
      }
    \bool_if:NTF
      \l_mhex_subtitle
      {\rule{\linewidth}{1pt}\\[-5pt]}{\vspace{-2mm}}
    \par
  }
  
  
%========= the inclass / takehome commands =============================================== %
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
% ======================================================================================== %


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
% ======================================================================================== %
