\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jynormal}[2026/05/13 日本語survay用のクラス]

% --- オプション --- %
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=summary,prefix=summary@}
\DeclareStringOption[global]{eqnumbering}
\DeclareStringOption[global]{thmnumbering}
\ProcessKeyvalOptions*

% --- These \DeclareOption lines mark eqnumbering/thmnumbering as
%     “handled here” so they will not be forwarded to the parent class
%     (jlreq). This prevents unknown option warnings from jlreq. -------------
\DeclareOption{eqnumbering=global}{}
\DeclareOption{eqnumbering=section}{}
\DeclareOption{eqnumbering=subsection}{}
\DeclareOption{thmnumbering=global}{}
\DeclareOption{thmnumbering=section}{}
\DeclareOption{thmnumbering=subsection}{}

% --- 親クラス --- %
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{jlreq}}
\ProcessOptions\relax
\LoadClass{jlreq}

% --- パッケージ --- %
\RequirePackage{etoolbox}% for eq/thm numbering
\RequirePackage{amsthm}% theorem/proof environments
% user-defined
\RequirePackage{base-packages}
\RequirePackage{macros}
\RequirePackage{font-ja}
\RequirePackage{layout/page-margins,layout/head-foot}
\RequirePackage{toc/toc-ja}
\RequirePackage{boxstyle/proofstyle}
\RequirePackage{hyperlinks}

% --- 定理環境，数式・定理番号の設定 --- %
\mathtoolsset{showonlyrefs=true}% 数式環境の中で，のちに参照するもののみ番号を振る設定
\newtheoremstyle{mytheorem}% クラスのオプション引数によらない定義環境
    {15pt}   % space above
    {15pt}   % space below
    {} % body font
    {}      % indent amount
    {\bfseries} % title font
    {.}     % Punctuation after theorem head
    { }     % Space after theorem head
    {}      % Theorem head specification
\newtheoremstyle{mydefinition}
    {15pt}      % space above
    {15pt}      % space below
    {}          % body font
    {}          % indent amount
    {\bfseries} % theorem head font ← you can modify this
    {.}         % punctuation after theorem head
    { }         % space after theorem head
    {}          % theorem head specification


\RequirePackage{xparse}% https://chatgpt.com/share/68ca31c6-1b1c-8005-bb51-5f78aa912d62
\AtEndOfClass{%
    \makeatletter%

% --- 数式番号の設定 --- %
    \ifdefstring{\summary@eqnumbering}{section}{
        \numberwithin{equation}{section}
        \renewcommand{\theequation}{\thesection.\arabic{equation}}
    }{
    \ifdefstring{\summary@eqnumbering}{subsection}{
        \numberwithin{equation}{subsection}
        \renewcommand{\theequation}{\thesubsection.\arabic{equation}}
    }{
        \@ifundefined{c@equation}{\newcounter{equation}}{}
        \renewcommand{\theequation}{\arabic{equation}}
    }
    }

% --- 定義・定理番号と環境の設定 --- %
    \ifdefstring{\summary@thmnumbering}{section}{% if thmnumbering=section → 定義 1.1.
            \theoremstyle{mydefinition}
            \newtheorem{innerdefinition}{定義}[section]
    }{%
    \ifdefstring{\summary@thmnumbering}{subsection}{% if thmnumbering=subsection → 定義 1.1.1.
            \theoremstyle{mydefinition}
            \newtheorem{innerdefinition}{定義}[subsection]
    }{% else: default is like 定義 1.
        \theoremstyle{mydefinition}
        \newtheorem{innerdefinition}{定義}
    }
    }
    \theoremstyle{mytheorem}
    \newtheorem{innertheorem}[innerdefinition]{定理}
    \newtheorem{innerproposition}[innerdefinition]{命題}
    \newtheorem{innerlemma}[innerdefinition]{補題}
    \newtheorem{innercorollary}[innerdefinition]{系}
    \theoremstyle{mydefinition}
    \newtheorem{innerexample}[innerdefinition]{例}

    \NewDocumentEnvironment{definition}{mm}{
        \begin{innerdefinition}[#1]
        \ifstrempty{#2}{\label{def:\theinnerdefinition}}{\label{def:#2}}
    }{
        \end{innerdefinition}
    }
    \NewDocumentEnvironment{theorem}{mm}{
        \begin{innertheorem}[#1]
        \ifstrempty{#2}{\label{thm:\theinnerdefinition}}{\label{thm:#2}}
    }{
        \end{innertheorem}
    }
    \NewDocumentEnvironment{proposition}{mm}{
        \begin{innerproposition}[#1]
        \ifstrempty{#2}{\label{prop:\theinnerdefinition}}{\label{prop:#2}}
    }{
        \end{innerproposition}
    }
    \NewDocumentEnvironment{lemma}{mm}{
        \begin{innerlemma}[#1]
        \ifstrempty{#2}{\label{lem:\theinnerdefinition}}{\label{lem:#2}}
    }{
        \end{innerlemma}
    }
    \NewDocumentEnvironment{corollary}{mm}{
        \begin{innercorollary}[#1]
        \ifstrempty{#2}{\label{cor:\theinnerdefinition}}{\label{cor:#2}}
    }{
        \end{innercorollary}
    }
    \NewDocumentEnvironment{example}{mm}{
        \begin{innerexample}[#1]
        \ifstrempty{#2}{\label{ex:\theinnerdefinition}}{\label{ex:#2}}
    }{
        \end{innerexample}
    }
    \makeatother
    \theoremstyle{mydefinition}
    \newtheorem*{definition*}{定義}
    \newtheorem*{remark}{注意}
    \newtheorem*{notation}{記法}
    \theoremstyle{mytheorem}
    \newtheorem*{proposition*}{命題}
    \newtheorem*{theorem*}{定理}
    \newtheorem*{corollary*}{系}
    \newtheorem*{lemma*}{補題}

% --- 証明環境 --- %
\renewcommand{\qedsymbol}{\scalebox{.5}[1]{\textcolor{gray}{$\blacksquare$}}}% amsthmによって，すでにqedsymbolが定義されてしまっているのでrenewcommand
    \newenvironment{myproof}{
        \vspace{-10pt}%
        \begin{proofbox}[証明.]
    }{
        \qedsymbol\end{proofbox}
    }
}