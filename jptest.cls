% Identification
% ============================================================
\NeedsTeXFormat{LaTeX2e}[1996/06/01]
\ProvidesClass{jptest}[2016/02/25 Multiple choice tests]


% Preliminary declarations
% ============================================================

% Options
% ============================================================
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{article}%
}
\ProcessOptions\relax
\LoadClass{article}


\RequirePackage[T1]{fontenc}

% Babel: handle the problematic options of spanish
\def\spanishoptions{es-noindentfirs,es-noitemize}
\RequirePackage[spanish]{babel}
\addto\shorthandsspanish{\spanishdeactivate{"<>}}

% Format dates
\RequirePackage[useregional=num]{datetime2}
%\DTMsetstyle{dmyyyy}

\RequirePackage[normalem]{ulem}
\RequirePackage[full]{textcomp}
\RequirePackage{latexsym}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\mathtoolsset{mathic}


% Fonts
% ------------------------------------------------------------
% Main font: kp 
% Sans serif: Classico

\RequirePackage{kpfonts}   
\RequirePackage{classico}           


\RequirePackage[twoside, hscale=0.72, vscale=0.75, 
bindingoffset=0in, hcentering=true]{geometry}          

% Activate microtypography
\RequirePackage{microtype}         

\RequirePackage{fancyhdr}
\setlength{\headheight}{15.2pt}
\pagestyle{fancy}
\lhead{\textsc{\@subject}}
\chead{\textsc{\@testname}}
\rhead{\@testdate}

\fancypagestyle{first}{ %
  \fancyhf{} % remove everything
  \lhead{\textsc{\@subject}}
  \chead{\textsc{\@testname}}
  \rhead{\@testdate}
}


% Lists
% ------------------------------------------------------------
\RequirePackage{tikz}
\DeclareRobustCommand*\circled[1]{\tikz[baseline=(char.base)]{%
    \node[shape=circle,draw, thick, inner sep=0.85pt] (char) {\makebox[0in][c]{\phantom{d}}#1};}}

\RequirePackage{enumitem}
\setlist{leftmargin=*}
\setlist[enumerate, 2]{beginpenalty=10000,
  midpenalty=10000,font=\scriptsize\bfseries, label=\circled{\Alph*}}


% Tools for writing macros
% ------------------------------------------------------------
\RequirePackage{ifthen}
\RequirePackage{forloop}
\RequirePackage{etoolbox}
\RequirePackage{array}
\newcolumntype{P}[1]{>{\centering\arraybackslash}p{#1}}

% More declarations
% ============================================================
\newcommand*{\ClearDoublePage}{\clearpage{\pagestyle{empty}\cleardoublepage}}

\newcommand*{\subject}[1]{\renewcommand\@subject{#1}}
\newcommand*{\@subject}{\PackageError{jptest}{%
    No \protect\subject\space given}{%
    Oh dear! Something's gone wrong.\MessageBreak
    \space \space Try typing \space <return>
    \space to proceed, ignoring \protect\foo.
  }
}

\newcommand*{\testdate}[1]{\renewcommand\@testdate{\DTMdate{#1}}}
\newcommand*{\@testdate}{\today}

\newcommand*{\testname}[1]{\renewcommand\@testname{#1}}
\newcommand*{\@testname}{}

\newcommand*{\qnumber}[1]{\renewcommand\@qnumber{#1}}
\newcommand*{\@qnumber}{10}



% Table for self grading. 
\newcounter{the@qnum}
\newcommand{\@gradetable}[1]{%
  \renewcommand*{\arraystretch}{1.5}
  \begin{tabular}{|P{1cm}|p{1cm}|}
    \hline
    \forloop{the@qnum}{1}{\value{the@qnum} < #1}{%
      \arabic{the@qnum}. & \\ \hline}
    \arabic{the@qnum}. & \\\hline
  \end{tabular}
}

% Code to be executed after inputenc
\AtEndPreamble{%
  %% Non-breakable space (Emacs: C-x 8 SPC) 
  \ifthenelse{\isundefined{\DeclareUnicodeCharacter}}{}{%
    \DeclareUnicodeCharacter{00A0}{~}}
  %% Load csquotes
  \RequirePackage{csquotes}
}


\AtBeginDocument{%
  \begingroup
  \thispagestyle{empty}
  \sffamily
  \begin{center}
    \scshape\LARGE \@subject \\
    \@testname \\
    \@testdate
    \vspace*{\baselineskip}
  \end{center}
  \begin{center}
    %\sffamily%
    \LARGE\bfseries\scshape%
    No d\'{e} la vuelta a esta hoja hasta que se le indique    
    \vspace*{2\baselineskip}
  \end{center}
  \begin{center}
    \large%
    \begin{minipage}{0.50\linewidth}
      \centering%
      \begin{itemize}
      \item No entregue esta hoja al finalizar el test.
      \item Aqu\'{\i} puede anotar sus respuestas: 
      \end{itemize}
      \vspace*{\baselineskip}
      
      \@gradetable{\@qnumber}
    \end{minipage}
  \end{center}
  \ClearDoublePage
  \endgroup
}


\AtBeginDocument{%
  \pagenumbering{arabic}%
  \thispagestyle{first}%
  \noindent%
%  \noindent\makebox[\textwidth]{
    \begin{minipage}{\textwidth}
      \begin{flushleft}
        \large%
        Apellido(s): \\[\baselineskip]
        Nombre: \\[\baselineskip]
        DNI/NIE: \hspace{\stretch{1}} Grupo: \hspace*{2cm}\linebreak[0]\\[0.75\baselineskip]
        \rule{\linewidth}{0.4pt}
      \end{flushleft}
      \vspace*{2ex}
    \end{minipage}
%  }
}


\AtEndDocument{\ClearDoublePage}
