# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, lib, ... }: {
  # get flakes set up from the start this time!
  nix.settings.experimental-features =
    [ "nix-command" "flakes" ]; # Set your time zone.
  time.timeZone = "America/New_York"; # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  }; # Configure keymap in X11
  # delete when wayland?
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # perhaps _this_ is the solution to my touchpad problems?

  # power management stuff
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true; # eventually may be replaced with auto-cpufreq

  fonts.packages = with pkgs; [ nerd-fonts.dejavu-sans-mono dejavu_fonts ];

  boot.loader.systemd-boot.configurationLimit = 10;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
        user = "johndr";
      };

      #initial_session = {
      #command = "sway";
      #user = "johndr";
      #};
    };
  };

  boot.supportedFilesystems = [ "ntfs" ];

  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish.enable = true;
    publish.addresses = true;
  };

  services.udisks2.enable = true; # thonny and other usb stuffs?

  security.pam.services.swaylock = { }; # let swaylock work

  services.pulseaudio.enable = false;
  #  services.power-profiles-daemon.enable = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    #jack.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.config.common.default = "*";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 2d";
  };
  nix.settings.auto-optimise-store = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johndr = {
    isNormalUser = true;
    description = "John Douglas Reed";
    extraGroups = [ "networkmanager" "wheel" "video" "dialout" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    vifm
    hyfetch
    lm_sensors
    links2
    timg
    mpv
    brightnessctl
    p7zip
    tmux
    universal-ctags
    zenith
    clang
    gnumake
    unzip
    zip
    nixfmt
    busybox
  ];

  programs.appimage.binfmt = true;

  # KDE Connect? Wow, this looks awesome!
  programs.kdeconnect.enable = true;

  programs.git = {
    enable = true;
    prompt.enable = true;
  };

  # moar man pages
  documentation.dev.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.EDITOR = "${pkgs.neovim}/bin/nvim";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glibc
      xwayland
      # put dynamic libraries here (?)
    ];
  };

  programs.dconf.enable = true;

  # prevent trackpad from being disabled on lid-close
  # powerManagement.resumeCommands = "${pkgs.kmod}/bin/rmmod atkbd; ${pkgs.kmod}/bin/modprobe atkbd reset=1";
  services.logind.lidSwitch = "lock";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings.PasswordAuthentication = true;
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
