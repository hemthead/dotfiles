# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config
, pkgs
, ...
}: {
  imports = [
    ../../modules/system.nix # import basic every-config stuff

    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  networking.hostName = "z420"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8080 ];
    #extraCommands = ''
    #  iptables -A INPUT -j ACCEPT -p tcp --destination-port 8080 # you might wonder why this `extraCommands` section is here, given 
    #                                                             # the above options. Yeah, I hate myself for wasting an hour on the
    #                                                             # wrong computer...
    #'';
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Bootloader.
  #boot.loader.systemd-boot.enable = true; # overloaded by secure-boot stuff
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    configurationLimit = 5;
  };

  # Configurations for AMDGPU and ROCm setup

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd # OpenCL
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-runtime
    ];
  };

  # Some programs hard-code the path to HIP
  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
    amdvlk = {
      enable = true;
      support32Bit.enable = true;
      supportExperimental.enable = true;
    };
  };

  # virtualization and qemu
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.johndr.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    virtiofsd # file sharing between host and guest
    via # mechanical keyboard config
    piper # gaming mouse config
  ];

  hardware.keyboard.qmk.enable = true;
  services.udev.packages = [ pkgs.via ];

  services.ratbagd.enable = true;

  # OpenCL disabled on 500 series cards by default
  environment.variables = { ROC_ENABLE_PRE_VEGA = "1"; };

  #  virtualisation.virtualbox = {
  #    host.enable = true;
  #    # host.enableExtensionPack = true;
  #    guest.enable = true;
  #    guest.dragAndDrop = true;
  #  };
  #  users.extraGroups.vboxusers.members = [ "johndr" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      espeak-classic # RomanEmpireReminder only

      SDL
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf
      SDL_image
      SDL_mixer
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      bzip2
      cairo
      cups
      curlWithGnuTls
      dbus
      dbus-glib
      desktop-file-utils
      e2fsprogs
      expat
      flac
      fontconfig
      freeglut
      freetype
      fribidi
      fuse
      fuse3
      gdk-pixbuf
      glew110
      glib
      gmp
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      gtk2
      harfbuzz
      icu
      keyutils.lib
      libGL
      libGLU
      libappindicator-gtk2
      libcaca
      libcanberra
      libcap
      libclang.lib
      libdbusmenu
      libdrm
      libgcrypt
      libgpg-error
      libidn
      libjack2
      libjpeg
      libmikmod
      libogg
      libpng12
      libpulseaudio
      librsvg
      libsamplerate
      libthai
      libtheora
      libtiff
      libudev0-shim
      libusb1
      libuuid
      libvdpau
      libvorbis
      libvpx
      libxcrypt-legacy
      libxkbcommon
      libxml2
      mesa
      nspr
      nss
      openssl
      p11-kit
      pango
      pixman
      python3
      speex
      stdenv.cc.cc
      tbb
      udev
      vulkan-loader
      wayland
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXft
      xorg.libXi
      xorg.libXinerama
      xorg.libXmu
      xorg.libXrandr
      xorg.libXrender
      xorg.libXt
      xorg.libXtst
      xorg.libXxf86vm
      xorg.libpciaccess
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      xorg.xkeyboardconfig
      xz
      zlib
      # put dynamic libraries here (?)
    ];
  };

  fonts.packages = with pkgs; [
    comic-relief
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
