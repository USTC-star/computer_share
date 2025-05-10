\NeedsTeXFormat{LaTeX2e}[2007/10/19]
\ProvidesClass{cpbtex3}[2014/11/12 v1.0 LaTeX Template for Chinese Physics B]

\LoadClass[a4paper]{article}[2007/10/19]

% 使用 xeCJK 设置中英文字体
\RequirePackage{xeCJK}
\setCJKmainfont{SimSun}                 % 中文：宋体
%\setmainfont{Times New Roman}           % 英文：Times New Roman
\setCJKsansfont{SimHei}                 % 中文无衬线字体：黑体（可选）
\setCJKmonofont{FangSong}               % 中文等宽字体：仿宋（可选）

% 其他原有宏包和设置保持不变
\RequirePackage{amsmath,amsfonts,amssymb,bm}
\RequirePackage{graphics,epstopdf,ifpdf}
\RequirePackage{mathrsfs,textcomp,multicol}
\RequirePackage{indentfirst,fancyhdr,upgreek}
\RequirePackage[columnwise]{lineno}
\RequirePackage[compress,nospace]{cite}
\RequirePackage[bookmarksnumbered=true,bookmarksopen=true,colorlinks=true,pdfborder=001,
            urlcolor=blue,linkcolor=blue,anchorcolor=blue,citecolor=blue]{hyperref}

% 其余原有设置（如页面布局、引用格式等）保持不变\newcommand{\ucite}[1]{$^{\text{\!\cite{#1}}}$} % reference citation
%================================== page setting =================================================%
\renewcommand{\baselinestretch}{1.5}    % set the line spacing
\renewcommand{\thesection}{\arabic{section}.\hspace{-.4cm}}
\renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}.\hspace{-.4cm}}
\renewcommand{\thesubsubsection}{\arabic{section}.\arabic{subsection}.\arabic{subsubsection}.\hspace{-.3cm}}
\footskip=45pt  \headsep=4truemm \topmargin=-0.5cm \oddsidemargin=0pt \evensidemargin=0pt
\textwidth=170truemm   % set page width
\textheight=250truemm  % set page height
\parindent=19pt        % set page indent
\def\thefootnote{}  %% remove the footnote number label
\endinput