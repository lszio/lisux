;; -*- model: sceme; -*-

(use-modules (gnu)
             (gnu artwork)
             (gnu system nss))

(use-service-modules admin avahi networking ssh)
(use-package-modules certs linux raspberry-pi ssh)

(define-public rpi
  (operating-system
    (host-name "rpi")
    (timezone "Asia/Shanghai")
    (bootloader (bootloader-configuration
                  (bootloader grub-efi-bootloader-chain-raspi-64)
                  (targets (list "/boot/efi"))
                  (theme (grub-theme 
                           (resolution '(1920 1080))
                           (image (file-append 
                                    %artwork-repository
                                    "/grub/GUIXSD-fully-black-16-9.svg"))))))
    (kernel (customize-linux #:linux linux-libre-arm64-generic))
    (initrd-modules '())
    (file-systems (cons* (file-system 
                           (mount-point "/")
                           (type "ext4")
                           (device (file-system-label "Guix")))
                         (file-system
                           (mount-point "/boot/efi")
                           (type "vfat")
                           (device (file-system-label "EFI")))
                         %base-file-systems))
    (swap-devices (list (swap-space (target "/run/swapfile"))))
    (users (cons* (user-account
                    (name "liszt")
                    (group "users")
                    (supplementary-groups '("wheel" "netdev" "audio" "video"))
                    (home-directory "/home/liszt"))
                  %base-user-accounts))
    (packages (cons* nss-certs openssh %base-packages))
    (services (cons*
                (service avahi-service-type)
                (service dhcp-client-service-type)
                (service ntp-service-type)
                (service openssh-service-type
                         (openssh-configuration 
                           (x11-forwarding? #t)))
                %base-services))
    (name-service-switch %mdns-host-lookup-nss)))

rpi
