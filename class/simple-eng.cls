\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{simple-eng}[2025/09/18 Simple class for summary notes]


% --- Options ---
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=summary,prefix=summary@}
\DeclareStringOption[section]{eqnumbering}
\DeclareStringOption[section]{thmnumbering}
\ProcessKeyvalOptions*


% --- These \DeclareOption lines mark eqnumbering/thmnumbering as
%     “handled here” so they will not be forwarded to the parent class
%     (article). This prevents unknown option warnings from article. -------------
\DeclareOption{eqnumbering=section}{}
\DeclareOption{eqnumbering=subsection}{}
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
\mathtoolsset{showonlyrefs=true}% 数式環境の中で，のちに参照するもののみ番号を振る設定
\newcounter{theorem}
\newtheoremstyle{mytheorem}
    {10pt}   % 上のスペース
    {10pt}   % 下のスペース
    {\itshape} % 本文フォント
    {}      % インデント
    {\bfseries} % タイトルフォント ← ここを変える
    {.}     % 見出し後の句読点
    { }     % 見出しと本文の間のスペース
    {}      % 見出しの仕様
\newtheoremstyle{mydefinition}
    {10pt}   % 上のスペース
    {15pt}   % 下のスペース
    {} % 本文フォント
    {}      % インデント
    {\bfseries} % タイトルフォント ← ここを変える
    {.}     % 見出し後の句読点
    { }     % 見出しと本文の間のスペース
    {}      % 見出しの仕様

\RequirePackage{xparse}% https://chatgpt.com/share/68ca31c6-1b1c-8005-bb51-5f78aa912d62
\AtEndOfClass{%
    \makeatletter
    % equation numbering
    \ifdefstring{\summary@eqnumbering}{section}{%
        \numberwithin{equation}{section}
        \renewcommand{\theequation}{\thesection.\arabic{equation}}
    }{%
        \numberwithin{equation}{subsection}
        \renewcommand{\theequation}{\thesubsection.\arabic{equation}}
    }%
    % definition/theorem numbering
    \ifdefstring{\summary@thmnumbering}{section}{%
        % if thmnumbering=section
        \@addtoreset{theorem}{section}
        \renewcommand{\thetheorem}{\thesection.\arabic{theorem}}
        % define theorem environments
        \theoremstyle{mydefinition}
        \newtheorem{innerdefinition}{Definition}[section]
    }{% if thmnumbering=subsection
        \@addtoreset{theorem}{section}
        \renewcommand{\thetheorem}{\thesection.\arabic{theorem}}
            % define theorem environments
            \theoremstyle{mydefinition}
            \newtheorem{innerdefinition}{Definition}[subsection]
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
    % proof environment
    \newcommand{\blacksquare}{■}
    \renewcommand{\qedsymbol}{\scalebox{.5}[1]{\textcolor{gray}{$\blacksquare$}}}
    \newtcolorbox{proofbox}{
        proofstyle,
        line color = gray,
        fonttitle = \bfseries,
        title = {Proof.},
        before upper={
            \hspace*{-14pt}\tcbtitle\;
        }
    }
    \newenvironment{myproof}{
        \begin{proofbox}
    }{
        \hspace{.5em}\qedsymbol\end{proofbox}
    }
}