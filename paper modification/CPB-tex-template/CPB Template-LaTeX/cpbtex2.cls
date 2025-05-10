\NeedsTeXFormat{LaTeX2e}[2007/10/19]
\ProvidesClass{cpbtex}[2014/11/12 v1.0 LaTeX Template for Chinese Physics B]

\LoadClass[a4paper]{article}[2007/10/19]

% 修改1：移除旧的CJK包，改用xeCJK
\RequirePackage{amsmath,amsfonts,amssymb,bm}
\RequirePackage{graphics,epstopdf,ifpdf}
\RequirePackage{mathrsfs,textcomp,multicol}
\RequirePackage{indentfirst,fancyhdr,upgreek}
\RequirePackage[columnwise]{lineno}
\RequirePackage[compress,nospace]{cite}
\RequirePackage{CJKutf8}
% 修改2：添加xeCJK和字体设置
\RequirePackage{xeCJK}
\setCJKmainfont{SimSun}[AutoFakeBold=true] % 设置中文字体为宋体
\setmainfont{Times New Roman} % 设置英文字体

% 修改3：更新hyperref设置（保持原样）
\RequirePackage[bookmarksnumbered=true,bookmarksopen=true,colorlinks=true,pdfborder=001,
            urlcolor=blue,linkcolor=blue,anchorcolor=blue,citecolor=blue]{hyperref}
            
\newcommand{\ucite}[1]{$^{\text{\!\cite{#1}}}$}

% 保持原有页面设置不变
\renewcommand{\baselinestretch}{1.5}
\renewcommand{\thesection}{\arabic{section}.\hspace{-.4cm}}
\renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}.\hspace{-.4cm}}
\renewcommand{\thesubsubsection}{\arabic{section}.\arabic{subsection}.\arabic{subsubsection}.\hspace{-.3cm}}
\footskip=45pt  \headsep=4truemm \topmargin=-0.5cm \oddsidemargin=0pt \evensidemargin=0pt
\textwidth=170truemm
\textheight=250truemm
\parindent=19pt
\def\thefootnote{}

\endinput