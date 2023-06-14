(define-module (lisux packages lisp-xyz)
  #:use-module (gnu packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system asdf)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages m4)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages lisp-xyz)
  #:use-module (ice-9 match))

(define-public roswell
  (package
    (name "roswell")
    (version "21.10.14.111")
    (home-page "https://github.com/roswell/roswell/")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit (string-append "v" version))))
       (sha256
        (base32
         "1nymvaw8fd4p9rg2vm2951yb96b9k34mrc1qiq6s70rw6qsl711b"))))
    (build-system gnu-build-system)
    ;; FIXME
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (delete 'check))))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("zlib" ,zlib)
       ("libtool" ,libtool)
       ("automake" ,automake)
       ("intltool" ,intltool)))
    (inputs
     `(("curl" ,curl)))
    (synopsis "Common Lisp implementation manager, launcher, and more")
    (description
     "Roswell started out as a command-line tool with the aim to make
installing and managing Common Lisp implementations really simple and easy.
Roswell has now evolved into a full-stack environment for Common Lisp
development, and has many features that makes it easy to test, share, and
distribute your Lisp applications.

Roswell is still in beta. Despite this, the basic interfaces are stable and
not likely to change.")
    (license license:expat)))