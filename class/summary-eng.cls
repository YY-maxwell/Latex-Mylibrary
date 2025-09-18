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
\RequirePackage{boxstyle/hruled, boxstyle/plain, boxstyle/simpleboxed, boxstyle/westruled}
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
            westruled,
            overlay = {
                \draw[black, line width=0.5pt]
                ([xshift=0mm,yshift=-7.6mm]interior.north west) -- ([xshift=0mm,yshift=1mm]interior.south west);
            },
            separator sign none,
            fonttitle = \bfseries,
            before upper = {%
                \hspace*{-1.5em}\tcbtitle\textbf{.}\;
            },
        }{def}
    }{% 
        % if thmnumbering=subsection
        \@addtoreset{theorem}{subsection}
        \renewcommand{\thetheorem}{\thesubsection.\arabic{theorem}}
        % define theorem environment
        \newtcbtheorem[number within=subsection]{definition}{Definition}{
            westruled,
            overlay = {
                \draw[black, line width=0.5pt]
                ([xshift=0mm,yshift=-7.8mm]interior.north west) -- ([xshift=0mm,yshift=1.68mm]interior.south west);
            },
            separator sign none,
            fonttitle = \bfseries,
            before upper = {%
                \hspace*{-1.5em}\tcbtitle\textbf{.}\;
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
        before skip=0mm,
        after skip=-0mm,
    }{thm}
    \newtcbtheorem[use counter from=definition]{lemma}{Lemma}{
        simpleboxed,
        separator sign none,
        fonttitle = \bfseries
    }{lem}
    \newtcbtheorem[use counter from=definition]{corollary}{Corollary}{
        simpleboxed,
        separator sign none,
        fonttitle = \bfseries
    }{cor}
    \newtcbtheorem[use counter from=definition]{proposition}{Proposition}{
        simpleboxed,
        separator sign none,
        fonttitle = \bfseries
    }{prop}
    \newtcbtheorem[use counter from=definition]{example}{Example}{
        plain,
        separator sign none,
        fonttitle = \bfseries,
        before upper={
            \hspace*{-1.5em}\tcbtitle\textbf{.}\;
        },
    }{ex}
    \newtcolorbox{remark}{
        plain,
        fonttitle = \bfseries,
        before upper={
            \hspace*{-1.5em}\tcbtitle\hspace{0.5em}
        },
        title = Remark.
    }
    \newtcolorbox{notation}{
        plain,
        fonttitle = \bfseries,
        before upper={
            \hspace*{-1.5em}\tcbtitle\hspace{0.5em}
        },
        title = Notation.
    }
    % proof environment
    \newcommand{\blacksquare}{■}
    \newcommand{\qedsymbol}{\scalebox{.5}[1]{\textcolor{black}{$\blacksquare$}}}
    \newtcolorbox{proofbox}{
        westruled,
        overlay = {
            \draw[gray, line width=0.5pt]
            ([xshift=0mm,yshift=-7.8mm]interior.north west) -- ([xshift=0mm,yshift=1.0mm]interior.south west);
        },
        fonttitle = \bfseries,
        before upper={
            \hspace*{-1.5em}\tcbtitle\hspace{0.5em}
        },
        title = Proof.
    }
    \newenvironment{myproof}{
        \begin{proofbox}
    }{
        \hspace{.5em}\qedsymbol\end{proofbox}
    }
}



