#!/bin/bash
sed '/^Command line/d' WA_freeborni-2.tab > WA_freeborni-2-temp1.tab
sed '/^-- complete/d' WA_freeborni-2-temp1.tab >WA_freeborni-2-temp2.tab
sed '/^,/d' WA_freeborni-2-temp2.tab > WA_freeborni-2-temp3.tab
sed '/^Hostname/d' WA_freeborni-2-temp3.tab > WA_freeborni-2-temp4.tab
sed 's/^tr/>tr/g' WA_freeborni-2-temp4.tab > WA_freeborni-2-temp5.tab
sed 's/^sp/>sp/g' WA_freeborni-2-temp5.tab > WA_freeborni-2-temp6.tab
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < WA_freeborni-2-temp6.tab > WA_freeborni-2-temp7.tab
awk 'NR>1 && /^>/{printf "%s","\n"$0;next}{printf "%s",$0}END{print}' WA_freeborni-2-temp7.tab > WA_freeborni-2-exonerateOutputFixed.tab
awk -v FS="," -v OFS="," '($7>=1000)' WA_freeborni-2-exonerateOutputFixed.tab > WA_freeborni-2-exonerateOutputFixed-scoreFiltered.tab
rm *-temp*

exit;
