\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{simple-ja}[2025/09/18 Simple class for summary notes]


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
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{jlreq}}
\ProcessOptions\relax
\LoadClass{jlreq}


% --- Load packages ---
\RequirePackage{etoolbox}% for eq/thm numbering
% user-defined
\RequirePackage{base-packages}
\RequirePackage{macros}
\RequirePackage{font-ja}
\RequirePackage{layout/page-margins,layout/head-foot}
\RequirePackage{toc/toc-ja}
\RequirePackage{boxstyle/hruled, boxstyle/plain, boxstyle/simpleboxed, boxstyle/westruled, boxstyle/proofstyle}
\RequirePackage{hyperlinks}

% ---------- 定理環境，数式・定理番号の設定 -----------------------------------------------------
\mathtoolsset{showonlyrefs=true}% 数式環境の中で，のちに参照するもののみ番号を振る設定
\newcounter{theorem}
\AtEndOfClass{%
    \makeatletter
    % 数式番号の設定
    \ifdefstring{\summary@eqnumbering}{section}{%
        \numberwithin{equation}{section}
        \renewcommand{\theequation}{\thesection.\arabic{equation}}
    }{%
        \numberwithin{equation}{subsection}
        \renewcommand{\theequation}{\thesubsection.\arabic{equation}}
    }%
    % 定理番号・定理環境の設定
    \ifdefstring{\summary@thmnumbering}{section}{%
        % if thmnumbering=section
        \@addtoreset{theorem}{section}
        \renewcommand{\thetheorem}{\thesection.\arabic{theorem}}
        % 定義環境
        \newtcbtheorem[number within=section]{definition}{定義}{
            plain,
            separator sign ={.},
            fonttitle = \gtfamily\sffamily,
            before upper = {%
                \hspace*{-14pt}\myunderline[0.6pt]{\tcbtitle.}\;
            },
        }{def} 
    }{% 
        % if thmnumbering=subsection
        \@addtoreset{theorem}{subsection}
        \renewcommand{\thetheorem}{\thesubsection.\arabic{theorem}}
        % 定義環境
        \newtcbtheorem[number within=subsection]{definition}{定義}{
            plain,
            separator sign = {.},
            fonttitle = \gtfamily\sffamily,
            before upper = {%
                \hspace*{-14pt}\myunderline[0.6pt]{\tcbtitle.}\;
            },
        }{def} 
    }
    \makeatother
    % 定理環境の設定（定義環境は上ですでに設定済み）
    \newtcbtheorem[use counter from=definition]{theorem}{定理}{
        plain,
        separator sign ={.},
        fonttitle = \sffamily\gtfamily,
        before upper = {%
            \hspace*{-14pt}\myunderline[0.6pt]{\tcbtitle.}\;
        },
    }{thm}

    \newtcbtheorem[use counter from=definition]{lemma}{補題}{
        plain,
        separator sign ={.},
        fonttitle = \sffamily\gtfamily,
        before upper = {%
            \hspace*{-14pt}\myunderline[0.6pt]{\tcbtitle.}\;
        }, 
    }{lem}
    \newtcbtheorem[use counter from=definition]{corollary}{系}{
        plain,
        separator sign ={.},
        fonttitle = \sffamily\gtfamily,
        before upper = {%
            \hspace*{-14pt}\myunderline[0.6pt]{\tcbtitle.}\;
        },
    }{cor}
    \newtcbtheorem[use counter from=definition]{proposition}{命題}{
        plain,
        separator sign ={.},
        fonttitle = \sffamily\gtfamily,
        before upper = {%
            \hspace*{-14pt}\myunderline[0.6pt]{\tcbtitle.}\;
        },
    }{prop}
    \newtcbtheorem[use counter from=definition]{example}{例}{
        plain,
        separator sign ={.},
        fonttitle = \sffamily\gtfamily,
        before upper={
            \hspace*{-14pt}\myunderline[0.6pt]{\tcbtitle.}\;
        },
    }{ex}
    \newtcolorbox{remark}{
        plain,
        fonttitle = \gtfamily\sffamily,
        before upper={
            \hspace*{-14pt}\myunderline[0.6pt]{\tcbtitle.}\;
        },
        title = 注意
    }
    \newtcolorbox{notation}{
        plain,
        fonttitle = \sffamily\gtfamily,
        before upper={
            \hspace*{-14pt}\myunderline[0.6pt]{\tcbtitle.}\;
        },
        title = 記法
    }
    % 証明環境
    \newenvironment{myproof}{
        \begin{proofbox}[\textgt{\textsf{証明.}}]
    }{
        \qedsymbol\end{proofbox}
    }
}