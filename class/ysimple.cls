\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ysimple}[2025/09/18 Simple class for summary notes]


% --- Options ---
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=summary,prefix=summary@}
\DeclareStringOption[global]{eqnumbering}
\DeclareStringOption[global]{thmnumbering}
\ProcessKeyvalOptions*


% --- These \DeclareOption lines mark eqnumbering/thmnumbering as
%     “handled here” so they will not be forwarded to the parent class
%     (article). This prevents unknown option warnings from article. -------------
\DeclareOption{eqnumbering=global}{}
\DeclareOption{eqnumbering=section}{}
\DeclareOption{eqnumbering=subsection}{}
\DeclareOption{thmnumbering=global}{}
\DeclareOption{thmnumbering=section}{}
\DeclareOption{thmnumbering=subsection}{}


% --- Parent Class ---
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}


% --- Load packages ---
\RequirePackage{etoolbox}% for eq/thm numbering
% user-defined
\RequirePackage{base-packages}
\RequirePackage{macros}
\RequirePackage{layout/page-margins,layout/head-foot}
\RequirePackage{toc/toc-eng}
\RequirePackage{boxstyle/hruled, boxstyle/plain, boxstyle/simpleboxed, boxstyle/westruled, boxstyle/proofstyle}
\RequirePackage{hyperlinks}
\RequirePackage{amsthm}


% --- numbering systems for equation and theorem ---
\mathtoolsset{showonlyrefs=true}% Number only equations that are actually referenced later
%\newcounter{theorem}
\newtheoremstyle{mytheorem}
    {10pt}   % space above
    {10pt}   % space below
    {\itshape} % body font
    {}      % indent amount
    {\bfseries} % title font
    {.}     % Punctuation after theorem head
    { }     % Space after theorem head
    {}      % Theorem head specification
\newtheoremstyle{mydefinition}
    {10pt}      % Space above
    {15pt}      % Space below
    {}          % Body font
    {}          % Indent amount
    {\bfseries} % Theorem head font ← you can modify this
    {.}         % Punctuation after theorem head
    { }         % Space after theorem head
    {}          % Theorem head specification

\RequirePackage{xparse}% https://chatgpt.com/share/68ca31c6-1b1c-8005-bb51-5f78aa912d62
\AtEndOfClass{%
    \makeatletter
    % equation numbering
    \ifdefstring{\summary@eqnumbering}{section}{%
        \numberwithin{equation}{section}
        \renewcommand{\theequation}{\thesection.\arabic{equation}}
    }{%
    \ifdefstring{\summary@eqnumbering}{subsection}{
        \numberwithin{equation}{subsection}
        \renewcommand{\theequation}{\thesubsection.\arabic{equation}}
    }{% else: default is like (1)...
        \@ifundefined{c@equation}{\newcounter{equation}}{}%
        \renewcommand{\theequation}{\arabic{equation}}
    }
    }%
    % definition/theorem numbering
    \ifdefstring{\summary@thmnumbering}{section}{% if thmnumbering=section
        % define theorem environments
            \theoremstyle{mydefinition}
            \newtheorem{innerdefinition}{Definition}[section]
    }{%
    \ifdefstring{\summary@thmnumbering}{subsection}{% if thmnumbering=subsection
        % define theorem environments
            \theoremstyle{mydefinition}
            \newtheorem{innerdefinition}{Definition}[subsection]
    }{% else: default is like "Definition 1"
        \theoremstyle{mydefinition}
        \newtheorem{innerdefinition}{Definition}
    }
    }
    \theoremstyle{mytheorem}
    \newtheorem{innertheorem}[innerdefinition]{Theorem}
    \newtheorem{innerproposition}[innerdefinition]{Proposition}
    \newtheorem{innerlemma}[innerdefinition]{Lemma}
    \newtheorem{innercorollary}[innerdefinition]{Corollary}
    \theoremstyle{mydefinition}
    \newtheorem{innerexample}[innerdefinition]{Example}

    \NewDocumentEnvironment{definition}{mm}{%
        \begin{innerdefinition}[#1]%
        \ifstrempty{#2}{\label{def:\theinnerdefinition}}{\label{def:#2}}%
    }{%
        \end{innerdefinition}%
    }
    \NewDocumentEnvironment{theorem}{mm}{%
        \begin{innertheorem}[#1]%
        \ifstrempty{#2}{\label{thm:\theinnerdefinition}}{\label{thm:#2}}%
    }{%
        \end{innertheorem}%
    }
    \NewDocumentEnvironment{proposition}{mm}{%
        \begin{innerproposition}[#1]%
        \ifstrempty{#2}{\label{prop:\theinnerdefinition}}{\label{prop:#2}}%
    }{%
        \end{innerproposition}%
    }
    \NewDocumentEnvironment{lemma}{mm}{%
        \begin{innerlemma}[#1]%
        \ifstrempty{#2}{\label{lem:\theinnerdefinition}}{\label{lem:#2}}%
    }{%
        \end{innerlemma}%
    }
    \NewDocumentEnvironment{corollary}{mm}{%
        \begin{innercorollary}[#1]%
        \ifstrempty{#2}{\label{cor:\theinnerdefinition}}{\label{cor:#2}}%
    }{%
        \end{innercorollary}%
    }
    \NewDocumentEnvironment{example}{mm}{%
        \begin{innerexample}[#1]%
        \ifstrempty{#2}{\label{ex:\theinnerdefinition}}{\label{ex:#2}}%
    }{%
        \end{innerexample}%
    }
    \makeatother
    \theoremstyle{mydefinition}
    \newtheorem*{definition*}{Definition}
    \newtheorem*{remark}{Remark}
    \newtheorem*{notation}{Notation}
    \theoremstyle{mytheorem}
    \newtheorem*{proposition*}{Proposition}
    \newtheorem*{theorem*}{Theorem}
    \newtheorem*{corollary*}{Corollary}
    \newtheorem*{lemma*}{Lemma}

% --- proof environment --- %
\renewcommand{\qedsymbol}{\scalebox{.5}[1]{\textcolor{gray}{$\blacksquare$}}}% qedsymble command is already defined in amsthm
    \newenvironment{myproof}{
        \vspace{-5pt}%
        \begin{proofbox}
    }{
        \qedsymbol\end{proofbox}
    }
}