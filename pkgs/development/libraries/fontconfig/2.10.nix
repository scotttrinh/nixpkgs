{ stdenv, fetchurl, pkgconfig, freetype, expat
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "fontconfig-2.10.2";

  src = fetchurl {
    url = "http://fontconfig.org/release/${name}.tar.bz2";
    sha256 = "0llraqw86jmw4vzv7inskp3xxm2gc64my08iwq5mzncgfdbfza4f";
  };

  outputs = [ "bin" "dev" "lib" "out" ]; # $out contains all the config

  propagatedBuildInputs = [ freetype ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ expat ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-cache-dir=/var/cache/fontconfig"
    "--disable-docs"
    "--with-default-fonts="
  ];

  # We should find a better way to access the arch reliably.
  crossArch = if stdenv.hostPlatform != stdenv.buildPlatform
    then hostPlatform.parsed.cpu.name
    else null;

  preConfigure = ''
    if test -n "$crossConfig"; then
      configureFlags="$configureFlags --with-arch=$crossArch";
    fi
  '';

  enableParallelBuilding = true;

  doCheck = true;

  # Don't try to write to /var/cache/fontconfig at install time.
  installFlags = "sysconfdir=$(out)/etc fc_cachedir=$(TMPDIR)/dummy RUN_FC_CACHE_TEST=false";

  passthru = {
    # Empty for backward compatibility, there was no versioning before 2.11
    configVersion = "";
  };

  meta = with stdenv.lib; {
    description = "A library for font customization and configuration";
    homepage = http://fontconfig.org/;
    license = licenses.bsd2; # custom but very bsd-like
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
