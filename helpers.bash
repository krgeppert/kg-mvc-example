#!/bin/bash


  # new component fooboo ./app/
component() {
  mkdir $1;
  cd $1;
  mkdir templates;
  mkdir styles;
  mkdir scripts;
  mkdir images;
  mkdir test;
}
