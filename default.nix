{ pkgs ? import <nixpkgs> { } }:
{
  deta = pkgs.callPackage ./pkgs/deta { };
  infrared = pkgs.callPackage ./pkgs/infrared { };
  proxmox-backup = pkgs.callPackage ./pkgs/proxmox-backup { };
  ultimmc = pkgs.callPackage ./pkgs/ultimmc { };
  woodpecker = pkgs.callPackage ./pkgs/woodpecker { };
}
