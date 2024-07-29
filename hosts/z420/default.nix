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

  # Bootloader.
  #boot.loader.systemd-boot.enable = true; # overloaded by secure-boot stuff
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "z420"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    configurationLimit = 5;
  };

  # Configurations for AMDGPU and ROCm setup

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd # OpenCL
    rocmPackages.clr
    rocmPackages.rocminfo
    rocmPackages.rocm-runtime
  ];

  # Some programs hard-code the path to HIP
  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}" ];

  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
    amdvlk = {
      enable = true;
      support32Bit.enable = true;
      supportExperimental.enable = true;
    };
  };

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
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      espeak-classic # RomanEmpireReminder only

      SDL2
      SDL2_ttf
      # put dynamic libraries here (?)
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
