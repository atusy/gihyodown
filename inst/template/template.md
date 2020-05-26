<!--$if(author)$$author$$endif$
章タイトル：$if(title)$$title$$endif$
章の概要：$if(summary)$$summary$$endif$-->

$for(header-includes)$
$header-includes$

$endfor$
$for(include-before)$
$include-before$

$endfor$
$if(toc)$
$table-of-contents$

$endif$
$body$
$for(include-after)$

$include-after$
$endfor$
