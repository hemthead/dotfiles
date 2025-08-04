# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/system.nix
  ];

  networking.hostName = "opti"; # Define your hostname.
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

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

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
    configurationLimit = 3;
  };

  boot.binfmt.emulatedSystems = [ "x86_64-windows" "aarch64-linux" ];

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
  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

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
  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];
  programs.virt-manager.enable = true;
  users.users.johndr.extraGroups = [ "libvirtd" ];

  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    #virtiofsd # file sharing between host and guest
    via # mechanical keyboard config
    piper # gaming mouse config
  ];

  hardware.keyboard.qmk.enable = true;
  services.udev.packages = [ pkgs.via ];

  services.ratbagd.enable = true;

  # OpenCL disabled on 500 series cards by default
  environment.variables = { ROC_ENABLE_PRE_VEGA = "1"; };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
