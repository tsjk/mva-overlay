# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit scons-utils toolchain-funcs multilib git-r3

MY_P="swift-${PV}"

DESCRIPTION="Library for implementing XMPP applications."
HOMEPAGE="http://swift.im/"
SRC_URI=""
EGIT_REPO_URI="git://swift.im/swift"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="avahi expat gconf icu test upnp"

RDEPEND="
	dev-libs/boost:=
	dev-libs/openssl:0
	net-dns/libidn
	sys-libs/zlib
	avahi? ( net-dns/avahi )
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2 )
	gconf? ( gnome-base/gconf dev-libs/glib:2 )
	icu? ( dev-libs/icu:= )
	upnp? ( net-libs/libnatpmp net-libs/miniupnpc:= )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# remove all bundled packages to ensure
	# consistency of headers and linked libraries
	rm -rf 3rdparty || die

	epatch "${FILESDIR}"/swiften-libdir.patch

	eapply_user
}

src_configure() {
	MYSCONS=(
		cc="$(tc-getCC)"
		cxx="$(tc-getCXX)"
		ccflags="${CFLAGS}"
		cxxflags="${CXXFLAGS}"
		link="$(tc-getCXX)"
		linkflags="${LDFLAGS}"
		ar="$(tc-getAR)"
		swiften_dll=true
		zlib_includedir=/usr/include
		zlib_libdir=/$(get_libdir)
		{boost,libidn,zlib}_bundled_enable=false
		icu=$(usex icu true false)
		try_avahi=$(usex avahi true false)
		try_gconf=$(usex gconf true false)
		try_expat=$(usex expat true false)
		try_libxml=$(usex expat false true)
		experimental_ft=$(usex upnp true false)
	)
}

src_compile() {
	escons V=1 "${MYSCONS[@]}" Swiften
}

src_install() {
	escons "${MYSCONS[@]}" SWIFTEN_INSTALLDIR="${D}/usr" "${D}/usr"
}
