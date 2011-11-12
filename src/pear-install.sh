#!/bin/bash

##
## Installs the PEAR packages I use.
##
## See: http://pear.php.net/
##

pear channel-discover pear.phing.info
pear channel-discover pear.phpunit.de
pear channel-discover components.ez.no
pear channel-discover pear.symfony-project.com
pear channel-discover pear.php-tools.net
pear channel-discover pear.pdepend.org
pear channel-discover pear.phpmd.org

pear install --alldeps \
	PHP_CodeSniffer \
	PhpDocumentor \
	phing/phing	\
	pat/vfsStream-beta \
	pdepend/PHP_Depend-beta \
	phpmd/PHP_PMD \
	phpunit/PHPUnit \
