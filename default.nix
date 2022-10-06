{ pkgs ? import <nixpkgs> { } }:

{
  inherit (pkgs.callPackage ./pkgs/cockroachdb { })
    cockroachdb_20_2 cockroachdb_21_1 cockroachdb_21_2;
  cockroachdb = (pkgs.callPackage ./pkgs/cockroachdb { }).cockroachdb_21_2;
  deta = pkgs.callPackage ./pkgs/deta { };
  infrared = pkgs.callPackage ./pkgs/infrared { };
  proxmox-backup = pkgs.callPackage ./pkgs/proxmox-backup { };
  tmm = pkgs.callPackage ./pkgs/tmm { };
  ultimmc = pkgs.callPackage ./pkgs/ultimmc { };
  woodpecker = pkgs.callPackage ./pkgs/woodpecker { };
}
