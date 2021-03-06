# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib git-r3

DESCRIPTION="Fast Artificial Neural Network Library"
HOMEPAGE="http://leenissen.dk/fann/"
EGIT_REPO_URI="https://github.com/libfann/fann"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="examples"

src_test() {
	cd examples || die 'fails to enter examples directory'
	LD_LIBRARY_PATH="${BUILD_DIR}/src" GCC="$(tc-getCC) ${CFLAGS} -I../src/include -L${BUILD_DIR}/src" emake -e runtest
	emake clean
}

src_install() {
	cmake-multilib_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
