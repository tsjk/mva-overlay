# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MIN_VERSION="2.8"
inherit cmake-utils

DESCRIPTION="Tool, separating data processing (business logic) from data presentation"
HOMEPAGE="http://ctpp.havoc.ru/ http://ctpp.havoc.ru/en/"
SRC_URI="http://ctpp.havoc.ru/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~x86 ~arm ~amd64"
IUSE="debug md5 iconv"

DEPEND="
	iconv? ( virtual/libiconv )
	md5? ( dev-libs/openssl:* )
"

RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/patches/*.patch"

src_configure() {
	mycmakeargs=(
		-DENABLE_OPTIMIZATION=ON
		-DSKIP_RELINK_RPATH=ON
		-DDEBUG_MODE=$(usex debug)
		-DMD5_SUPPORT=$(usex md5)
		-DICONV_SUPPORT=$(usex iconv)
		)

	cmake-utils_src_configure
}
