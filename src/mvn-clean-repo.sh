#!/bin/bash

#
# http://www.yeap.de/blog2.0/archives/246-Maven-Housekeeping-Cleanup-your-local-repository-on-Linux.html
#

M2_REPO="${HOME}/.m2"
OLDFILES="/tmp/mvn-clean-repo-${RANDOM}"
AGE=31

for extension in *jar *swf *swc; do
  find "${M2_REPO}" \
    -name "${extension}" \
    -atime +${AGE} \
    -exec dirname {} \; >> ${OLDFILES}
done

for file in `cat ${OLDFILES}`; do
  rm -rfv "${file}";
done

rm "${OLDFILES}"
