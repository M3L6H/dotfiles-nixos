{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];

    networking.hosts = {
      "192.168.1.59" = [ "octopi.local" ];
    };
  };
}
