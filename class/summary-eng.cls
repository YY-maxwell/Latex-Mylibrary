\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{summary-eng}[2025/09/18 for summary notes]


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

% --- numbering systems for equation and theorem ---------------------------------
\mathtoolsset{showonlyrefs=true}% 数式環境の中で，のちに参照するもののみ番号を振る設定
\newcounter{theorem}
\AtEndOfClass{%
    \makeatletter
    % ----- equation numbering ---------------------------------------
    \ifdefstring{\summary@eqnumbering}{section}{%
        \numberwithin{equation}{section}
        \renewcommand{\theequation}{\thesection.\arabic{equation}}
    }{%
        \numberwithin{equation}{subsection}
        \renewcommand{\theequation}{\thesubsection.\arabic{equation}}
    }%
    % ----------------------------------------------------------------

    % ----- theorem numbering ----------------------------------------
    \ifdefstring{\summary@thmnumbering}{section}{%
        % if thmnumbering=section
        \@addtoreset{theorem}{section}
        \renewcommand{\thetheorem}{\thesection.\arabic{theorem}}
        % define theorem environments
        \newtcbtheorem[number within=section]{definition}{Definition}{
            proofstyle,
            line color = black,
            separator sign none,
            fonttitle = \bfseries,
            before upper = {%
                \hspace*{-14pt}\tcbtitle\textbf{.}\;
            },
        }{def}
    }{% 
        % if thmnumbering=subsection
        \@addtoreset{theorem}{subsection}
        \renewcommand{\thetheorem}{\thesubsection.\arabic{theorem}}
        % define theorem environment
        \newtcbtheorem[number within=subsection]{definition}{Definition}{
            proofstyle,
            line color = black,
            separator sign none,
            fonttitle = \bfseries,
            before upper = {%
                \hspace*{-14pt}\tcbtitle\textbf{.}\;
            },
        }{def}
    }%
    % ----------------------------------------------------------------
    \makeatother

    % define theorem environments (only definition environment is defined above)
    \newtcbtheorem[use counter from=definition]{theorem}{Theorem}{
        simpleboxed,
        separator sign none,
        fonttitle = \bfseries,
        fontupper = \itshape,
        before skip=0mm,
        after skip=-0mm,
    }{thm}
    \newtcbtheorem[use counter from=definition]{lemma}{Lemma}{
        simpleboxed,
        separator sign none,
        fonttitle = \bfseries,
        fontupper = \itshape
    }{lem}
    \newtcbtheorem[use counter from=definition]{corollary}{Corollary}{
        simpleboxed,
        separator sign none,
        fonttitle = \bfseries,
        fontupper = \itshape
    }{cor}
    \newtcbtheorem[use counter from=definition]{proposition}{Proposition}{
        simpleboxed,
        separator sign none,
        fonttitle = \bfseries,
        fontupper = \itshape
    }{prop}
    \newtcbtheorem[use counter from=definition]{example}{Example}{
        plain,
        separator sign none,
        fonttitle = \bfseries,
        before upper = {
            \hspace*{-14pt}\tcbtitle\textbf{.}\;
        },
    }{ex}
    \newtcolorbox{remark}{
        plain,
        fonttitle = \bfseries,
        before upper = {
            \hspace*{-14pt}\tcbtitle\;
        },
        title = Remark.
    }
    \newtcolorbox{notation}{
        plain,
        fonttitle = \bfseries,
        before upper = {
            \hspace*{-14pt}\tcbtitle\;
        },
        title = Notation.
    }
    % proof environment
    \newenvironment{myproof}{
        \begin{proofbox}
    }{
        \qedsymbol\end{proofbox}
    }
}



